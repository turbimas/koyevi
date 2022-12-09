import 'package:flutter/material.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            height: 715.smh,
            child: Center(
                child: InkWell(
              onTap: () {
                NavigationService.navigateToPage(const LoginView());
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.smw, vertical: 20.smh),
                decoration: BoxDecoration(
                  borderRadius: CustomThemeData.fullInfiniteRounded,
                  border: Border.all(color: CustomColors.primary),
                ),
                // TODO: localization ekle
                child: CustomText("Giriş yapmak için tıklayınız"),
              ),
            ))),
        Container(height: 85.smh)
      ],
    );
  }
}
