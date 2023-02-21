import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/view/auth/validation/validation_view.dart';

class RegisterViewModel extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _licenseAccepted = false;
  bool get licenseAccepted => _licenseAccepted;
  set licenseAccepted(bool value) {
    _licenseAccepted = value;
    notifyListeners();
  }

  Map<String, dynamic> registerData = {};
  RegisterViewModel();

  bool _isHiding = true;
  bool get isHiding => _isHiding;
  set isHiding(bool value) {
    _isHiding = value;
    notifyListeners();
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ResponseModel userResponse = await NetworkService.get(
          "users/user_info/${registerData["MobilePhone"]}");
      if (userResponse.success) {
        PopupHelper.showErrorDialog(
            errorMessage: LocaleKeys.Register_already_exist.tr());
      } else {
        NavigationService.navigateToPage(
            ValidationView(registerData: registerData, isUpdate: false));
      }
    }
  }
}
