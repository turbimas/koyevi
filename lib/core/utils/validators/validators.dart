import 'package:easy_localization/easy_localization.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/utils/validators/auth_validators.dart';

class Validators with AuthValidators {
  static final Validators _instance = Validators._();
  Validators._();
  static Validators get instance => _instance;

  String? notEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.Validators_required.tr();
    }
    return null;
  }
}
