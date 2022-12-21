import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';

class UserProfileViewModel extends ChangeNotifier {
  Map<String, dynamic> formData = {};
  Map<String, dynamic> readOnlyFormData = {};

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
              errorMessage: "Eski şifreniz doğru değil");
          return;
        }
      } else {
        formData.remove("oldPassword");
        formData.remove("newPasswordAgain");
        formData.remove("newPassword");
      }
      formKey.currentState!.save();
    }
  }
}
