import 'package:flutter/material.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
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

  register() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      NavigationService.navigateToPage(
          ValidationView(registerData: registerData, isUpdate: false));
    }
  }
}
