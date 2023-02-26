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
import 'package:koyevi/core/utils/helpers/crypt_helper.dart';
import 'package:koyevi/core/utils/validators/validators.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/terms/kayit_on_bilgilendirme_formu.dart';
import 'package:koyevi/view/auth/register/register_view_model.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  late ChangeNotifierProvider<RegisterViewModel> provider;

  late final FocusNode _nameSurnameFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _passwordFocusNode;

  final TextEditingController _phoneController =
      TextEditingController(text: "90");

  @override
  void initState() {
    provider =
        ChangeNotifierProvider<RegisterViewModel>((ref) => RegisterViewModel());
    _nameSurnameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameSurnameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar.activeBack(LocaleKeys.Register_appbar_title.tr()),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_image(), _form(), _agreement(), _registerButton()],
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Opacity(
      opacity: ref.watch(provider).licenseAccepted ? 1 : 0.5,
      child: AbsorbPointer(
        absorbing: ref.watch(provider).licenseAccepted ? false : true,
        child: InkWell(
          onTap: ref.read(provider).register,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.smw),
            height: 75.smh,
            width: 270.smw,
            decoration: BoxDecoration(
                color: CustomColors.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(45))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextLocale(LocaleKeys.Register_register_button,
                      style: CustomFonts.bigButton(CustomColors.secondaryText)),
                  CustomIcons.enter_icon
                ]),
          ),
        ),
      ),
    );
  }

  InkWell _agreement() {
    return InkWell(
      onTap: () {
        ref.watch(provider).licenseAccepted =
            !ref.watch(provider).licenseAccepted;
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 25.smh),
        height: 30.smh,
        width: AppConstants.designWidth.smw,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ref.watch(provider).licenseAccepted
              ? CustomIcons.checkbox_checked_icon
              : CustomIcons.checkbox_unchecked_icon,
          SizedBox(width: 5.smw),
          InkWell(
              onTap: () {
                NavigationService.navigateToPage(
                    const KayitOnBilgilendirmeFormu());
              },
              child: CustomTextLocale(LocaleKeys.Register_term_condition_1,
                  style: CustomFonts.bodyText4(CustomColors.primary))),
          SizedBox(width: 5.smw),
          CustomTextLocale(LocaleKeys.Register_term_condition_2,
              style: CustomFonts.bodyText4(CustomColors.backgroundText))
        ]),
      ),
    );
  }

  Form _form() {
    return Form(
        autovalidateMode: AutovalidateMode.disabled,
        key: ref.watch(provider).formKey,
        child: AutofillGroup(
          child: Column(
            children: [
              _customTextField(
                  // focusNode: _nameSurnameFocusNode,
                  // nextFocusNode: _phoneFocusNode,
                  key: "Name",
                  autofillHints: [AutofillHints.name],
                  validator: CustomValidators.instance.fullNameValidator,
                  hint: LocaleKeys.Register_full_name_hint.tr(),
                  icon: CustomIcons.field_profile_icon),
              _customTextField(
                  // focusNode: _phoneFocusNode,
                  // nextFocusNode: _passwordFocusNode,
                  key: "MobilePhone",
                  controller: _phoneController,
                  autofillHints: [AutofillHints.telephoneNumber],
                  validator: CustomValidators.instance.phoneValidator,
                  keyboardType: TextInputType.phone,
                  hint: LocaleKeys.Register_phone_hint.tr(),
                  icon: CustomIcons.field_phone_icon),
              _customTextField(
                  // focusNode: _passwordFocusNode,
                  key: "Password",
                  autofillHints: [AutofillHints.password],
                  validator: CustomValidators.instance.passwordValidator,
                  keyboardType: TextInputType.visiblePassword,
                  hint: LocaleKeys.Register_password_hint.tr(),
                  icon: CustomIcons.field_password_icon,
                  suffixIcon: CustomIcons.field_hide_password)
            ],
          ),
        ));
  }

  Padding _image() {
    return Padding(
        padding: EdgeInsets.only(
            top: 25.smh, left: 70.smh, right: 70.smh, bottom: 70.smh),
        child: CustomImages.register);
  }

  Widget _customTextField(
      {required String key,
      String? initialValue,
      required String hint,
      TextEditingController? controller,
      required List<String> autofillHints,
      required Widget icon,
      String? Function(String?)? validator,
      // required FocusNode focusNode,
      // FocusNode? nextFocusNode,
      Widget? suffixIcon,
      TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.smh),
      constraints: BoxConstraints(minHeight: 50.smw),
      width: 300.smw,
      padding: EdgeInsets.only(left: 10.smw, right: 20.smw),
      decoration: BoxDecoration(
          color: CustomColors.primary,
          borderRadius: CustomThemeData.fullInfiniteRounded),
      child: Row(
        children: [
          icon,
          Expanded(
              child: TextFormField(
            controller: controller,
            onChanged: (value) {
              if (key == "MobilePhone" && value.length <= 2 && value != "90") {
                controller!.text = "90";
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
              }
            },
            autofillHints: autofillHints,
            initialValue: initialValue,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            validator: validator ?? CustomValidators.instance.notEmpty,
            // focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              // if (nextFocusNode != null) {
              //   Focus.of(context).requestFocus(nextFocusNode);
              // } else {
              //   Focus.of(context).unfocus();
              // }
            },
            onSaved: (newValue) {
              if (key == "Password" && newValue != null) {
                ref.watch(provider).registerData[key] =
                    CryptHelper.toMD5(newValue);
              } else {
                ref.watch(provider).registerData[key] = newValue;
                if (newValue != null) {
                  ref.watch(provider).registerData[key] = newValue;
                }
              }
            },
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.left,
            obscureText: suffixIcon != null && ref.watch(provider).isHiding,
            decoration: InputDecoration(
              hintText: hint,
              errorStyle: CustomFonts.bodyText4(CustomColors.primaryText),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: CustomThemeData.fullInfiniteRounded),
              hintStyle: CustomFonts.defaultField(CustomColors.primaryText),
            ),
            style: CustomFonts.defaultField(CustomColors.primaryText),
          )),
          suffixIcon != null
              ? InkWell(
                  onTap: () {
                    ref.watch(provider).isHiding =
                        !ref.watch(provider).isHiding;
                  },
                  child: CustomIcons.field_hide_password)
              : Container()
        ],
      ),
    );
  }
}
