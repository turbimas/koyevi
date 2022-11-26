import 'package:flutter/material.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/product/constants/app_constants.dart';

extension UIExtension on num {
  get smh {
    num scale = this / AppConstants.designHeight;
    num screenHeight =
        MediaQuery.of(NavigationService.navigatorKey.currentContext!)
                .size
                .height -
            MediaQuery.of(NavigationService.navigatorKey.currentContext!)
                .padding
                .top -
            MediaQuery.of(NavigationService.navigatorKey.currentContext!)
                .padding
                .bottom;
    num result = screenHeight * scale;
    return result;
  }

  get smw {
    num scale = this / AppConstants.designWidth;
    num screenWidth =
        MediaQuery.of(NavigationService.navigatorKey.currentContext!)
                .size
                .width -
            MediaQuery.of(NavigationService.navigatorKey.currentContext!)
                .padding
                .left -
            MediaQuery.of(NavigationService.navigatorKey.currentContext!)
                .padding
                .right;
    return screenWidth * scale;
  }
}
