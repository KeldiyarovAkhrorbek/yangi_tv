import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:cast/device.dart';
import 'package:cast/discovery_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yangi_tv_new/database/story_db.dart';
import 'package:yangi_tv_new/helpers/auth_state.dart';
import 'package:yangi_tv_new/helpers/detect_emulator.dart';
import 'package:yangi_tv_new/helpers/secure_storage.dart';
import 'package:yangi_tv_new/models/category.dart';
import 'package:yangi_tv_new/models/collection_model.dart';
import 'package:yangi_tv_new/models/comment.dart';
import 'package:yangi_tv_new/models/genre.dart';
import 'package:yangi_tv_new/models/payment_history.dart';
import 'package:yangi_tv_new/models/search.dart';
import 'package:yangi_tv_new/models/session.dart';

import '../../models/Movie_Short.dart';
import '../../models/banner.dart';
import '../../models/db/database_task.dart';
import '../../models/movie_full.dart';
import '../../models/order_model.dart';
import '../../models/profile.dart';
import '../../models/season.dart';
import '../../models/single_movie_url.dart';
import '../../models/story.dart';
import '../../models/tariff.dart';
import '../repos/mainrepository.dart';
import 'app_events.dart';
import 'app_states.dart';

///login
///login
///login
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final MainRepository _mainRepository;
  String device_name = '';
  String device_model = 'iPhone';
  String phoneNumberUnmasked = '';
  String phoneNumberMasked = '';
  List<SessionModel> sessions = [];
  String otp = '';

  var numberCodes = [
    '94',
    '93',
    '91',
    '90',
    '88',
    '97',
    '99',
    '95',
    '77',
    '50',
    '98',
    '11',
    '33',
    '20',
  ];

  LoginBloc(this._mainRepository)
      : super(EnterPhoneNumberState(isLoading: false, errorText: null)) {
    ///send otp
    on<SendOtpEvent>((event, emit) async {
      try {
        if (event.unmasked.length != 9) {
          emit(EnterPhoneNumberState(
              isLoading: false, errorText: "Telefon raqam kiriting!"));
          return;
        }
        phoneNumberUnmasked = event.unmasked;

        //masked
        String code = phoneNumberUnmasked.substring(0, 2);
        String part1 = phoneNumberUnmasked.substring(2, 5);
        String part2 = phoneNumberUnmasked.substring(5, 7);
        String part3 = phoneNumberUnmasked.substring(7, 9);
        phoneNumberMasked = "+998 ($code) $part1 $part2 $part3";

        if (!numberCodes.contains(code)) {
          emit(EnterPhoneNumberState(
              isLoading: false,
              errorText: "Faqatgina o'zbek raqamlaridan\nfoydalanish mumkin!"));
          return;
        }

        emit(EnterPhoneNumberState(isLoading: true, errorText: null));
        String? message = await _mainRepository.sendOTP(phoneNumberUnmasked);
        if (message == 'Введите код - А хрен тебе!') {
          emit(VerifyState(
            isLoading: false,
            errorText: null,
          ));
        } else {
          emit(EnterPhoneNumberState(
              isLoading: false, errorText: "SMS yuborib bo'lmadi!"));
        }
      } on DioException catch (e) {
        debugPrint('Request URL: ${e.requestOptions.uri}');
        debugPrint('Response Status: ${e.response?.statusCode}');
        debugPrint('Response Data: ${e.response?.data}');
        emit(EnterPhoneNumberState(
            isLoading: false, errorText: "SMS yuborib bo'lmadi!"));
      }
    });

    ///resend otp
    on<ResendOtpEvent>((event, emit) async {
      try {
        await _mainRepository.resendOTP(phoneNumberUnmasked);
      } catch (e) {}
    });

    ///verify
    on<CheckOtpEvent>((event, emit) async {
      try {
        otp = event.otp;
        if (otp.length != 6) {
          emit(VerifyState(
              isLoading: false, errorText: "Iltimos, kodni kiriting!"));
          return;
        }
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          device_model = androidInfo.brand;
          device_name = androidInfo.model;
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          device_name = iosInfo.utsname.machine;
        }

        emit(VerifyState(isLoading: true, errorText: null));
        var data = await _mainRepository.checkOTP(
            phoneNumberUnmasked, otp, device_model, device_name);
        if (data['message'] == 'Не верный код!') {
          emit(VerifyState(
              isLoading: false,
              errorText: "SIZ KIRITGAN KOD NOTO'G'RI! QAYTA TEKSHIRING!"));
        } else if (data['message'] == 'Превышенно количество сессий') {
          var rawList = data['data'] as List;
          List<SessionModel> tempSessionList = [];
          rawList.forEach((element) {
            var s = SessionModel.fromJson(element);
            tempSessionList.add(s);
            sessions = tempSessionList;
          });
          emit(DeleteSessionState(isLoading: false, sessions: sessions));
        } else if (data['message'] == 'Успешно') {
          bool isEmulator = await DetectEmulator().isDeviceEmulator();
          await SecureStorage()
              .storage
              .write(key: 'token', value: data['data'][0]['token']);
          await SecureStorage()
              .storage
              .write(key: 'phone_number_new', value: phoneNumberUnmasked);
          if (phoneNumberUnmasked == '112223344' || isEmulator) {
            emit(SuccessState(true));
            return;
          }
          if (data['data'][0]['name'] == null) {
            emit(ChangeNameState(isLoading: false, errorText: null));
            return;
          }
          emit(SuccessState());
        }
      } catch (e) {
        emit(VerifyState(
            isLoading: false, errorText: "Noma'lum xatolik yuzaga keldi!"));
      }
    });

    ///verify-after-session-delete
    on<CheckOtpDeleteSessionEvent>((event, emit) async {
      try {
        emit(DeleteSessionState(isLoading: true, sessions: sessions));

        var data = await _mainRepository.checkOTP(
            phoneNumberUnmasked, otp, device_model, device_name);
        if (data['message'] == 'Не верный код!') {
          emit(EnterPhoneNumberState(isLoading: false, errorText: null));
        } else if (data['message'] == 'Превышенно количество сессий') {
          var rawList = data['data'] as List;
          List<SessionModel> tempSessionList = [];
          rawList.forEach((element) {
            var s = SessionModel.fromJson(element);
            tempSessionList.add(s);
            sessions = tempSessionList;
          });
          emit(DeleteSessionState(isLoading: false, sessions: sessions));
        } else if (data['message'] == 'Успешно') {
          bool isEmulator = await DetectEmulator().isDeviceEmulator();
          await SecureStorage()
              .storage
              .write(key: 'token', value: data['data'][0]['token']);

          await SecureStorage()
              .storage
              .write(key: 'phone_number_new', value: phoneNumberUnmasked);
          if (phoneNumberUnmasked == '112223344' || isEmulator) {
            emit(SuccessState(true));
            return;
          }

          if (data['data'][0]['name'] == null) {
            emit(ChangeNameState(isLoading: false, errorText: null));
          } else {
            emit(SuccessState());
          }
        }
      } catch (e) {
        emit(DeleteSessionState(isLoading: false, sessions: sessions));
      }
    });

    ///delete-session-event
    on<RemoveSessionEvent>((event, emit) async {
      try {
        emit(DeleteSessionState(isLoading: true, sessions: sessions));

        var message = await _mainRepository.logoutDevice(event.token);
        if (message == 'Вы успешно вышли!') {
          sessions.removeWhere((element) => element.token == event.token);
        }
        emit(DeleteSessionState(isLoading: false, sessions: sessions));
      } catch (e) {
        emit(DeleteSessionState(isLoading: false, sessions: sessions));
      }
    });

    ///changeError
    on<ChangeErrorEvent>((event, emit) async {
      if (event.type == 'sendOtp') {
        emit(EnterPhoneNumberState(
          isLoading: false,
          errorText: null,
        ));
      } else if (event.type == 'verify') {
        emit(VerifyState(
          isLoading: false,
          errorText: null,
        ));
      } else if (event.type == 'changeName') {
        emit(ChangeNameState(
          isLoading: false,
          errorText: null,
        ));
      }
    });

    ///change name
    on<ChangeNameEvent>((event, emit) async {
      try {
        emit(ChangeNameState(isLoading: true, errorText: null));
        if (event.name.length < 2) {
          emit(ChangeNameState(
              isLoading: false, errorText: 'Ism minimal uzunligi: 2 harf'));
          return;
        }
        String? result = await _mainRepository.postName(event.name);
        if (result == 'Успешно!') {
          emit(SuccessState());
          return;
        }
      } catch (e) {
        emit(ChangeNameState(
            isLoading: false, errorText: 'Qandaydir xatolik yuz berdi'));
        return;
      }
    });
  }
}

