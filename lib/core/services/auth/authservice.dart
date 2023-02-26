import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koyevi/core/services/cache/cache_manager.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/constants/cache_constants.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/product/models/user_model.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';

class AuthService {
  static UserModel? currentUser;
  static bool get isLoggedIn =>
      CacheManager.instance.getInt(CacheConstants.userId) != null;

  static int get id => currentUser != null ? currentUser!.id : 0;
  static String get cachePassword =>
      CacheManager.instance.getString(CacheConstants.userPassword) ?? "";
  static String get cachePhone =>
      CacheManager.instance.getString(CacheConstants.userPhone) ?? "";

  static login(UserModel user) {
    currentUser = user;
    CacheManager.instance.setInt(CacheConstants.userId, user.id);
    CacheManager.instance.setString(CacheConstants.userPassword, user.password);
    CacheManager.instance.setString(CacheConstants.userPhone, user.phone);
    NavigationService.context.read<HomeIndexCubit>().set(2);
  }

  static void logout({required bool showSuccessMessage}) {
    CacheManager.instance.remove(CacheConstants.userId);
    CacheManager.instance.remove(CacheConstants.userPhone);
    CacheManager.instance.remove(CacheConstants.userPassword);
    NavigationService.context.read<HomeIndexCubit>().set(2);
    currentUser = null;
    if (showSuccessMessage) {
      PopupHelper.showSuccessToast(
          LocaleKeys.AuthService_logout_successful.tr());
    }
  }

  static void update(UserModel user) {
    currentUser = user;
    CacheManager.instance.setString(CacheConstants.userPhone, user.phone);
    NavigationService.navigateToPageAndRemoveUntil(const MainView());
  }

  static Widget userImage({required double height, required double width}) {
    if (AuthService.currentUser!.imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: AuthService.currentUser!.imageUrl!,
        height: height,
        width: width,
      );
    } else {
      return Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: height,
          ),
        ),
      );
    }
  }
}
