import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/core/utils/helpers/crypt_helper.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/core/utils/validators/validators.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';
import 'package:koyevi/view/auth/forgot_password/forgot_password_view_model.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  late final ChangeNotifierProvider<ForgotPasswordViewModel> provider;

  TextEditingController phoneController = TextEditingController(text: "90");
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => ForgotPasswordViewModel());
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
    _focusNode2.addListener(() {
      if (_focusNode2.hasFocus) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        floatingActionButton: _fab(),
        appBar: CustomAppBar.activeBack(
            LocaleKeys.ForgotPassword_appbar_title.tr()),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image(),
              _message(),
              _numberField(),
              _pinCodeField(),
              _newPasswordField(),
              ref.watch(provider).isCodeVerified
                  ? OkCancelPrompt(okCallBack: () {
                      ref.read(provider).newPassword(
                          CryptHelper.toMD5(newPasswordController.text));
                    }, cancelCallBack: () {
                      NavigationService.back();
                    })
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton? _fab() {
    if (ref.watch(provider).didCodeSent) {
      return null;
    } else {
      return FloatingActionButton(
        backgroundColor: CustomColors.primary,
        onPressed: () {
          if (phoneController.text.isNotEmpty) {
            ref.read(provider).phone = phoneController.text;
            ref.read(provider).sendVerificationCode();
          } else {
            PopupHelper.showErrorToast(
                LocaleKeys.ForgotPassword_enter_phone.tr());
          }
        },
        child: CustomIcons.forward_icon_light,
      );
    }
  }

  Container _numberField() {
    return Container(
      margin: EdgeInsets.only(top: 10.smh),
      padding: EdgeInsets.symmetric(horizontal: 30.smw),
      decoration: BoxDecoration(
          color: CustomColors.primary,
          borderRadius: CustomThemeData.fullInfiniteRounded),
      height: 50.smh,
      width: 300.smw,
      child: TextFormField(
        onFieldSubmitted: (value) {
          ref.read(provider).phone = value;
          ref.read(provider).sendVerificationCode();
        },
        keyboardType: TextInputType.phone,
        controller: phoneController,
        enabled: !ref.watch(provider).didCodeSent,
        validator: CustomValidators.instance.phoneValidator,
        onSaved: (newValue) async {
          ref.read(provider).phone = newValue!;
          ref.read(provider).sendVerificationCode();
        },
        focusNode: _focusNode,
        style: CustomFonts.defaultField(CustomColors.primaryText),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: CustomFonts.defaultField(CustomColors.primaryText),
            hintText: LocaleKeys.ForgotPassword_number_hint.tr()),
      ),
    );
  }

  SizedBox _message() {
    return SizedBox(
      width: 300.smw,
      child: Center(
        child: CustomTextLocale(LocaleKeys.ForgotPassword_prompt_message,
            style: CustomFonts.bodyText4(CustomColors.backgroundText),
            maxLines: 5),
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

  Widget _pinCodeField() {
    if (!ref.watch(provider).didCodeSent) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.smh),
      child: PinCodeFields(
        fieldBorderStyle: FieldBorderStyle.square,
        responsive: true,
        padding: const EdgeInsets.all(20),
        borderWidth: 3.0,
        activeBorderColor: CustomColors.secondary,
        activeBackgroundColor: CustomColors.secondary,
        borderRadius: BorderRadius.circular(20.0),
        keyboardType: TextInputType.number,
        autoHideKeyboard: true,
        fieldBackgroundColor: CustomColors.card,
        borderColor: CustomColors.cardInner,
        textStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        length: 6,
        controller: null,
        focusNode: null,
        onComplete: (result) {
          if (result == ref.watch(provider).pinCode) {
            ref.read(provider).isCodeVerified = true;
            _focusNode2.requestFocus();
          } else {
            PopupHelper.showErrorToast(
                LocaleKeys.ForgotPassword_wrong_code.tr());
          }
        },
      ),
    );
  }

  Widget _newPasswordField() {
    if (!ref.watch(provider).isCodeVerified) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 40.smh),
      padding: EdgeInsets.symmetric(horizontal: 30.smw),
      decoration: BoxDecoration(
          color: CustomColors.primary,
          borderRadius: CustomThemeData.fullInfiniteRounded),
      height: 50.smh,
      width: 300.smw,
      child: TextFormField(
        controller: newPasswordController,
        validator: CustomValidators.instance.passwordValidator,
        onSaved: (newValue) async {
          ref.read(provider).phone = newValue!;
          ref.read(provider).sendVerificationCode();
        },
        focusNode: _focusNode2,
        style: CustomFonts.defaultField(CustomColors.primaryText),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: CustomFonts.defaultField(CustomColors.primaryText),
            hintText: LocaleKeys.ForgotPassword_new_password_hint.tr()),
      ),
    );
  }
}
