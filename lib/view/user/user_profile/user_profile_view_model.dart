import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/product/models/user_model.dart';

class UserProfileViewModel extends ChangeNotifier {
  Map<String, dynamic> formData = {};
  Map<String, dynamic> readOnlyFormData = {};

  bool? _gender = AuthService.currentUser!.gender;
  bool? get gender => _gender;
  set gender(bool? value) {
    _gender = value;
    log("gender: $value");
    notifyListeners();
  }

  bool _changePassword = false;
  bool get changePassword => _changePassword;
  set changePassword(bool value) {
    _changePassword = value;
    notifyListeners();
  }

  GlobalKey<FormState> formKey;

  UserProfileViewModel(this.formKey);

  void setReadOnlyFormKey(String key, dynamic data) {
    formData[key] = data;
    notifyListeners();
  }

  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (changePassword) {
        if (formData["oldPassword"] == AuthService.currentUser!.password) {
          if (formData["newPassword"] == formData["newPasswordAgain"]) {
            formData.remove("oldPassword");
            formData.remove("newPasswordAgain");
            formData["Password"] = formData["newPassword"];
            formData.remove("newPassword");
          }
        } else {
          PopupHelper.showErrorDialog(
              errorMessage: LocaleKeys.UserProfile_wrong_old_password.tr());
          return;
        }
      } else {
        formData.remove("oldPassword");
        formData.remove("newPasswordAgain");
        formData.remove("newPassword");
      }

      ResponseModel responseModel =
          await NetworkService.post("users/user_edit", body: {
        "ID": AuthService.currentUser!.id,
        "Name": formData["Name"],
        "BornDate": formData["BornDate"],
        "MobilePhone": formData["MobilePhone"],
        "Password": formData["newPassword"],
        "Cinsiyet": gender
      });
      if (responseModel.success) {
        PopupHelper.showSuccessToast(
            LocaleKeys.UserProfile_successfully_updated.tr());
        ResponseModel userDataResponse = await NetworkService.get(
            "users/user_info/${AuthService.currentUser!.phone}");
        AuthService.update(UserModel.fromJson(userDataResponse.data));
        // ignore: use_build_context_synchronously
        NavigationService.context.read<HomeIndexCubit>().set(2);
        NavigationService.back();
      } else {
        PopupHelper.showErrorDialog(
            errorMessage: LocaleKeys.UserProfile_error_updating.tr());
      }
    }
  }
}