///testToken
///testToken
///testToken
class TestTokenBloc extends Bloc<TestEvent, TestState> {
  final MainRepository _mainRepository;

  TestTokenBloc(this._mainRepository) : super(TestTokenLoadingState()) {
    var dangerousApps = {
      "com.guoshi.httpcanary": "HTTP Canary",
      "com.gmail.heagoo.apkeditor.pro": "APK Editor Pro",
      "app.greyshirts.sslcapture": "SSL Capture",
      "com.guoshi.httpcanary.premium": "HTTP Canary Premium",
      "com.minhui.networkcapture.pro": "Network Capture Pro",
      "com.minhui.networkcapture": "Network Capture",
      "com.egorovandreyrm.pcapremote": "PCAP Remote",
      "com.packagesniffer.frtparlak": "Package Sniffer",
      "jp.co.taosoftware.android.packetcapture": "Packet Capture",
      "com.emanuelef.remote_capture": "Remote Capture",
      "com.minhui.wifianalyzer": "WiFi Analyzer",
      "com.evbadroid.proxymon": "Sniffer Proxymon",
      "com.evbadroid.wicapdemo": "WiCap Demo",
      "com.evbadroid.wicap": "WiCap",
      "com.luckypatchers.luckypatcherinstaller": "Lucky Patcher Installer",
      "ru.UbLBBRLf.jSziIaUjL": "Mystery App",
      "com.wn.app.np": "Network Parser",
      "gg.now.accounts": "GG Now",
      "gg.now.billing.service": "GG Billing",
      "gg.now.billing.service2": "GG Billing",
      "com.uncube.launcher3": "Torque Launcher",
      "com.uncube.launcher2": "Torque Launcher",
      "com.uncube.launcher1": "Torque Launcher",
      "com.uncube.launcher": "Torque Launcher",
      "com.android.ld.appstore": "LD Player",
      "com.topjohnwu.magisk": "Magisk",
    };

    on<TestTokenEvent>((event, emit) async {
      try {
        emit(TestTokenLoadingState());
        //check pc
        if (!(Platform.isAndroid || Platform.isIOS)) {
          emit(TestTokenDoneState(
            authState: AuthState.PC,
            dangerousAppName: null,
          ));
          return;
        }

        bool isDangerous = false;
        String dangerousAppName = '';

        //check dangerous android
        if (Platform.isAndroid) {
          for (var dangerousPackage in dangerousApps.keys) {
            bool? appIsInstalled =
                await InstalledApps.isAppInstalled(dangerousPackage);
            if (appIsInstalled == true) {
              isDangerous = true;
              dangerousAppName =
                  dangerousApps[dangerousPackage] ?? 'Dangerous app';
              break;
            }
          }
        }

        if (isDangerous) {
          emit(TestTokenDoneState(
            authState: AuthState.DangerousAppDetected,
            dangerousAppName: dangerousAppName,
          ));
          return;
        }

        //check version
        var platform = '';
        if (Platform.isAndroid) {
          platform = 'android';
        } else {
          platform = 'ios';
        }

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        var versionNumber = packageInfo.version;

        var shouldUpdate =
            await _mainRepository.shouldUpdate(platform, versionNumber);
        if (shouldUpdate) {
          emit(TestTokenDoneState(authState: AuthState.NeedUpdateApp));
          return;
        }

        String? token = await SecureStorage().getToken();
        if (token == null) {
          emit(TestTokenDoneState(authState: AuthState.TokenExpired));
          return;
        }

        var profile = await _mainRepository.getProfile();

        //detect emulator or course
        //uncomment this
        String? number = await SecureStorage().getNumber();
        bool isEmulator = await DetectEmulator().isDeviceEmulator();
        if (number == '112223344' || isEmulator) {
          emit(TestTokenDoneState(authState: AuthState.Courses));
          return;
        }

        //final state
        emit(TestTokenDoneState(authState: AuthState.Successful));
      } catch (e) {
        if (e.toString().toLowerCase().contains('socket')) {
          emit(TestTokenDoneState(authState: AuthState.NoInternet));
          return;
        }
        emit(TestTokenDoneState(authState: AuthState.TokenExpired));
        return;
      }
    });
  }
}

///banner and category ///main
///banner and category ///main
///banner and category ///main
class MainBloc extends Bloc<MainEvent, MainState> {
  final MainRepository _mainRepository;
  List<Story> stories = [];
  List<BannerModel> banners = [];
  List<Category> categories = [];
  List<Genre> genres = [];

  MainBloc(this._mainRepository) : super(MainLoadingState()) {
    on<GetMainEvent>((event, emit) async {
      try {
        emit(MainLoadingState());
        banners = await _mainRepository.getBanners();
        categories = await _mainRepository.getCategories();
        stories = await _mainRepository.getStories();
        genres = await _mainRepository.getGenres();
        var fetchAllWatchedStories = await StoryDB().fetchAllWatchedStories();
        stories.forEach((element) {
          if (fetchAllWatchedStories.contains(element.id)) {
            element.watched = true;
          }
        });
        emit(MainSuccessState(
            banners: banners,
            categories: categories,
            stories: stories,
            genres: genres));
      } catch (e) {
        emit(MainErrorState());
      }
    });

    on<WatchStoryEvent>((event, emit) async {
      var watchedIndex =
          stories.indexWhere((element) => event.story_id == element.id);
      stories[watchedIndex].watched = true;
      emit(MainSuccessState(
          banners: banners,
          categories: categories,
          stories: stories,
          genres: genres));
      await StoryDB().create(id: event.story_id);
    });
  }
}

