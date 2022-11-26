import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/models/user_model.dart';
import 'package:koyevi/view/auth/login/login_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SplashView extends ConsumerStatefulWidget {
  final Function setstate;
  const SplashView({Key? key, required this.setstate}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            width: AppConstants.designWidth,
            height: AppConstants.designHeight,
            child: CustomImages.splash),
      ),
    );
  }

  _load() {
    try {
      CustomColors.loadColors();
      CustomIcons.loadIcons();
      CustomImages.loadImages();
    } catch (e) {}
    // AuthService.currentUser = null;
    // CacheManager.instance.remove(CacheConstants.userId);
    // CacheManager.instance.remove(CacheConstants.userEmail);
    // if (false) {
    NetworkService.post("app/checkversion", body: {
      "IOS_Version": AppConstants.IOS_Version,
      "ANDROID_Version": AppConstants.ANDROID_Version
    }).then((value) {
      String? updateLink = "";
      if (value.success) {
        if (Platform.isAndroid) {
          updateLink = value.data["ANDROID_Version"];
        } else if (Platform.isIOS) {
          updateLink = value.data["IOS_Version"];
        }
      } else {
        PopupHelper.showErrorDialog(
            errorMessage: "İnternet bağlantınızdan emin olun ve tekrar deneyin",
            actions: {
              "Tekrar dene": () {
                Navigator.pop(context);
                _load();
              }
            });
      }
      if (updateLink != null) {
        if (updateLink.isNotEmpty) {
          _showUpdateDialog(updateLink);
        }
        return;
      }
      if (AuthService.isLoggedIn) {
        try {
          NetworkService.get(
                  "users/user_info/${AuthService.email == "" ? AuthService.phone : AuthService.email}")
              .then((ResponseModel value) {
            if (value.success) {
              AuthService.login(UserModel.fromJson(value.data));
            } else {
              AuthService.logout();
              PopupHelper.showErrorDialog(errorMessage: value.errorMessage!);
            }
          }).onError((error, stackTrace) {
            AuthService.logout();
            PopupHelper.showErrorDialogWithCode(error!);
          });
        } catch (e) {
          PopupHelper.showErrorDialogWithCode(e);
          AuthService.logout();
        }
      } else {
        Future.delayed(Duration.zero, () {
          NavigationService.navigateToPageReplace(const LoginView());
        });
      }
    });
  }

  _showUpdateDialog(String updateLink) {
    PopupHelper.showErrorDialog(
        errorMessage:
            "Güncelleme mevcut! Uygulamayı kullanabilmek için lütfen güncelleyin",
        actions: {
          "Güncelle": () {
            launchUrlString(updateLink);
          }
        });
  }
}
