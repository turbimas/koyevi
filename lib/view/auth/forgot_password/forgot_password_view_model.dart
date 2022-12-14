import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/user_model.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  String pinCode = "";
  String phone = "";
  ForgotPasswordViewModel() {
    pinCode = Random().nextInt(999999).toString().padLeft(6, '0');
  }

  bool _isCodeSent = false;
  bool get didCodeSent => _isCodeSent;
  set didCodeSent(bool value) {
    _isCodeSent = value;
    notifyListeners();
  }

  bool _isCodeVerified = false;
  bool get isCodeVerified => _isCodeVerified;
  set isCodeVerified(bool value) {
    _isCodeVerified = value;
    notifyListeners();
  }

  Future<void> sendVerificationCode() async {
    try {
      ResponseModel responseModel =
          await NetworkService.post("users/numbersend", body: {
        "NumberPhone": phone,
        "ProcessType": "2",
        "VerificationCode": pinCode
      });
      if (responseModel.success) {
        didCodeSent = true;
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> newPassword(String password) async {
    try {
      ResponseModel userData =
          await NetworkService.get("users/user_info/$phone");
      if (userData.success) {
        UserModel user = UserModel.fromJson(userData.data);
        user.password = password;
        ResponseModel responseModel =
            await NetworkService.post("users/user_edit", body: user.toJson());
        if (responseModel.success) {
          PopupHelper.showSuccessToast(
              LocaleKeys.ForgotPassword_successfully_changed.tr());
          AuthService.login(user);
          NavigationService.navigateToPage(const MainView());
        } else {
          PopupHelper.showErrorDialogWithCode(responseModel.errorMessage!);
        }
      } else {
        PopupHelper.showErrorDialogWithCode(userData.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