///genre
///genre
///genre
class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final MainRepository _mainRepository;

  GenreBloc(this._mainRepository) : super(GenreLoadingState()) {
    on<GetGenresEvent>((event, emit) async {
      try {
        emit(GenreLoadingState());
        var genres = await _mainRepository.getGenres();
        emit(GenreSuccessState(genres: genres));
      } catch (e) {
        emit(GenreErrorState());
      }
    });
  }
}

///genre-detail
///genre-detail
///genre-detail
class GenreDetailBloc extends Bloc<GenreDetailEvent, GenreDetailState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  int genreID = -1;
  List<MovieShort> genreMovies = [];
  bool isLoading = false;

  GenreDetailBloc(this._mainRepository) : super(GenreDetailLoadingState()) {
    on<GetGenreDetailEvent>((event, emit) async {
      genreID = event.genre_id;
      try {
        var response = await _mainRepository.getGenreDetail(genreID, page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        genreMovies += _temp;
        emit(GenreDetailSuccessState(movies: genreMovies, isPaginating: false));
      } catch (e) {
        emit(GenreDetailErrorState());
      }
    });

    on<PaginateGenreDetailEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(GenreDetailSuccessState(movies: genreMovies, isPaginating: true));
      try {
        page += 1;
        isLoading = true;
        var response = await _mainRepository.getGenreDetail(genreID, page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        genreMovies += _temp;
        emit(GenreDetailSuccessState(movies: genreMovies, isPaginating: false));
      } catch (e) {
        emit(GenreDetailSuccessState(movies: genreMovies, isPaginating: false));
      }
    });
  }
}

///category-detail
///category-detail
///category-detail
class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  int category_id = -1;
  List<MovieShort> category_movies = [];
  bool isLoading = false;

  CategoryDetailBloc(this._mainRepository)
      : super(CategoryDetailLoadingState()) {
    on<GetCategoryDetailEvent>((event, emit) async {
      category_id = event.category_id;
      try {
        //uncomment this
        if (Platform.isAndroid) {
          bool isEmulator = await DetectEmulator().isDeviceEmulator();
          bool isTestNumber = await SecureStorage().getNumber() == '112223344';
          if (isTestNumber) {
            category_id = 11;
          }

          if (!isTestNumber && isEmulator) {
            category_id = 1000;
          }
        }

        emit(CategoryDetailLoadingState());
        category_movies = [];

        var response =
            await _mainRepository.getCategoryDetail(category_id, page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        category_movies += _temp;
        emit(CategoryDetailSuccessState(
            movies: category_movies, isPaginating: false));
      } catch (e) {
        emit(CategoryDetailErrorState(e.toString()));
      }
    });

    on<PaginateCategoryDetailEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(CategoryDetailSuccessState(
          movies: category_movies, isPaginating: true));
      try {
        page += 1;
        isLoading = true;
        var response =
            await _mainRepository.getCategoryDetail(category_id, page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        category_movies += _temp;
        emit(CategoryDetailSuccessState(
            movies: category_movies, isPaginating: false));
      } catch (e) {
        emit(CategoryDetailSuccessState(
            movies: category_movies, isPaginating: false));
      }
    });
  }
}

///favorites
///favorites
///favorites
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  List<MovieShort> favorites = [];
  bool isLoading = false;

  FavoritesBloc(this._mainRepository) : super(FavoritesLoadingState()) {
    on<GetFavoritesEvent>((event, emit) async {
      try {
        page = 0;
        lastPage = -1;
        emit(FavoritesLoadingState());
        var response = await _mainRepository.getFavorites(page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        favorites = _temp;
        emit(FavoritesSuccessState(movies: favorites, isPaginating: false));
      } catch (e) {
        emit(FavoritesErrorState());
      }
    });

    on<PaginateFavoritesEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(FavoritesSuccessState(movies: favorites, isPaginating: true));
      try {
        page += 1;
        isLoading = true;
        var response = await _mainRepository.getFavorites(page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        favorites += _temp;
        emit(FavoritesSuccessState(movies: favorites, isPaginating: false));
      } catch (e) {
        emit(FavoritesSuccessState(movies: favorites, isPaginating: false));
      }
    });
  }
}

