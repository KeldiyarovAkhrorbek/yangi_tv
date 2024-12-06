import 'dart:io';

import 'package:get_radio_version_plugin/get_radio_version_plugin.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:root_jailbreak_sniffer/rjsniffer.dart';
import 'package:safe_device/safe_device.dart';

class DetectEmulator {
  Future<bool> isDeviceEmulator() async {
    if (Platform.isIOS) return false;

    bool isEmulator = false;
    bool isJailBroken = await SafeDevice.isJailBroken;
    bool isNotSafe = await SafeDevice.isSafeDevice;
    bool amICompromised = await Rjsniffer.amICompromised() ?? false;
    final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    final isJailBroken1 = await JailbreakRootDetection.instance.isJailBroken;
    final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;

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
        isJailBroken1 ||
        isRealDevice;
  }
}
