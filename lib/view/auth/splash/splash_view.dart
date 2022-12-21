import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/cubits/basket_model_cubit/basket_model_cubit.dart';
import 'package:koyevi/product/models/user_model.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';
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
    _loadApp();
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

  void _loadAssets() {
    CustomColors.loadColors();
    CustomIcons.loadIcons();
    CustomImages.loadImages();
  }

  Future<void> _loadApp() async {
    // asset
    _loadAssets();

    // update
    ResponseModel versionData =
        await NetworkService.post("app/checkversion", body: {
      "IOS_Version": AppConstants.IOS_Version,
      "ANDROID_Version": AppConstants.ANDROID_Version
    });
    if (versionData.success) {
      String? updateLink;
      if (Platform.isAndroid) {
        updateLink = versionData.data["ANDROID_Version"];
      } else if (Platform.isIOS) {
        updateLink = versionData.data["IOS_Version"];
      }
      if (updateLink != null) {
        _showUpdateDialog(updateLink);
      }
    } else {
      await PopupHelper.showErrorDialog(
          errorMessage: LocaleKeys.ERROR.tr(),
          actions: {
            LocaleKeys.TRY_AGAIN.tr(): () {
              NavigationService.back();
            }
          });
      // güncelleme bilgisi gelmediyse, kurulumu tekrar çağırır ve fonksiyonun kalanını sonlandırır
      _loadApp();
      return;
    }
    if (AuthService.isLoggedIn) {
      ResponseModel userData =
          await NetworkService.get("users/user_info/${AuthService.cachePhone}");
      if (userData.success) {
        UserModel user = UserModel.fromJson(userData.data);
        if (AuthService.cachePassword == user.password) {
          AuthService.login(user);
          context.read<BasketModelCubit>().refresh();
        } else {
          PopupHelper.showErrorToast(LocaleKeys.Splash_password_changed);
          AuthService.logout(showSuccessMessage: false);
        }
      } else {
        PopupHelper.showErrorToast(LocaleKeys.Splash_user_info_error.tr());
        AuthService.logout(showSuccessMessage: false);
      }
    }

    AppConstants.isInitialized = true;
    NavigationService.navigateToPageAndRemoveUntil(const MainView());
  }

  _showUpdateDialog(String updateLink) {
    PopupHelper.showErrorDialog(
        errorMessage: LocaleKeys.Splash_update_available.tr(),
        actions: {
          LocaleKeys.Splash_update.tr(): () {
            launchUrlString(updateLink);
          }
        });
  }
}