///movie_detail
///movie_detail
///movie_detail
class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MainRepository _mainRepository;
  late MovieFull movieFull;
  List<MovieShort> relatedMovies = [];
  late Profile profile;

  ///url
  SingleMovieUrl? singleMovieUrl;
  List<Season>? seasons = [];
  bool isUrlWatchLoaded = false;
  bool isUrlDownloadLoaded = false;
  bool isUrlWatchLoading = false;
  bool isUrlDownloadLoading = false;

  //favorite
  bool isFavorite = false;
  bool favoriteLoading = false;

  //like and dislike
  bool isLikeLoading = false;
  int likeCount = 0;
  int dislikeCount = 0;
  String? reactionType;

  MovieDetailBloc(this._mainRepository) : super(MovieDetailLoadingState()) {
    on<LoadMovieDetailEvent>((event, emit) async {
      try {
        emit(MovieDetailLoadingState());
        isUrlWatchLoaded = false;
        isUrlDownloadLoaded = false;
        isUrlWatchLoading = false;
        log(event.content_id.toString());
        movieFull = await _mainRepository.getMovieDetail(event.content_id);
        relatedMovies =
            await _mainRepository.getRelatedMovies(event.content_id);
        profile = await _mainRepository.getProfile();
        isFavorite = movieFull.is_favorite;
        reactionType = movieFull.reactions.type;
        likeCount = movieFull.reactions.like;
        dislikeCount = movieFull.reactions.dislike;
        emit(
          MovieDetailLoadedState(
            movie: movieFull,
            relatedMovies: relatedMovies,
            errorUrlText: null,
            seasons: [],
            isUrlWatchLoaded: isUrlWatchLoaded,
            singleMovieURL: null,
            isFavorite: isFavorite,
            isUrlDownloadLoaded: isUrlDownloadLoaded,
            favoriteLoading: favoriteLoading,
            isUrlWatchLoading: isUrlWatchLoading,
            isUrlDownloadLoading: isUrlDownloadLoading,
            dislikeCount: dislikeCount,
            likeCount: likeCount,
            reactionType: reactionType,
          ),
        );
      } catch (e) {
        log(e.toString());
        emit(MovieDetailErrorState(e.toString()));
      }
    });

    on<AddToFavoriteEvent>((event, emit) async {
      try {
        favoriteLoading = true;
        if (isFavorite) {
          String? favoriteStatus =
              await _mainRepository.removeFromFavorite(movieFull.id);
          if (favoriteStatus == 'Успешно удалено!') {
            isFavorite = false;
          }
        } else {
          String? favoriteStatus =
              await _mainRepository.addToFavorite(movieFull.id);
          if (favoriteStatus == 'Успешно добавлено') {
            isFavorite = true;
          }
        }
        favoriteLoading = false;
        emit(
          MovieDetailLoadedState(
            movie: movieFull,
            relatedMovies: relatedMovies,
            errorUrlText: null,
            seasons: [],
            isUrlWatchLoaded: isUrlWatchLoaded,
            singleMovieURL: null,
            isFavorite: isFavorite,
            favoriteLoading: favoriteLoading,
            isUrlDownloadLoaded: isUrlDownloadLoaded,
            isUrlWatchLoading: isUrlWatchLoading,
            isUrlDownloadLoading: isUrlDownloadLoading,
            dislikeCount: dislikeCount,
            likeCount: likeCount,
            reactionType: reactionType,
          ),
        );
      } catch (e) {
        favoriteLoading = false;
        emit(
          MovieDetailLoadedState(
            movie: movieFull,
            relatedMovies: relatedMovies,
            errorUrlText: null,
            seasons: [],
            isUrlWatchLoaded: isUrlWatchLoaded,
            singleMovieURL: null,
            isFavorite: isFavorite,
            favoriteLoading: favoriteLoading,
            isUrlDownloadLoaded: isUrlDownloadLoaded,
            isUrlWatchLoading: isUrlWatchLoading,
            isUrlDownloadLoading: isUrlDownloadLoading,
            dislikeCount: dislikeCount,
            likeCount: likeCount,
            reactionType: reactionType,
          ),
        );
      }
    });

    on<LoadMovieUrlEvent>((event, emit) async {
      try {
        isUrlWatchLoaded = false;
        isUrlDownloadLoaded = false;
        isUrlWatchLoading = false;
        isUrlDownloadLoading = false;
        if (event.downloadType == 'watch') {
          isUrlWatchLoading = true;
        } else {
          isUrlDownloadLoading = true;
        }
        emit(MovieDetailLoadedState(
          movie: movieFull,
          relatedMovies: relatedMovies,
          errorUrlText: null,
          seasons: [],
          singleMovieURL: null,
          isUrlWatchLoaded: isUrlWatchLoaded,
          isUrlWatchLoading: isUrlWatchLoading,
          isUrlDownloadLoading: isUrlDownloadLoading,
          isUrlDownloadLoaded: isUrlDownloadLoaded,
          isFavorite: isFavorite,
          favoriteLoading: favoriteLoading,
          dislikeCount: dislikeCount,
          likeCount: likeCount,
          reactionType: reactionType,
        ));
        if (movieFull.type == 'multi') {
          seasons = await _mainRepository.getSeasons(movieFull.id);
          isUrlWatchLoading = false;
          isUrlDownloadLoading = false;
          if (event.downloadType == 'watch') {
            isUrlWatchLoaded = true;
          } else {
            isUrlDownloadLoaded = true;
          }
          if (seasons == null) {
            emit(MovieDetailLoadedState(
              movie: movieFull,
              relatedMovies: relatedMovies,
              errorUrlText: 'notariff',
              seasons: [],
              singleMovieURL: null,
              isUrlWatchLoaded: isUrlWatchLoaded,
              isUrlWatchLoading: isUrlWatchLoading,
              isUrlDownloadLoading: isUrlDownloadLoading,
              isUrlDownloadLoaded: isUrlDownloadLoaded,
              isFavorite: isFavorite,
              favoriteLoading: favoriteLoading,
              dislikeCount: dislikeCount,
              likeCount: likeCount,
              reactionType: reactionType,
            ));
            return;
          } else {
            emit(MovieDetailLoadedState(
              movie: movieFull,
              relatedMovies: relatedMovies,
              errorUrlText: null,
              seasons: seasons!,
              singleMovieURL: null,
              isUrlWatchLoaded: isUrlWatchLoaded,
              isUrlWatchLoading: isUrlWatchLoading,
              isUrlDownloadLoading: isUrlDownloadLoading,
              isFavorite: isFavorite,
              isUrlDownloadLoaded: isUrlDownloadLoaded,
              favoriteLoading: favoriteLoading,
              dislikeCount: dislikeCount,
              likeCount: likeCount,
              reactionType: reactionType,
            ));
            return;
          }
        }

        if (movieFull.type == 'single') {
          singleMovieUrl =
              await _mainRepository.getSingleMovieURL(movieFull.id);
          isUrlWatchLoading = false;
          isUrlDownloadLoading = false;
          if (event.downloadType == 'watch') {
            isUrlWatchLoaded = true;
          } else {
            isUrlDownloadLoaded = true;
          }
          if (singleMovieUrl == null) {
            emit(MovieDetailLoadedState(
              movie: movieFull,
              relatedMovies: relatedMovies,
              errorUrlText: 'notariff',
              seasons: [],
              singleMovieURL: null,
              isUrlWatchLoaded: isUrlWatchLoaded,
              isUrlWatchLoading: isUrlWatchLoading,
              isUrlDownloadLoading: isUrlDownloadLoading,
              isFavorite: isFavorite,
              isUrlDownloadLoaded: isUrlDownloadLoaded,
              favoriteLoading: favoriteLoading,
              dislikeCount: dislikeCount,
              likeCount: likeCount,
              reactionType: reactionType,
            ));
            return;
          } else {
            emit(MovieDetailLoadedState(
              movie: movieFull,
              relatedMovies: relatedMovies,
              errorUrlText: null,
              seasons: [],
              singleMovieURL: singleMovieUrl,
              isUrlWatchLoading: isUrlWatchLoading,
              isUrlDownloadLoading: isUrlDownloadLoading,
              isUrlWatchLoaded: isUrlWatchLoaded,
              isFavorite: isFavorite,
              isUrlDownloadLoaded: isUrlDownloadLoaded,
              favoriteLoading: favoriteLoading,
              dislikeCount: dislikeCount,
              likeCount: likeCount,
              reactionType: reactionType,
            ));
            return;
          }
        }
      } catch (e) {
        isUrlWatchLoaded = true;
        isUrlWatchLoading = false;
        if (e.toString().toLowerCase().contains('socket')) {
          emit(MovieDetailLoadedState(
            movie: movieFull,
            relatedMovies: relatedMovies,
            errorUrlText: 'socket',
            seasons: [],
            singleMovieURL: null,
            isUrlWatchLoading: isUrlWatchLoading,
            isUrlDownloadLoading: isUrlDownloadLoading,
            isUrlWatchLoaded: isUrlWatchLoaded,
            isFavorite: isFavorite,
            favoriteLoading: favoriteLoading,
            dislikeCount: dislikeCount,
            isUrlDownloadLoaded: isUrlDownloadLoaded,
            likeCount: likeCount,
            reactionType: reactionType,
          ));
        } else
          emit(MovieDetailLoadedState(
            movie: movieFull,
            relatedMovies: relatedMovies,
            errorUrlText: 'notariff',
            seasons: [],
            singleMovieURL: null,
            isUrlWatchLoading: isUrlWatchLoading,
            isUrlDownloadLoading: isUrlDownloadLoading,
            isUrlWatchLoaded: isUrlWatchLoaded,
            isFavorite: isFavorite,
            favoriteLoading: favoriteLoading,
            isUrlDownloadLoaded: isUrlDownloadLoaded,
            dislikeCount: dislikeCount,
            likeCount: likeCount,
            reactionType: reactionType,
          ));
      }
    });

    on<PutReactionEvent>((event, emit) async {
      try {
        if (isLikeLoading) return;
        isLikeLoading = true;
        String? result =
            await _mainRepository.putReaction(movieFull.id, event.reaction);
        isLikeLoading = false;
        if (result == null) return;
        if (result.contains('удален')) {
          if (reactionType == 'like') {
            likeCount--;
          }
          if (reactionType == 'dislike') {
            dislikeCount--;
          }
          reactionType = null;
        } else if (result == "Успешно поставили dislike") {
          if (reactionType == 'like') {
            likeCount--;
            dislikeCount++;
          } else {
            dislikeCount++;
          }
          reactionType = 'dislike';
        } else if (result == "Успешно поставили like") {
          if (reactionType == 'dislike') {
            likeCount++;
            dislikeCount--;
          } else {
            likeCount++;
          }
          reactionType = 'like';
        }
        emit(
          MovieDetailLoadedState(
            movie: movieFull,
            relatedMovies: relatedMovies,
            errorUrlText: null,
            seasons: [],
            isUrlWatchLoaded: isUrlWatchLoaded,
            singleMovieURL: null,
            isUrlDownloadLoaded: isUrlDownloadLoaded,
            isFavorite: isFavorite,
            favoriteLoading: favoriteLoading,
            isUrlWatchLoading: isUrlWatchLoading,
            isUrlDownloadLoading: isUrlDownloadLoading,
            dislikeCount: dislikeCount,
            likeCount: likeCount,
            reactionType: reactionType,
          ),
        );
      } catch (e) {
        isLikeLoading = false;
        emit(
          MovieDetailLoadedState(
            movie: movieFull,
            relatedMovies: relatedMovies,
            errorUrlText: null,
            seasons: [],
            isUrlWatchLoaded: isUrlWatchLoaded,
            singleMovieURL: null,
            isFavorite: isFavorite,
            favoriteLoading: favoriteLoading,
            isUrlWatchLoading: isUrlWatchLoading,
            isUrlDownloadLoading: isUrlDownloadLoading,
            dislikeCount: dislikeCount,
            isUrlDownloadLoaded: isUrlDownloadLoaded,
            likeCount: likeCount,
            reactionType: reactionType,
          ),
        );
      }
    });
  }
}

