import 'dart:math' as math;

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

class ValidationViewModel extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isUpdate;

  bool _resented = false;
  bool get resented => _resented;
  set resented(bool value) {
    _resented = value;
    notifyListeners();
  }

  Map<String, dynamic> registerData;
  ValidationViewModel(this.registerData, {required this.isUpdate}) {
    generateValidateCode();
  }

  String validateCode = "";

  String approvedValidationCode = "";

  void generateValidateCode() {
    validateCode = "";
    for (int i = 0; i < 6; i++) {
      validateCode += math.Random().nextInt(10).toString();
    }
  }

  Future<bool> sendMessage() async {
    try {
      ResponseModel response =
          await NetworkService.post("users/numbersend", body: {
        "NumberPhone": registerData["MobilePhone"],
        "ProcessType": 1,
        "VerificationCode": validateCode
      });
      if (response.success) {
        return true;
      } else {
        PopupHelper.showErrorDialog(
            errorMessage: response.errorMessage!,
            dismissible: false,
            actions: {
              LocaleKeys.Validation_go_back.tr(): () {
                NavigationService.back(times: 2, data: false);
              }
            });
        return false;
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
      return false;
    }
  }

  Future<void> resend() async {
    generateValidateCode();
    resented = await sendMessage();
  }

  Future<void> approve() async {
    //if (formKey.currentState!.validate()) formKey.currentState!.save();
    if (approvedValidationCode.trim() == validateCode) {
      late ResponseModel response;
      if (isUpdate) {
        response = await NetworkService.post("users/user_edit", body: {
          "ID": AuthService.id,
          "Name": registerData["Name"],
          "BornDate": registerData["BornDate"],
          "MobilePhone": registerData["MobilePhone"],
          "Password": registerData["Password"],
          "Cinsiyet": registerData["Gender"]
        });
      } else {
        try {
          response =
              await NetworkService.post("users/register", body: registerData);
        } catch (e) {
          PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
        }
      }

      if (response.success) {
        ResponseModel userInfo = await NetworkService.get(
            "users/user_info/${registerData["MobilePhone"]}");
        if (userInfo.success) {
          // formKey.currentState?.dispose();
          await AuthService.login(UserModel.fromJson(userInfo.data));
          await NavigationService.navigateToPageAndRemoveUntil(
              const MainView());
          if (AuthService.currentUser!.hasCard) {
            Future.delayed(const Duration(seconds: 1), () {
              PopupHelper.showSuccessDialog(
                  "Kart no: ${AuthService.currentUser!.cardID}\nTelefon numaranızın üzerine kayıtlı bir Köyevi kartı bulunduğu için, bu hesabınızı kartınız ile ilişkilendirdik. Keyifli alışverişler dileriz !");
            });
          }
        } else {
          PopupHelper.showErrorDialog(errorMessage: userInfo.errorMessage!);
        }
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } else {
      PopupHelper.showErrorDialog(
          errorMessage: LocaleKeys.Validation_wrong_code.tr());
    }
  }
}
