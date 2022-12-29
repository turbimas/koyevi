import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koyevi/core/services/cache/cache_manager.dart';
import 'package:koyevi/core/services/theme/theme_manager.dart';

void initSync() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      systemNavigationBarDividerColor: Colors.transparent));
}

Future initAsync() async {
  await _appTracking();
  await AppTheme.loadCustomThemeData();
  await CacheManager.initCache();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await EasyLocalization.ensureInitialized();
}

Future<void> _appTracking() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    String systemVersion = iosInfo.systemVersion ?? "14.0";
    late bool willRequests;
    if (systemVersion[1] == ".") {
      willRequests = false;
    } else {
      int major = int.parse(systemVersion.substring(0, 2));
      if (major >= 14) {
        willRequests = true;
      } else {
        willRequests = false;
      }
    }
    if (willRequests) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