///person-detail
///person-detail
///person-detail
class PersonDetailBloc extends Bloc<PersonDetailEvent, PersonDetailState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  int person_id = -1;
  List<MovieShort> person_movies = [];
  bool isLoading = false;

  PersonDetailBloc(this._mainRepository) : super(PersonDetailLoadingState()) {
    on<GetPersonDetailEvent>((event, emit) async {
      person_id = event.person_id;
      try {
        var response = await _mainRepository.getPersonDetail(person_id, page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        person_movies = _temp;
        emit(PersonDetailSuccessState(
            movies: person_movies, isPaginating: false));
      } catch (e) {
        emit(PersonDetailErrorState());
      }
    });

    on<PaginatePersonDetailEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(PersonDetailSuccessState(movies: person_movies, isPaginating: true));
      try {
        page += 1;
        isLoading = true;
        var response = await _mainRepository.getPersonDetail(person_id, page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        person_movies += _temp;
        emit(PersonDetailSuccessState(
            movies: person_movies, isPaginating: false));
      } catch (e) {
        emit(PersonDetailSuccessState(
            movies: person_movies, isPaginating: false));
      }
    });
  }
}

///search
///search
///search
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  String search_text = '';
  List<Search> search_movies = [];
  bool isLoading = false;

  SearchBloc(this._mainRepository) : super(SearchInitialState()) {
    on<GetSearchEvent>((event, emit) async {
      search_text = event.search_text;
      if (search_text.length < 2) {
        emit(SearchErrorInsufficientState());
        return;
      }
      try {
        page = 0;
        emit(SearchLoadingState());
        var response = await _mainRepository.getSearchResult(search_text, page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<Search> _temp = [];
        rawList.forEach((element) {
          var g = Search.fromJson(element);
          _temp.add(g);
        });
        search_movies = _temp;
        emit(SearchSuccessState(movies: search_movies, isPaginating: false));
      } catch (e) {
        emit(SearchErrorState());
      }
    });

    on<PaginateSearchEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(SearchSuccessState(movies: search_movies, isPaginating: true));
      try {
        page += 1;
        isLoading = true;
        var response = await _mainRepository.getSearchResult(search_text, page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<Search> _temp = [];
        rawList.forEach((element) {
          var g = Search.fromJson(element);
          _temp.add(g);
        });
        search_movies += _temp;
        emit(SearchSuccessState(movies: search_movies, isPaginating: false));
      } catch (e) {
        emit(SearchSuccessState(movies: search_movies, isPaginating: false));
      }
    });
  }
}

///profile
///profile
///profile
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final MainRepository _mainRepository;

  ProfileBloc(this._mainRepository) : super(ProfileLoadingState()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        var profile = await _mainRepository.getProfile();
        emit(ProfileSuccessState(profile: profile));
      } catch (e) {
        emit(ProfileErrorState());
      }
    });

    on<LogoutProfileEvent>((event, emit) async {
      try {
        String? token = await SecureStorage().getToken();
        if (token != null) await _mainRepository.logoutDevice(token);
        SecureStorage().deleteSecureData('token');
      } catch (e) {}
    });
  }
}

///session
///session
///session
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final MainRepository _mainRepository;
  late SessionModel current;
  List<SessionModel> sessions = [];

  SessionBloc(this._mainRepository) : super(SessionLoadingState()) {
    on<GetSessionEvent>((event, emit) async {
      try {
        var rawData = await _mainRepository.getSessions();
        current = SessionModel.fromJson(rawData['current']);
        var sRawList = rawData['list'] as List;
        sRawList.forEach((element) {
          var s = SessionModel.fromJson(element);
          sessions.add(s);
        });
        emit(SessionSuccessState(
          current: current,
          sessions: sessions,
        ));
      } catch (e) {
        emit(SessionErrorState());
      }
    });
    on<LogoutSessionEvent>((event, emit) async {
      try {
        emit(SessionLoadingState());
        var message = await _mainRepository.logoutDevice(event.token);
        if (message == 'Вы успешно вышли!') {
          sessions.removeWhere((element) => element.token == event.token);
        }
        emit(SessionSuccessState(
          current: current,
          sessions: sessions,
        ));
      } catch (e) {
        emit(SessionSuccessState(
          current: current,
          sessions: sessions,
        ));
      }
    });
  }
}

///payment
///payment
///payment
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final MainRepository _mainRepository;

  PaymentBloc(this._mainRepository) : super(PaymentInitialState()) {
    on<GetUrlEvent>((event, emit) async {
      try {
        if (event.amount == null || event.amount! < 1000) {
          emit(PaymentErrorState("Minimal miqdor 1000 UZS."));
          return;
        }
        if (event.method == 'payme') {
          var paymeMerchantData = await _mainRepository.getPaymeMerchantData();
          Codec<String, String> stringToBase64 = utf8.fuse(base64);
          final decoded =
              "m=${paymeMerchantData.merchantId};ac.account_id=${event.userID};a=${event.amount! * 100}";
          final encoded = stringToBase64.encode(decoded);
          final link = "https://checkout.paycom.uz/$encoded";
          emit(PaymentSuccessState(link: link));
        } else if (event.method == 'click') {
          var clickMerchantData = await _mainRepository.getClickMerchantData();
          final link =
              "https://my.click.uz/services/pay?service_id=${clickMerchantData.serviceId}&merchant_id=${clickMerchantData.merchantId}&amount=${event.amount}&transaction_param=${event.userID}&return_url=https://click.uz&card_type";
          emit(PaymentSuccessState(link: link));
        } else if (event.method == 'upay') {
          final link =
              "https://pay.smst.uz/prePay.do?serviceId=1506&apiVersion=1&amount=${event.amount}&personalAccount=${event.userID}";
          emit(PaymentSuccessState(link: link));
        }
      } catch (e) {
        emit(PaymentErrorState("Noma'lum xatolik yuz berdi"));
      }
    });

    on<ChangePaymentErrorEvent>((event, emit) async {
      emit(PaymentInitialState());
    });
  }
}

