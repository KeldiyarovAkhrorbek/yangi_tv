import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_radio_version_plugin/get_radio_version_plugin.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:root_jailbreak_sniffer/rjsniffer.dart';
import 'package:safe_device/safe_device.dart';

class DetectEmulator {
  static const platform = MethodChannel('root_detection');

  Future<bool> isDeviceEmulator() async {
    if (Platform.isIOS) return false;

    bool isEmulator = false;
    bool isJailBroken = await SafeDevice.isJailBroken;
    bool isNotSafe = await SafeDevice.isSafeDevice;
    bool amICompromised = await Rjsniffer.amICompromised() ?? false;
    final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    var jailbreakRootDetection =
        await JailbreakRootDetection.instance.isJailBroken;
    bool isRootedNative = await isRooted();
    log(isRootedNative.toString());

    if (Platform.isAndroid) {
      var radioVersion = await GetRadioVersionPlugin.radioVersion;
      if (radioVersion == '1.0.0.0' ||
          radioVersion == '' ||
          radioVersion == null) {
        isEmulator = true;
      }
    }

    return isEmulator ||
        isJailBroken ||
        isNotSafe ||
        amICompromised ||
        isNotTrust ||
        jailbreakRootDetection;
  }

  Future<bool> isRooted() async {
    try {
      final bool isRooted = await platform.invokeMethod('isRooted');
      return isRooted;
    } on PlatformException catch (e) {
      print("Failed to detect root: '${e.message}'.");
      return false;
    }
  }
}
