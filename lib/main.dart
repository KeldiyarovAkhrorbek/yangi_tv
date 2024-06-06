import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/helpers/secure_storage.dart';
import 'package:yangi_tv_new/ui/views/auth/change_username_page.dart';
import 'package:yangi_tv_new/ui/views/auth/phone_number_page.dart';
import 'package:yangi_tv_new/ui/views/auth/session_delete_page.dart';
import 'package:yangi_tv_new/ui/views/auth/sms_verify_page.dart';
import 'package:yangi_tv_new/ui/views/category_detail/category_detail_page.dart';
import 'package:yangi_tv_new/ui/views/collection_detail/collection_detail_page.dart';
import 'package:yangi_tv_new/ui/views/comment/comment_page.dart';
import 'package:yangi_tv_new/ui/views/courses/courses_page.dart';
import 'package:yangi_tv_new/ui/views/genre_detail/genre_detail_page.dart';
import 'package:yangi_tv_new/ui/views/landing/landing_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/download/multi/multi_download_episodes_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/download/multi/multi_download_season_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/download/single/single_download_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/movie_detail_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/screenshot_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/watch/offline/video_player_page_offline.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/youtube_player_page.dart';
import 'package:yangi_tv_new/ui/views/navigation/navigation_page.dart';
import 'package:yangi_tv_new/ui/views/person_detail/person_detail_page.dart';
import 'package:yangi_tv_new/ui/views/profile/active_tariffs/active_tariffs_page.dart';
import 'package:yangi_tv_new/ui/views/profile/downloads/downloads_page.dart';
import 'package:yangi_tv_new/ui/views/profile/downloads/multi/downloaded_season_episodes_page.dart';
import 'package:yangi_tv_new/ui/views/profile/downloads/multi/downloaded_seasons_page.dart';
import 'package:yangi_tv_new/ui/views/profile/downloads/single/downloaded_qualities_page.dart';
import 'package:yangi_tv_new/ui/views/profile/fill_balance/fill_balance_page.dart';
import 'package:yangi_tv_new/ui/views/profile/payment_history/payment_history_page.dart';
import 'package:yangi_tv_new/ui/views/profile/session/session_page.dart';
import 'package:yangi_tv_new/ui/views/profile/tariffs_page/tariffs_page.dart';
import 'package:yangi_tv_new/ui/views/splash_page/splash_page.dart';
import 'package:yangi_tv_new/ui/views/story/story_watch_page.dart';

import 'bloc/blocs/app_blocs.dart';
import 'bloc/repos/mainrepository.dart';
import 'firebase_options.dart';
import 'ui/views/movie_detail/watch/multi/seasons_page.dart';
import 'ui/views/movie_detail/watch/multi/video_player_page_multi.dart';
import 'ui/views/movie_detail/watch/single/video_player_page_single.dart';
import 'package:permission_handler/permission_handler.dart'
as permission_handler;