///tariff
///tariff
///tariff
class TariffBloc extends Bloc<TariffsEvent, TariffState> {
  final MainRepository _mainRepository;
  late Profile profile;
  List<Tariff> tariffs = [];
  bool isBuyingTariff = false;

  TariffBloc(this._mainRepository) : super(TariffLoadingState()) {
    on<GetTariffsEvent>((event, emit) async {
      try {
        emit(TariffLoadingState());
        profile = await _mainRepository.getProfile();
        tariffs = await _mainRepository.getTariffs(event.tariffFilter);
        emit(TariffSuccessState(
          errorText: null,
          isBuyingTariff: isBuyingTariff,
          profile: profile,
          tariffs: tariffs,
          boughtTariff: false,
        ));
      } catch (e) {
        emit(TariffErrorState("Noma'lum xatolik yuz berdi"));
      }
    });

    on<BuyTariffEvent>((event, emit) async {
      try {
        isBuyingTariff = true;
        emit(TariffSuccessState(
          errorText: null,
          isBuyingTariff: isBuyingTariff,
          profile: profile,
          tariffs: tariffs,
          boughtTariff: false,
        ));
        String message = await _mainRepository.buyTariff(event.tariff.id);
        isBuyingTariff = false;
        if (message.contains('evaziga')) {
          emit(TariffSuccessState(
            errorText: null,
            isBuyingTariff: isBuyingTariff,
            profile: profile,
            tariffs: tariffs,
            boughtTariff: true,
          ));
        } else {
          emit(TariffSuccessState(
            errorText: message,
            isBuyingTariff: isBuyingTariff,
            profile: profile,
            tariffs: tariffs,
            boughtTariff: false,
          ));
        }
      } catch (e) {
        isBuyingTariff = false;
        emit(TariffSuccessState(
          errorText: e.toString(),
          isBuyingTariff: isBuyingTariff,
          profile: profile,
          tariffs: tariffs,
          boughtTariff: false,
        ));
      }
    });

    on<ChangeDefaultBuyTariffEvent>((event, emit) async {
      isBuyingTariff = false;
      emit(TariffSuccessState(
        errorText: null,
        isBuyingTariff: isBuyingTariff,
        profile: profile,
        tariffs: tariffs,
        boughtTariff: false,
      ));
    });
  }
}

///active_tariff
///active_tariff
///active_tariff
class ActiveTariffsBloc extends Bloc<ActiveTariffsEvent, ActiveTariffState> {
  final MainRepository _mainRepository;

  ActiveTariffsBloc(this._mainRepository) : super(ActiveTariffLoadingState()) {
    on<GetActiveTariffsEvent>((event, emit) async {
      try {
        var active_tariffs = await _mainRepository.getActiveTariffs();
        emit(ActiveTariffSuccessState(active_tariffs: active_tariffs));
      } catch (e) {
        emit(ActiveTariffErrorState());
      }
    });
  }
}

///active_tariff
///active_tariff
///active_tariff
class PromocodeBloc extends Bloc<PromocodeEvent, PromocodeState> {
  final MainRepository _mainRepository;

  PromocodeBloc(this._mainRepository) : super(PromocodeInitialState()) {
    on<ActivatePromocodeEvent>((event, emit) async {
      try {
        if (event.promocode.length == 0) {
          emit(PromocodeErrorState("Iltimos, promokod kiriting!"));
          return;
        }
        emit(PromocodeLoadingState());
        var message = await _mainRepository.activatePromocode(event.promocode);
        if (message != null && message.contains('Tabriklaymiz')) {
          emit(PromocodeSuccessState());
        } else {
          emit(PromocodeErrorState(message!));
        }
      } catch (e) {
        emit(PromocodeErrorState("Qandaydir xatolik yuz berdi!"));
      }
    });

    on<DefaultPromocodeEvent>((event, emit) async {
      emit(PromocodeInitialState());
    });
  }
}

///payment_history
///payment_history
///payment_history
class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  List<PaymentHistory> paymentList = [];
  bool isLoading = false;

  PaymentHistoryBloc(this._mainRepository)
      : super(PaymentHistoryLoadingState()) {
    on<GetPaymentHistoryEvent>((event, emit) async {
      try {
        var response = await _mainRepository.getTransactionHistory(page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<PaymentHistory> _temp = [];
        rawList.forEach((element) {
          var g = PaymentHistory.fromJson(element);
          _temp.add(g);
        });
        paymentList = _temp;
        emit(PaymentHistorySuccessState(
            historyList: paymentList, isPaginating: false));
      } catch (e) {
        emit(PaymentHistoryErrorState());
      }
    });

    on<PaginatePaymentHistoryEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(PaymentHistorySuccessState(
          historyList: paymentList, isPaginating: true));
      try {
        page += 1;
        isLoading = true;
        var response = await _mainRepository.getTransactionHistory(page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<PaymentHistory> _temp = [];
        rawList.forEach((element) {
          var g = PaymentHistory.fromJson(element);
          _temp.add(g);
        });
        paymentList += _temp;
        emit(PaymentHistorySuccessState(
            historyList: paymentList, isPaginating: false));
      } catch (e) {
        emit(PaymentHistorySuccessState(
            historyList: paymentList, isPaginating: false));
      }
    });
  }
}

///comment
///comment
///comment
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  int content_id = -1;
  List<Comment> comments = [];
  bool isLoading = false;

  CommentBloc(this._mainRepository) : super(CommentLoadingState()) {
    on<GetCommentEvent>((event, emit) async {
      content_id = event.content_id;
      try {
        var response = await _mainRepository.getComments(content_id, page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<Comment> _temp = [];
        rawList.forEach((element) {
          var g = Comment.fromJson(element);
          _temp.add(g);
        });
        comments = _temp;
        emit(CommentSuccessState(
          comments: comments,
          isPaginating: false,
          newComment: false,
        ));
      } catch (e) {
        emit(CommentErrorState());
      }
    });

    on<PaginateCommentEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(CommentSuccessState(
        comments: comments,
        isPaginating: true,
        newComment: false,
      ));
      try {
        page += 1;
        isLoading = true;
        var response = await _mainRepository.getComments(content_id, page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<Comment> _temp = [];
        rawList.forEach((element) {
          var g = Comment.fromJson(element);
          _temp.add(g);
        });
        comments += _temp;
        emit(CommentSuccessState(
          comments: comments,
          isPaginating: false,
          newComment: false,
        ));
      } catch (e) {
        emit(CommentSuccessState(
          comments: comments,
          isPaginating: false,
          newComment: false,
        ));
      }
    });

    on<AddCommentEvent>((event, emit) async {
      try {
        String? result =
            await _mainRepository.addComment(event.content_id, event.text);
        DateTime now = DateTime.now();

        String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(now);
        if (result == 'Успешно добавлено!') {
          comments.insert(
            0,
            Comment(
                id: 1,
                name: '@me',
                login: '',
                photo: 'https://admin.yangi.tv/uploads/avatars/default.png',
                text: event.text,
                date: formattedDate),
          );
          emit(CommentSuccessState(
            comments: comments,
            isPaginating: false,
            newComment: true,
          ));
        }
      } catch (e) {
        emit(CommentSuccessState(
          comments: comments,
          isPaginating: false,
          newComment: false,
        ));
      }
    });
  }
}

