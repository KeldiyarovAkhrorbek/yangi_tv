import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:yangi_tv_new/helpers/secure_storage.dart';
import 'package:yangi_tv_new/models/active_tariff.dart';
import 'package:yangi_tv_new/models/merchant_data_click.dart';
import 'package:yangi_tv_new/models/order_model.dart';
import 'package:yangi_tv_new/models/story.dart';
import 'package:yangi_tv_new/models/tariff.dart';
import '../../helpers/constants.dart';
import '../../models/Movie_Short.dart';
import '../../models/banner.dart';
import '../../models/category.dart';
import '../../models/genre.dart';
import '../../models/merchant_data_payme.dart';
import '../../models/movie_full.dart';
import '../../models/profile.dart';
import '../../models/season.dart';
import '../../models/single_movie_url.dart';

class MainRepository {
  Future<String?> sendOTP(String phoneNumberUnmasked) async {
    final response = await Dio().post(
      Constants.baseRegUrl + 'login',
      queryParameters: {
        'login': '998' + phoneNumberUnmasked,
      },
    );
    return response.data['message'];
  }

  Future<String?> resendOTP(String phoneNumberUnmasked) async {
    final response = await Dio().post(
      Constants.baseRegUrl + 'resend',
      queryParameters: {
        'login': '998' + phoneNumberUnmasked,
      },
    );
    return response.data['message'];
  }

  Future<dynamic> checkOTP(String phoneNumberUnmasked, String otp,
      String device_model, String device_name) async {
    final response = await Dio().post(
      Constants.baseRegUrl + 'login',
      queryParameters: {
        'login': '998' + phoneNumberUnmasked,
        'code': otp,
        'device_model': device_model,
        'device_name': device_name,
      },
    );
    return response.data;
  }

  Future<String?> logoutDevice(String token) async {
    final response = await Dio().post(
      Constants.baseRegUrl + 'logout',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    String? responseMessage = response.data['message'];
    return responseMessage;
  }

  Future<List<BannerModel>> getBanners() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getBanners',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    List<BannerModel> banners = [];
    var rawBanners = response.data['data'] as List;
    rawBanners.forEach((element) {
      var b = BannerModel.fromJson(element);
      banners.add(b);
    });
    return banners;
  }

