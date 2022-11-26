import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';
import 'package:koyevi/view/user/user_profile/user_profile_view_model.dart';

class UserProfileView extends ConsumerStatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileViewState();
}

class _UserProfileViewState extends ConsumerState<UserProfileView> {
  late final ChangeNotifierProvider<UserProfileViewModel> provider;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => UserProfileViewModel(formKey));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      appBar: CustomAppBar.activeBack(LocaleKeys.UserProfile_appbar_title.tr()),
      body: _body(),
    ));
  }

  Widget _body() {
    return _content();
  }

  Widget _content() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.smw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 20.smh),
                    child: CustomTextLocale(
                        LocaleKeys.UserProfile_personal_info,
                        style: CustomFonts.bodyText2(
                            CustomColors.backgroundText))),
                _customTextField(
                    hintText: LocaleKeys.UserProfile_name_surname.tr(),
                    formKey: "Name",
                    initialValue: AuthService.currentUser!.nameSurname),
                InkWell(
                    onTap: () async {
                      DateTime? result = await showDatePicker(
                          context: context,
                          initialDate: AuthService.currentUser!.birthDate ??
                              DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2030));
                      if (result != null) {
                        ref.watch(provider).setReadOnlyFormKey(
                            "BornDate", result.toString().split(" ")[0]);
                        log(ref.watch(provider).formData.toString());
                      }
                    },
                    child: _customReadOnlyField(
                        readKey: "BornDate",
                        hint: LocaleKeys.UserProfile_born_date.tr(),
                        initialValue: AuthService.currentUser!.birthDate
                            ?.toString()
                            .split(" ")[0])),
                _customTextField(
                    hintText: LocaleKeys.UserProfile_phone,
                    formKey: "MobilePhone",
                    initialValue:
                        (AuthService.currentUser!.phone ?? "").toString()),
                _customTextField(
                    hintText: LocaleKeys.UserProfile_email,
                    formKey: "Email",
                    initialValue: AuthService.currentUser!.email),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 20.smh),
                    child: SwitchListTile(
                        title: CustomTextLocale(
                            LocaleKeys.UserProfile_change_password,
                            style: CustomFonts.bodyText2(
                                CustomColors.backgroundText)),
                        activeColor: CustomColors.primary,
                        value: ref.watch(provider).changePassword,
                        onChanged: (value) {
                          ref.watch(provider).changePassword = value;
                        })),
                ref.watch(provider).changePassword
                    ? _passwordForm()
                    : Container()
              ],
            ),
          ),
          OkCancelPrompt(
              okCallBack: ref.read(provider).save,
              cancelCallBack: () {
                NavigationService.back();
              })
        ],
      ),
    );
  }

  Widget _customReadOnlyField(
      {required String hint, required String readKey, String? initialValue}) {
    if (initialValue != null && ref.watch(provider).formData[readKey] == null) {
      ref.read(provider).formData[readKey] = initialValue;
    }
    String value = ref.watch(provider).formData[readKey] ?? "";
    if (value.isEmpty) {
      value = hint;
    }
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.smh),
        width: 330.smw,
        height: 50.smh,
        padding: EdgeInsets.symmetric(horizontal: 10.smw),
        decoration: BoxDecoration(
            borderRadius: CustomThemeData.fullInfiniteRounded,
            color: CustomColors.primary),
        child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(value,
                style: CustomFonts.bodyText4(CustomColors.primaryText))));
  }

  Widget _customTextField(
      {required String hintText,
      required String formKey,
      bool obscureText = false,
      String? initialValue}) {
    return Container(
      width: 330.smw,
      height: 50.smh,
      margin: EdgeInsets.symmetric(vertical: 5.smh),
      decoration: BoxDecoration(
          borderRadius: CustomThemeData.fullInfiniteRounded,
          color: CustomColors.primary),
      child: Center(
          child: TextFormField(
        obscureText: obscureText,
        onSaved: (value) {
          ref.read(provider).formData[formKey] = value;
        },
        initialValue: initialValue,
        style: CustomFonts.bodyText4(CustomColors.primaryText),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: CustomFonts.bodyText4(CustomColors.primaryText),
            border: OutlineInputBorder(
                borderRadius: CustomThemeData.fullInfiniteRounded,
                borderSide: BorderSide.none)),
      )),
    );
  }

  Widget _passwordForm() {
    return Column(
      children: [
        _customTextField(
            hintText: LocaleKeys.UserProfile_old_password,
            formKey: "oldPassword",
            obscureText: true),
        _customTextField(
            hintText: LocaleKeys.UserProfile_new_password,
            formKey: "newPassword"),
        _customTextField(
            hintText: LocaleKeys.UserProfile_new_password_again,
            formKey: "newPasswordAgain"),
      ],
    );
  }
}
