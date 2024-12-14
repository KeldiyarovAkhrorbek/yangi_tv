import 'dart:developer';
import 'dart:io';
import 'package:appcheck/appcheck.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yangi_tv_new/bloc/blocs/testtoken/test_token_event.dart';
import 'package:yangi_tv_new/bloc/blocs/testtoken/test_token_state.dart';
import 'package:yangi_tv_new/bloc/repos/mainrepository.dart';
import '../../../helpers/auth_state.dart';
import '../../../helpers/detect_emulator.dart';
import '../../../helpers/secure_storage.dart';
import '../../../helpers/test_token_enum.dart';

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
                await AppCheck().isAppInstalled(dangerousPackage);
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
        log(token.toString());
        if (token == null) {
          emit(TestTokenDoneState(authState: AuthState.TokenExpired));
          return;
        }

        var testTokenResult = await _mainRepository.getProfileTesting();
        if (testTokenResult == TestTokenEnum.NotAuthenticated) {
          emit(TestTokenDoneState(authState: AuthState.TokenExpired));
          return;
        } else if (testTokenResult == TestTokenEnum.Error) {
          emit(TestTokenDoneState(authState: AuthState.NoInternet));
          return;
        }

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
