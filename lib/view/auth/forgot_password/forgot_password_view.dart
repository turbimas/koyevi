import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _image(),
            _message(),
            _field(),
            OkCancelPrompt(okCallBack: () {}, cancelCallBack: () {})
          ],
        ),
      ),
    );
  }

  Container _field() {
    return Container(
      margin: EdgeInsets.only(top: 10.smh, bottom: 300.smh),
      padding: EdgeInsets.symmetric(horizontal: 30.smw),
      decoration: BoxDecoration(
          color: CustomColors.primary,
          borderRadius: CustomThemeData.fullInfiniteRounded),
      height: 50.smh,
      width: 300.smw,
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: CustomFonts.defaultField(CustomColors.primaryText),
            hintText: LocaleKeys.ForgotPassword_email_hint.tr()),
      ),
    );
  }

  SizedBox _message() {
    return SizedBox(
      height: 80.smh,
      width: 300.smw,
      child: Center(
        child: CustomTextLocale(LocaleKeys.ForgotPassword_prompt_message,
            style: CustomFonts.bodyText4(CustomColors.backgroundText)),
      ),
    );
  }

  SizedBox _image() {
    return SizedBox(
        height: 310.smh,
        width: 250.smw,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.smh),
            child: Center(child: CustomImages.forgot_password)));
  }
}
