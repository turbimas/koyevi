import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/view/auth/forgot_password/forgot_password_view.dart';
import 'package:koyevi/view/auth/login/login_view_model.dart';
import 'package:koyevi/view/auth/register/register_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  late final ChangeNotifierProvider<LoginViewModel> provider;
  late final TextEditingController _loginInfo;
  late final TextEditingController _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    provider =
        ChangeNotifierProvider((context) => LoginViewModel(formKey: _formKey));
    _loginInfo = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar.inactiveBack(LocaleKeys.Login_appbar_title.tr()),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image(),
              _form(),
              _forgotPasswordText(),
              _loginButton(),
              _notRegisteredYet(),
              _registerButton()
            ],
          ),
        ),
      ),
    );
  }

  Container _forgotPasswordText() {
    return Container(
      margin: EdgeInsets.only(top: 5.smh),
      child: InkWell(
        onTap: () {
          NavigationService.navigateToPage(const ForgotPasswordView());
        },
        child: SizedBox(
            width: 300.smw,
            height: 25.smh,
            child: Align(
                alignment: Alignment.centerRight,
                child: CustomTextLocale(LocaleKeys.Login_forgot_password,
                    style:
                        CustomFonts.bodyText4(CustomColors.backgroundText)))),
      ),
    );
  }

  Widget _registerButton() {
    late Widget flag;
    switch (context.locale.languageCode) {
      case "tr":
        flag = CustomImages.tr_flag;
        break;
      case "en":
        flag = CustomImages.en_flag;
        break;
      default:
        flag = CustomImages.en_flag;
        break;
    }
    return Container(
      padding: EdgeInsets.only(bottom: 20.smh),
      height: 140.smh,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: _showLanguageDialog,
            child: Container(
              height: 40.smh,
              width: 40.smw,
              padding: EdgeInsets.symmetric(vertical: 5.smh, horizontal: 5.smw),
              decoration: BoxDecoration(
                  color: CustomColors.primary,
                  borderRadius: CustomThemeData.rightInfiniteRounded),
              child: Center(child: flag),
            ),
          ),
          InkWell(
            onTap: () => NavigationService.navigateToPage(const RegisterView()),
            child: Container(
              height: 80.smh,
              width: 220.smw,
              decoration: BoxDecoration(
                  color: CustomColors.primary,
                  borderRadius: CustomThemeData.leftInfiniteRounded),
              child: Center(
                  child: CustomTextLocale(LocaleKeys.Login_register_button,
                      style: CustomFonts.bigButton(CustomColors.primaryText))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: EdgeInsets.only(
          top: 15.smh, left: 45.smw, right: 45.smw, bottom: 0.smh),
      child: InkWell(
        onTap: () => ref
            .read(provider)
            .login(loginInfo: _loginInfo.text, password: _password.text),
        child: Container(
          height: 75.smh,
          width: 270.smw,
          decoration: BoxDecoration(
            color: CustomColors.secondary,
            borderRadius: CustomThemeData.fullInfiniteRounded,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.smw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextLocale(LocaleKeys.Login_login_button,
                      style: CustomFonts.bigButton(CustomColors.secondaryText)),
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomIcons.enter_icon))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _image() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 55.smh, horizontal: 70.smw),
        child: SizedBox(
            width: 220.smw,
            height: 220.smh,
            child: Center(child: CustomImages.login)));
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            height: 50.smh,
            width: 300.smw,
            decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: CustomThemeData.fullInfiniteRounded),
            child: Padding(
                padding: EdgeInsets.only(
                    left: 20.smw, top: 8.smh, bottom: 7.smh, right: 20.smw),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _loginInfo,
                  textInputAction: TextInputAction.next,
                  textAlignVertical: TextAlignVertical.center,
                  style: CustomFonts.defaultField(CustomColors.primaryText),
                  decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintStyle:
                          CustomFonts.defaultField(CustomColors.primaryText),
                      hintText: LocaleKeys.Login_email_phone_hint.tr(),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 10.smw),
                        child: CustomIcons.field_profile_icon,
                      )),
                )),
          ),
          SizedBox(height: 10.smh),
          Container(
              height: 50.smh,
              width: 300.smw,
              decoration: BoxDecoration(
                  color: CustomColors.primary,
                  borderRadius: CustomThemeData.fullInfiniteRounded),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.smw, top: 8.smh, bottom: 7.smh, right: 20.smw),
                  child: TextFormField(
                    obscureText: ref.watch(provider).isHiding,
                    controller: _password,
                    onFieldSubmitted: (value) {
                      () => ref.read(provider).login(
                          loginInfo: _loginInfo.text, password: _password.text);
                    },
                    textInputAction: TextInputAction.done,
                    textAlignVertical: TextAlignVertical.center,
                    style: CustomFonts.defaultField(CustomColors.primaryText),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintStyle:
                          CustomFonts.defaultField(CustomColors.primaryText),
                      hintText: LocaleKeys.Login_password_hint.tr(),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 10.smw),
                        child: CustomIcons.field_password_icon,
                      ),
                    ),
                  ))),
        ],
      ),
    );
  }

  Widget _notRegisteredYet() {
    return Container(
      margin: EdgeInsets.only(top: 20.smh),
      height: 25.smh,
      width: AppConstants.designWidth.smw,
      child: Row(
        children: [
          Expanded(
              child:
                  Container(height: 1, color: CustomColors.backgroundTextPale)),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.smw),
              child: CustomTextLocale(LocaleKeys.Login_not_registered_yet,
                  style:
                      CustomFonts.bodyText4(CustomColors.backgroundTextPale))),
          Expanded(
              child:
                  Container(height: 1, color: CustomColors.backgroundTextPale)),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: CustomColors.primary,
            child: SizedBox(
              height: 100.smh,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            context.setLocale(const Locale("tr"));
                          });
                          Navigator.pop(context);
                        },
                        child: CustomImages.tr_flag),
                    InkWell(
                        onTap: () {
                          setState(() {
                            context.setLocale(const Locale("en"));
                          });
                          Navigator.pop(context);
                        },
                        child: CustomImages.en_flag),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
