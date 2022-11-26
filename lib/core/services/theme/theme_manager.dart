import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class AppTheme {
  static late final Map<String, dynamic> iconData;
  static late final Map<String, dynamic> colorData;
  static late final Map<String, dynamic> imageData;
  static Future<void> loadCustomThemeData() async {
    String iconDataString =
        await rootBundle.loadString("assets/theme/icons.json");
    iconData = json.decode(iconDataString);

    String colorDataString =
        await rootBundle.loadString("assets/theme/colors.json");
    colorData = json.decode(colorDataString);

    String imageDataString =
        await rootBundle.loadString("assets/theme/images.json");
    imageData = json.decode(imageDataString);
  }
}
