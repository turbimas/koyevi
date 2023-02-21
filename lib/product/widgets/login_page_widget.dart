import 'package:flutter/material.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/view/auth/login/login_view.dart';

class LoginPageWidget extends StatelessWidget {
  const LoginPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 710.smh,
        child: Center(
            child: InkWell(
          onTap: () {
            NavigationService.navigateToPage(const LoginView());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.smw, vertical: 20.smh),
            decoration: BoxDecoration(
              borderRadius: CustomThemeData.fullInfiniteRounded,
              border: Border.all(color: CustomColors.primary),
            ),
            child: CustomTextLocale(LocaleKeys.LoginPageWidget_click_to_login),
          ),
        )));
  }
}