///download
///download
///download
class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final MainRepository _mainRepository;
  List<DatabaseTask> all_tasks = [];
  DateTime time = DateTime.now();

  DownloadBloc(this._mainRepository)
      : super(DownloadState(
          tasks: [],
          time: DateTime.now(),
        )) {
    on<AddDownloadEvent>((event, emit) async {
      var taskIndex = -1;
      taskIndex = all_tasks.indexWhere((element) => element.url == event.url);
      if (taskIndex != -1) return;

      final Directory directory = await getApplicationSupportDirectory();

      int fileSize = await _mainRepository.getFileSize(event.url);

      Map<String, dynamic> meta_data_map = {
        'movie_name': event.movie_name,
        'name': event.name,
        'image': event.image,
        'season_name': event.seasonName,
        'size': fileSize,
        'tariff': event.tariff,
        'is_multi': event.is_multi,
      };

      final task = DownloadTask(
        url: event.url,
        filename: event.url.substring(event.url.lastIndexOf("/") + 1),
        updates: Updates.statusAndProgress,
        requiresWiFi: false,
        retries: 10,
        displayName: event.displayName,
        baseDirectory: Platform.isAndroid
            ? BaseDirectory.temporary
            : BaseDirectory.applicationLibrary,
        allowPause: true,
        metaData: jsonEncode(meta_data_map),
      );

      var result = await FileDownloader().enqueue(task);
      if (result)
        all_tasks.add(DatabaseTask(
          taskId: task.taskId,
          movieName: meta_data_map['movie_name'],
          name: meta_data_map['name'],
          displayName: task.displayName,
          url: task.url,
          size: 0,
          tariff: event.tariff,
          image: event.image,
          networkSpeed: 0,
          progress: 0,
          status: TaskStatus.enqueued,
          remainingTime: 0,
          is_multi: event.is_multi,
          seasonName: event.seasonName,
          path: '',
        ));
    });

    on<DownloadTaskStatusUpdateEvent>((event, emit) async {
      var index = -1;
      index = all_tasks
          .indexWhere((element) => element.taskId == event.update.task.taskId);
      if (index == -1) {
        return;
      }
      all_tasks[index].status = event.update.status;
      all_tasks[index].path = await event.update.task.filePath();
      if (event.update.status == TaskStatus.canceled ||
          event.update.status == TaskStatus.notFound ||
          event.update.status == TaskStatus.failed) {
        await FileDownloader().cancelTaskWithId(event.update.task.taskId);
        await FileDownloader()
            .database
            .deleteRecordWithId(event.update.task.taskId);
        all_tasks.removeWhere(
            (element) => element.taskId == event.update.task.taskId);
      }

      emit(DownloadState(
        tasks: all_tasks,
        time: DateTime.now(),
      ));
    });

    on<DownloadTaskProgressUpdateEvent>((event, emit) async {
      var index = -1;
      index = all_tasks
          .indexWhere((element) => element.taskId == event.update.task.taskId);
      if (index == -1) {
        return;
      }
      if (event.update.progress > 0)
        all_tasks[index].progress = event.update.progress;
      if (event.update.expectedFileSize > 0)
        all_tasks[index].size = event.update.expectedFileSize;
      if (event.update.networkSpeed > 0)
        all_tasks[index].networkSpeed = event.update.networkSpeed;
      all_tasks[index].remainingTime = event.update.timeRemaining.inSeconds;

      emit(DownloadState(
        tasks: all_tasks,
        time: DateTime.now(),
      ));
    });

    on<UpdateDownloadsEvent>((event, emit) async {
      emit(DownloadState(
        tasks: all_tasks,
        time: DateTime.now(),
      ));
    });

    on<SetTasksEvent>((event, emit) async {
      all_tasks = event.tasks;
      emit(DownloadState(
        tasks: all_tasks,
        time: DateTime.now(),
      ));
    });

    on<ResumeTaskEvent>((event, emit) async {
      var task = await FileDownloader().taskForId(event.taskId);
      if (task != null) {
        await FileDownloader().resume(DownloadTask(
          url: task.url,
          metaData: task.metaData,
          headers: task.headers,
          allowPause: task.allowPause,
          baseDirectory: task.baseDirectory,
          creationTime: task.creationTime,
          directory: task.directory,
          displayName: task.displayName,
          filename: task.filename,
          group: task.group,
          httpRequestMethod: task.httpRequestMethod,
          post: task.post,
          priority: task.priority,
          taskId: task.taskId,
          retries: task.retries,
          requiresWiFi: task.requiresWiFi,
          updates: task.updates,
        ));
      }
    });

    on<PauseTaskEvent>((event, emit) async {
      var task = await FileDownloader().taskForId(event.taskId);
      if (task != null) {
        await FileDownloader().pause(DownloadTask(
          url: task.url,
          metaData: task.metaData,
          headers: task.headers,
          allowPause: task.allowPause,
          baseDirectory: task.baseDirectory,
          creationTime: task.creationTime,
          directory: task.directory,
          displayName: task.displayName,
          filename: task.filename,
          group: task.group,
          httpRequestMethod: task.httpRequestMethod,
          post: task.post,
          priority: task.priority,
          taskId: task.taskId,
          retries: task.retries,
          requiresWiFi: task.requiresWiFi,
          updates: task.updates,
        ));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      final Directory directory = await getApplicationSupportDirectory();
      var taskRecord =
          await FileDownloader().database.recordForId(event.taskId);
      if (taskRecord == null) return;
      if (taskRecord.status == TaskStatus.complete) {
        all_tasks.removeWhere((element) => element.taskId == event.taskId);
        await FileDownloader().database.deleteRecordWithId(event.taskId);
        File file = File(
          directory.path +
              directory.path +
              '/' +
              taskRecord.task.url
                  .substring(taskRecord.task.url.lastIndexOf("/") + 1),
        );
        var exists = await file.exists();
        if (exists) await file.delete();
      } else {
        all_tasks.removeWhere((element) => element.taskId == event.taskId);
        await FileDownloader().cancelTaskWithId(event.taskId);
        await FileDownloader().database.deleteRecordWithId(event.taskId);
      }

      emit(DownloadState(tasks: all_tasks, time: DateTime.now()));
    });
  }
}

