import 'package:easy_localization/easy_localization.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';

mixin AuthValidators {
  String? fullNameValidator(String? value) {
    // max 30 character regex
    if (value == null || value.isEmpty) {
      return LocaleKeys.Validators_required.tr();
    } else if (value.length > 30) {
      return LocaleKeys.Validators_too_long_name.tr();
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null) {
      return LocaleKeys.Validators_phone.tr();
    }
    value = value.replaceAll(" ", "");
    if (value.length != 12 || !value.startsWith("90")) {
      return LocaleKeys.Validators_phone.tr();
    }
    return null;
  }

  String? validationCodeValidator(String? value) {
    // validation code regex
    final RegExp validationCodeRegex = RegExp(r'^[0-9]{6}$');
    // check if validation code is valid
    if (value != null && !validationCodeRegex.hasMatch(value)) {
      return LocaleKeys.Validators_validation_code.tr();
    }
    return null;
  }

  String? passwordValidator(String? value) {
    // password regex
    final RegExp passwordRegex = RegExp(r'^.{8,}$');
    // check if password is valid
    if (value != null && !passwordRegex.hasMatch(value)) {
      return LocaleKeys.Validators_password.tr();
    }
    return null;
  }
}
