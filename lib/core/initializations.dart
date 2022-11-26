import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koyevi/core/services/cache/cache_manager.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/theme/theme_manager.dart';

void initSync() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      systemNavigationBarDividerColor: Colors.transparent));
}

Future initAsync() async {
  await AppTheme.loadCustomThemeData();
  await CacheManager.initCache();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await EasyLocalization.ensureInitialized();
}