///collection
///collection
///collection
class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  List<CollectionModel> collections = [];
  bool isLoading = false;

  CollectionBloc(this._mainRepository) : super(CollectionLoadingState()) {
    on<GetCollectionsEvent>((event, emit) async {
      emit(CollectionLoadingState());
      page = 0;
      try {
        var response = await _mainRepository.getCollections(page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<CollectionModel> _temp = [];
        rawList.forEach((element) {
          var g = CollectionModel.fromJson(element);
          _temp.add(g);
        });
        collections = _temp;
        emit(CollectionSuccessState(
          collections: collections,
          isPaginating: false,
        ));
      } catch (e) {
        emit(CollectionErrorState());
      }
    });

    on<PaginateCollectionEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(CollectionSuccessState(
        collections: collections,
        isPaginating: true,
      ));
      try {
        page += 1;
        isLoading = true;
        var response = await _mainRepository.getCollections(page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<CollectionModel> _temp = [];
        rawList.forEach((element) {
          var g = CollectionModel.fromJson(element);
          _temp.add(g);
        });
        collections += _temp;
        emit(CollectionSuccessState(
          collections: collections,
          isPaginating: false,
        ));
      } catch (e) {
        emit(CollectionSuccessState(
          collections: collections,
          isPaginating: false,
        ));
      }
    });
  }
}

///collection_detail
///collection_detail
///collection_detail
class CollectionDetailBloc
    extends Bloc<CollectionDetailEvent, CollectionDetailState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  int collection_id = -1;
  List<MovieShort> collection_movies = [];
  bool isLoading = false;

  CollectionDetailBloc(this._mainRepository)
      : super(CollectionDetailLoadingState()) {
    on<GetCollectionDetailEvent>((event, emit) async {
      collection_id = event.collection_id;
      try {
        var response =
            await _mainRepository.getCollectionDetail(collection_id, page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        collection_movies = _temp;
        emit(CollectionDetailSuccessState(
            movies: collection_movies, isPaginating: false));
      } catch (e) {
        emit(CollectionDetailErrorState());
      }
    });

    on<PaginateCollectionDetailEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(CollectionDetailSuccessState(
          movies: collection_movies, isPaginating: true));
      try {
        page += 1;
        isLoading = true;
        var response =
            await _mainRepository.getCollectionDetail(collection_id, page);
        isLoading = false;
        lastPage = response['lastPage'];
        var rawList = response['list'] as List;
        List<MovieShort> _temp = [];
        rawList.forEach((element) {
          var g = MovieShort.fromJson(element);
          _temp.add(g);
        });
        collection_movies += _temp;
        emit(CollectionDetailSuccessState(
            movies: collection_movies, isPaginating: false));
      } catch (e) {
        emit(CollectionDetailSuccessState(
            movies: collection_movies, isPaginating: false));
      }
    });
  }
}

///cast
///cast
///cast
class CastBloc extends Bloc<CastEvent, CastState> {
  final MainRepository _mainRepository;
  List<CastDevice> castDeviceList = [];

  CastBloc(this._mainRepository) : super(CastLoadingState()) {
    on<GetCastDevicesEvent>((event, emit) async {
      try {
        emit(CastLoadingState());
        var castDeviceList = await CastDiscoveryService().search();
        castDeviceList = castDeviceList;
        emit(CastSuccessState(devices: castDeviceList));
      } catch (e) {
        emit(CastErrorState());
      }
    });
  }
}

//orders
//orders
//orders
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final MainRepository _mainRepository;
  int page = 0;
  int lastPage = -1;
  List<OrderModel> orders = [];
  bool isLoading = false;
  String? errorYear;
  String? errorName;

  OrdersBloc(this._mainRepository) : super(OrdersLoadingState()) {
    on<LoadOrdersEvent>((event, emit) async {
      try {
        var response = await _mainRepository.getOrders(page);
        lastPage = response['lastPage'];
        page = response['currentPage'];
        List<OrderModel> tempList = [];
        response['list'].forEach((element) {
          var ord = OrderModel.fromJson(element);
          tempList.add(ord);
        });
        orders += tempList;
        emit(
          OrdersLoadedState(
            orders: orders,
            addingOrder: false,
            isPaginating: false,
            orderAdded: false,
            errorName: null,
            errorYear: null,
          ),
        );
      } catch (e) {
        emit(OrdersErrorState());
      }
    });

    on<PaginateOrdersEvent>((event, emit) async {
      if (page == lastPage || isLoading) {
        return;
      }
      emit(
        OrdersLoadedState(
          orders: orders,
          addingOrder: false,
          isPaginating: true,
          orderAdded: false,
          errorName: null,
          errorYear: null,
        ),
      );
      try {
        page += 1;
        isLoading = true;
        var response = await _mainRepository.getOrders(page);
        isLoading = false;
        lastPage = response['lastPage'];
        List<OrderModel> tempList = [];
        response['list'].forEach((element) {
          var ord = OrderModel.fromJson(element);
          tempList.add(ord);
        });
        orders += tempList;
        emit(
          OrdersLoadedState(
            orders: orders,
            addingOrder: false,
            isPaginating: false,
            orderAdded: false,
            errorName: null,
            errorYear: null,
          ),
        );
      } catch (e) {
        emit(OrdersErrorState());
      }
    });

    on<AddOrderEvent>((event, emit) async {
      emit(
        OrdersLoadedState(
          orders: orders,
          addingOrder: true,
          isPaginating: false,
          orderAdded: false,
          errorName: null,
          errorYear: null,
        ),
      );
      try {
        String message = await _mainRepository.addOrder(event.name, event.year);
        var isAdded = message == "Успешно!";
        if (isAdded) {
          orders.insert(
            0,
            OrderModel(
              id: 1,
              name: event.name,
              status: 'opened',
              contentId: null,
            ),
          );
          emit(
            OrdersLoadedState(
              orders: orders,
              addingOrder: false,
              isPaginating: false,
              orderAdded: true,
              errorName: null,
              errorYear: null,
            ),
          );
        } else if (message == "Превышен лимит") {
          emit(
            OrdersLoadedState(
              orders: orders,
              addingOrder: false,
              isPaginating: false,
              orderAdded: false,
              errorName: "10 kun ichida faqat 1 ta buyurtma berish mumkin!",
              errorYear: null,
            ),
          );
        } else {
          emit(
            OrdersLoadedState(
              orders: orders,
              addingOrder: false,
              isPaginating: false,
              orderAdded: false,
              errorName: "Qandaydir xatolik yuz berdi",
              errorYear: null,
            ),
          );
        }
      } catch (e) {
        emit(
          OrdersLoadedState(
            orders: orders,
            addingOrder: false,
            isPaginating: false,
            orderAdded: false,
            errorName: "Qandaydir xatolik yuz berdi, keyinroq urining!",
            errorYear: null,
          ),
        );
      }
    });

    on<ChangeOrderNameErrorEvent>((event, emit) async {
      errorName = event.errorName;
      emit(
        OrdersLoadedState(
          orders: orders,
          addingOrder: false,
          isPaginating: false,
          orderAdded: false,
          errorName: event.errorName,
          errorYear: errorYear,
        ),
      );
    });

    on<ChangeOrderYearErrorEvent>((event, emit) async {
      errorYear = event.errorYear;
      emit(
        OrdersLoadedState(
          orders: orders,
          addingOrder: false,
          isPaginating: false,
          orderAdded: false,
          errorName: errorName,
          errorYear: event.errorYear,
        ),
      );
    });
  }
}