late FlutterLocalNotificationsPlugin flutternotifications;
late AndroidNotificationChannel channel;
late FirebaseMessaging fireMessaging;
bool isNotificationInit = false;
late String token;
late String initialMessage;
late String message;
late bool _resolved;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  permission_handler.PermissionStatus status =
  await Permission.notification.request();
  if (!status.isGranted && Platform.isAndroid) {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String? databaseCleared50 = await SecureStorage().readSecureData('cleared50');
  String buildNumber = packageInfo.buildNumber;
  var versionNumber = int.tryParse(buildNumber) ?? 0;
  if (versionNumber == 50 && databaseCleared50 == null) {
    await SecureStorage().writeSecureData('cleared50', 'cleared50');
    await FileDownloader().database.deleteAllRecords();
  }

  await FileDownloader().trackTasks();
  FileDownloader().configureNotification(
    running: TaskNotification('Yuklanmoqda...', '{displayName}'),
    complete: TaskNotification("Yuklab bo'lindi...", '{displayName}'),
    error: TaskNotification("Bekor qilindi...", '{displayName}'),
    tapOpensFile: false,
    progressBar: true,
  );
  GoogleFonts.config.allowRuntimeFetching = false;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(MainRepository()),
        ),
        BlocProvider<TestTokenBloc>(
          create: (context) => TestTokenBloc(MainRepository()),
        ),
        BlocProvider<MainBloc>(
          create: (context) => MainBloc(MainRepository()),
        ),
        BlocProvider<GenreBloc>(
          create: (context) => GenreBloc(MainRepository()),
        ),
        BlocProvider<GenreDetailBloc>(
          create: (context) => GenreDetailBloc(MainRepository()),
        ),
        BlocProvider<CategoryDetailBloc>(
          create: (context) => CategoryDetailBloc(MainRepository()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => FavoritesBloc(MainRepository()),
        ),
        BlocProvider<MovieDetailBloc>(
          create: (context) => MovieDetailBloc(MainRepository()),
        ),
        BlocProvider<PersonDetailBloc>(
          create: (context) => PersonDetailBloc(MainRepository()),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(MainRepository()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(MainRepository()),
        ),
        BlocProvider<SessionBloc>(
          create: (context) => SessionBloc(MainRepository()),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => PaymentBloc(MainRepository()),
        ),
        BlocProvider<TariffBloc>(
          create: (context) => TariffBloc(MainRepository()),
        ),
        BlocProvider<ActiveTariffsBloc>(
          create: (context) => ActiveTariffsBloc(MainRepository()),
        ),
        BlocProvider<PromocodeBloc>(
          create: (context) => PromocodeBloc(MainRepository()),
        ),
        BlocProvider<PaymentHistoryBloc>(
          create: (context) => PaymentHistoryBloc(MainRepository()),
        ),
        BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(MainRepository()),
        ),
        BlocProvider<DownloadBloc>(
          create: (context) => DownloadBloc(MainRepository()),
        ),
        BlocProvider<CollectionBloc>(
          create: (context) => CollectionBloc(MainRepository()),
        ),
        BlocProvider<CollectionDetailBloc>(
          create: (context) => CollectionDetailBloc(MainRepository()),
        ),
        BlocProvider<CastBloc>(
          create: (context) => CastBloc(MainRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: HexColor('#E50914')),
          useMaterial3: true,
        ),
        home: RepositoryProvider(
            create: (context) => MainRepository(), child: SplashPage()),
        routes: {
          ScreenShotPage.routeName: (context) => RepositoryProvider(
              create: (context) => MainRepository(), child: ScreenShotPage()),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case SplashPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: SplashPage()),
                  settings: settings);

            case LandingPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: LandingPage()),
                  settings: settings);

            case ChangeUsernamePage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: ChangeUsernamePage()),
                  settings: settings);

            case NavigationPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: NavigationPage()),
                  settings: settings);

            case VideoPlayerPageMulti.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: VideoPlayerPageMulti()),
                  settings: settings);

            case VideoPlayerPageSingle.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: VideoPlayerPageSingle()),
                  settings: settings);
            case VideoPlayerPageOffline.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: VideoPlayerPageOffline()),
                  settings: settings);
            case MovieDetailPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: MovieDetailPage()),
                  settings: settings);
            case CommentPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: CommentPage()),
                  settings: settings);
            case SeasonPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: SeasonPage()),
                  settings: settings);
            case ActiveTariffsPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: ActiveTariffsPage()),
                  settings: settings);
            case TariffsPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: TariffsPage()),
                  settings: settings);
            case FillBalancePage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: FillBalancePage()),
                  settings: settings);
            case SessionPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: SessionPage()),
                  settings: settings);
            case StoryWatchPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: StoryWatchPage()),
                  settings: settings);
            case YoutubePlayerPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: YoutubePlayerPage()),
                  settings: settings);
            case GenreDetailPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: GenreDetailPage()),
                  settings: settings);
            case CategoryDetailPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: CategoryDetailPage()),
                  settings: settings);
            case PersonDetailPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: PersonDetailPage()),
                  settings: settings);
            case PhoneNumberPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: PhoneNumberPage()),
                  settings: settings);
            case SmsVerifyPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: SmsVerifyPage()),
                  settings: settings);
            case SessionDeletePage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: SessionDeletePage()),
                  settings: settings);
            case PaymentHistoryPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: PaymentHistoryPage()),
                  settings: settings);
            case SingleDownloadPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: SingleDownloadPage()),
                  settings: settings);
            case MultiDownloadSeasonPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: MultiDownloadSeasonPage()),
                  settings: settings);
            case MultiDownloadEpisodesPage.routeName:
              return CupertinoPageRoute(
                  barrierDismissible: false,
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: MultiDownloadEpisodesPage()),
                  settings: settings);
            case DownloadsPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: DownloadsPage()),
                  settings: settings);
            case DownloadedQualitiesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: DownloadedQualitiesPage()),
                  settings: settings);
            case DownloadedSeasonsPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: DownloadedSeasonsPage()),
                  settings: settings);
            case DownloadedSeasonEpisodesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: DownloadedSeasonEpisodesPage()),
                  settings: settings);
            case CollectionDetailPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: CollectionDetailPage()),
                  settings: settings);
            case CoursesPage.routeName:
              return CupertinoPageRoute(
                  builder: (_) => RepositoryProvider(
                      create: (context) => MainRepository(),
                      child: CoursesPage()),
                  settings: settings);
          }
        },
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  if (message == null) return;
  await setupFlutterNotifications();
  showNotification(message);
}

Future<void> setupFlutterNotifications() async {
  await FlutterLocalNotificationsPlugin().initialize(
    const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification_default')),
  );

  if (isNotificationInit) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'ss',
    importance: Importance.high,
  );
  await flutternotifications
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(
    channel,
  );

  isNotificationInit = true;

  await fireMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void showNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  if (notification != null && !kIsWeb) {
    await flutternotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
        ),
      ),
    );
  }
}