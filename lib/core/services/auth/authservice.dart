import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koyevi/core/services/cache/cache_manager.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/product/constants/cache_constants.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/product/models/user_model.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';
import 'package:koyevi/view/auth/login/login_view.dart';

class AuthService {
  static UserModel? currentUser;
  static bool get isLoggedIn =>
      CacheManager.instance.getInt(CacheConstants.userId) != null;

  static String? get email => currentUser != null
      ? currentUser!.email
      : CacheManager.instance.getString(CacheConstants.userMail);

  static String? get phone => currentUser != null
      ? currentUser!.phone
      : CacheManager.instance.getString(CacheConstants.userPhone);

  static login(UserModel user) {
    currentUser = user;
    CacheManager.instance.setInt(CacheConstants.userId, user.id);
    CacheManager.instance.setString(CacheConstants.userMail, user.email);
    CacheManager.instance.setString(CacheConstants.userPhone, user.phone);
    NavigationService.navigateToPageAndRemoveUntil(const MainView());
  }

  static void logout() {
    CacheManager.instance.remove(CacheConstants.userId);
    CacheManager.instance.remove(CacheConstants.userMail);
    CacheManager.instance.remove(CacheConstants.userPhone);
    currentUser = null;
    NavigationService.context.read<HomeIndexCubit>().set(2);
    NavigationService.navigateToPageAndRemoveUntil(const LoginView());
  }

  static void update(UserModel user) {
    currentUser = user;
    CacheManager.instance.setString(CacheConstants.userMail, user.email);
    CacheManager.instance.setString(CacheConstants.userPhone, user.phone);
    NavigationService.navigateToPageAndRemoveUntil(const MainView());
  }

  static Widget userImage({required double height, required double width}) {
    if (AuthService.currentUser!.imageUrl != null) {
      return Image.network(
        AuthService.currentUser!.imageUrl!,
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
