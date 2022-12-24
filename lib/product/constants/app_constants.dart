// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppConstants {
  static const double designHeight = 800;
  static const double designWidth = 360;
  static Size get designSize => const Size(designWidth, designHeight);

  static const TR_LOCALE = Locale("tr");
  static const EN_LOCALE = Locale("en");
  static const PATH_LOCALE = "assets/lang";

  static const IOS_Version = "1.0.0";
  static const ANDROID_Version = "1.0.0";

  // static const APP_API = "https://goldenerp.com/api/ecom/";
  static const APP_API = "https://koyevidogal.com//api/ecom/";

  static String appToken = "";

  static bool isInitialized = false;
}
