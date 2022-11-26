import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/user_model.dart';
import 'package:koyevi/view/auth/validation/validation_view.dart';

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
      if (AuthService.currentUser!.email != formData["Email"]) {
        Map<String, dynamic> registerData = {
          "Name": AuthService.currentUser!.nameSurname,
          "MobilePhone": AuthService.currentUser!.phone,
          "Email": formData["Email"],
        };
        if (changePassword) {
          registerData["Password"] = formData["Password"];
        }
        NavigationService.navigateToPage(ValidationView(
          registerData: registerData,
          isUpdate: true,
        ));
      } else {
        formData["ID"] = AuthService.currentUser!.id;
        ResponseModel response =
            await NetworkService.post("users/user_edit", body: formData);
        if (response.success) {
          PopupHelper.showSuccessToast("Başarıyla güncellendi");
          ResponseModel response =
              await NetworkService.get("users/user_info/${formData["Email"]}");
          if (response.success) {
            UserModel user = UserModel.fromJson(response.data);
            AuthService.login(user);
          } else {
            AuthService.logout();
          }
        } else {
          PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
        }
      }
      formKey.currentState!.save();
    }
  }
}
