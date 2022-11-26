// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/core/utils/validators/validators.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';
import 'package:koyevi/view/auth/validation/validation_view_model.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

class ValidationView extends ConsumerStatefulWidget {
  Map<String, dynamic> registerData;
  bool isUpdate;
  ValidationView({Key? key, required this.registerData, required this.isUpdate})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ValidationViewState();
}

class _ValidationViewState extends ConsumerState<ValidationView> {
  late ChangeNotifierProvider<ValidationViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) =>
        ValidationViewModel(widget.registerData, isUpdate: widget.isUpdate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<bool>(
          future: ref.read(provider).sendMessage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return _form();
              } else {
                return _loading();
              }
            } else {
              return _loading();
            }
          },
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: CustomImages.loading,
    );
  }

  Column _form() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _image(),
            _message(),
            _field(),
            _resend(),
          ],
        ),
        OkCancelPrompt(
            okCallBack: ref.read(provider).approve,
            cancelCallBack: () {
              NavigationService.back<bool>(data: false);
            })
      ],
    );
  }

  Widget _field() {
    return PinCodeFields(
      fieldBorderStyle: FieldBorderStyle.square,
      responsive: true,
      padding: EdgeInsets.all(20),
      borderWidth: 3.0,
      activeBorderColor: CustomColors.secondary,
      activeBackgroundColor: CustomColors.secondary,
      borderRadius: BorderRadius.circular(20.0),
      keyboardType: TextInputType.number,
      autoHideKeyboard: true,
      fieldBackgroundColor: CustomColors.card,
      borderColor: CustomColors.cardInner,
      textStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      length: 6,
      controller: null,
      focusNode: null,
      onComplete: (result) {
        ref.read(provider).approvedValidationCode = result;
        ref.read(provider).approve;
        print(result);
      },
    );
  }

  SizedBox _message() {
    return SizedBox(
      height: 80.smh,
      width: 300.smw,
      child: Center(
        child: CustomTextLocale(LocaleKeys.Validation_sent_message,
            args: [widget.registerData["MobilePhone"]],
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
            child: Center(child: CustomImages.validation_image)));
  }

  Widget _resend() {
    return Container(
      width: 300.smw,
      constraints: BoxConstraints(
        minHeight: 30.smh,
      ),
      margin: EdgeInsets.symmetric(horizontal: 30.smw),
      child: InkWell(
        onTap: !ref.watch(provider).resented ? ref.read(provider).resend : null,
        child: Align(
            alignment: Alignment.centerRight,
            child: CustomTextLocale(ref.watch(provider).resented
                ? LocaleKeys.Validation_resent
                : LocaleKeys.Validation_resend)),
      ),
    );
  }
}