  Future<List<Story>> getStories() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'stories',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    List<Story> stories = [];
    var rawBanners = response.data['data'][0] as List;
    rawBanners.forEach((element) {
      var b = Story.fromJson(element);
      stories.add(b);
    });
    return stories;
  }

  Future<List<Category>> getCategories() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getMain',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    List<Category> categoryList = [];
    var rawMainList = response.data['data'] as List;
    rawMainList.forEach((elMain) {
      var rawMovieList = elMain['list'] as List;
      List<MovieShort> movieList = [];
      var name = elMain['name'] as String;
      var id = elMain['id'] as int;
      rawMovieList.forEach((element) {
        var m = MovieShort.fromJson(element);
        movieList.add(m);
      });
      Category category = Category(id: id, name: name, movies: movieList);
      categoryList.add(category);
    });
    return categoryList;
  }

  Future<List<Genre>> getGenres() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getGenres',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    var rawList = response.data['data']['list'] as List;
    List<Genre> _temp = [];
    rawList.forEach((element) {
      var g = Genre.fromJson(element);
      _temp.add(g);
    });
    return _temp;
  }

  Future<dynamic> getGenreDetail(int genre_id, int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getGenreDetail',
      queryParameters: {
        'genre_id': genre_id,
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<dynamic> getCategoryDetail(int category_id, int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getCategoryDetail',
      queryParameters: {
        'category_id': category_id,
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<dynamic> getFavorites(int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'profile/getFavorites',
      queryParameters: {
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<MovieFull> getMovieDetail(int content_id) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getContentDetail',
      queryParameters: {
        'content_id': content_id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    var movieFull = MovieFull.fromJson(response.data['data']);
    return movieFull;
  }

  Future<List<MovieShort>> getRelatedMovies(int content_id) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'contents/related',
      queryParameters: {
        'content_id': content_id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    List<MovieShort> relatedList = [];
    var rawList = response.data['data']['list'] as List;
    rawList.forEach((element) {
      relatedList.add(MovieShort.fromJson(element));
    });
    return relatedList;
  }

  Future<dynamic> getPersonDetail(int person_id, int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getPersonDetail',
      queryParameters: {
        'person_id': person_id,
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<dynamic> getSearchResult(String search_text, int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'search',
      queryParameters: {
        'search': search_text,
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<Profile> getProfile() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getProfile',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return Profile.fromJson(response.data['data']);
  }

  Future<dynamic> getSessions() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'profile/getSessions',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<List<Tariff>> getTariffs(String filter) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'profile/getTariffs',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    var rawList = response.data['data'] as List;
    List<Tariff> tariffs = [];
    for (var value in rawList) {
      var t = Tariff.fromJson(value);
      tariffs.add(t);
    }
    return tariffs;
  }

  Future<List<MovieShort>> getTestMovies() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getCategoryDetail',
      queryParameters: {
        'content_id': 1,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    var rawList = response.data['data']['list'] as List;
    List<MovieShort> movies = [];
    for (var value in rawList) {
      var t = MovieShort.fromJson(value);
      movies.add(t);
    }
    return movies;
  }

  Future<String> buyTariff(int tariff_id) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().post(
      Constants.baseUrl + 'profile/buyTariff',
      queryParameters: {
        'tariff_id': tariff_id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['message'];
  }

  Future<List<ActiveTariff>> getActiveTariffs() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'profile/getActiveTariffs',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    var rawList = response.data['data'] as List;
    List<ActiveTariff> tariffs = [];
    for (var value in rawList) {
      var t = ActiveTariff.fromJson(value);
      tariffs.add(t);
    }
    return tariffs;
  }

  Future<String?> activatePromocode(String promocode) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().post(
      Constants.baseUrl + 'promocodes/use',
      queryParameters: {
        'promocode': promocode,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data["message"];
  }

  Future<dynamic> getTransactionHistory(int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'history-transactions',
      queryParameters: {
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<List<Season>?> getSeasons(int content_id) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getMovieUrl',
      queryParameters: {
        'content_id': content_id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    if (response.data['code'] == 403) {
      return null;
    }
    var rawList = response.data['data'] as List;
    List<Season> _temp = [];
    rawList.forEach((element) {
      var rawEpisodesList = element['series'] as List;
      var id = element['id'];
      var name = element['name'];
      List<Episode> _tempEp = [];
      rawEpisodesList.forEach((el_EP) {
        var episode = Episode.fromJson(el_EP);
        _tempEp.add(episode);
      });
      var seas = Season(name: name, id: id, episodes: _tempEp);
      _temp.add(seas);
    });
    return _temp;
  }

  Future<SingleMovieUrl?> getSingleMovieURL(int content_id) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getMovieUrl',
      queryParameters: {
        'content_id': content_id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    if (response.data['code'] == 403) {
      return null;
    }
    return SingleMovieUrl.fromJson(response.data['data']);
  }

  Future<String?> putReaction(int content_id, String reaction) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().post(
      Constants.baseUrl + 'contents/${reaction}',
      queryParameters: {
        'content_id': content_id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['message'];
  }

  Future<String?> addToFavorite(int content_id) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().post(
      Constants.baseUrl + 'profile/addToFavorite',
      queryParameters: {
        'content_id': content_id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['message'];
  }

  Future<String?> removeFromFavorite(int content_id) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().delete(
      Constants.baseUrl + 'profile/removeFromFavorite',
      queryParameters: {
        'content_id': content_id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['message'];
  }

  Future<dynamic> getComments(int content_id, int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'getComments',
      queryParameters: {
        'content_id': content_id,
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<String?> addComment(int content_id, String text) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().post(
      Constants.baseUrl + 'addComment',
      queryParameters: {
        'content_id': content_id,
        'text': text,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['message'];
  }

  Future<int> getFileSize(String url) async {
    try {
      Dio dio = Dio();
      Response response = await dio.head(url);
      if (response.statusCode == 200) {
        return int.parse(response.headers['content-length']![0]);
      } else {
        return 0;
      }
    } catch (error) {
      return 0;
    }
  }

  Future<bool> shouldUpdate(String platform, String version) async {
    final response = await Dio().get(
      Constants.baseRegUrl + 'version',
      queryParameters: {
        'platform': platform,
        'version': version,
      },
    );
    return response.data['data']['is_update'] == true;
  }

  Future<String?> postName(String name) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().post(
      Constants.baseRegUrl + 'postName',
      queryParameters: {
        'name': name,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['message'];
  }

  Future<dynamic> getCollections(int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'collections/list',
      queryParameters: {
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<dynamic> getCollectionDetail(int collection_id, int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'collections/contents',
      queryParameters: {
        'collection_id': collection_id,
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<MerchantDataClick> getClickMerchantData() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'vendor-params',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return MerchantDataClick.fromJson(response.data['data']["click"]);
  }

  Future<MerchantDataPayme> getPaymeMerchantData() async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'vendor-params',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return MerchantDataPayme.fromJson(response.data['data']["payme"]);
  }

  Future<dynamic> getOrders(int page) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().get(
      Constants.baseUrl + 'profile/getOrderContent',
      queryParameters: {
        'page': page,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['data'];
  }

  Future<String> addOrder(String name, String year) async {
    String? token = await SecureStorage().getToken();
    final response = await Dio().post(
      Constants.baseUrl + 'profile/addOrderContent',
      queryParameters: {
        'name': name,
        'year': year,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token}',
        },
      ),
    );
    return response.data['message'];
  }
}
