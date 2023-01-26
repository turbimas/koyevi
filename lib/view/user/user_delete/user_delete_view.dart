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
import 'package:koyevi/core/utils/helpers/crypt_helper.dart';
import 'package:koyevi/core/utils/validators/validators.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';
import 'package:koyevi/view/user/user_delete/user_delete_view_model.dart';

class UserDeleteView extends ConsumerStatefulWidget {
  const UserDeleteView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserDeleteViewState();
}

class _UserDeleteViewState extends ConsumerState<UserDeleteView> {
  ChangeNotifierProvider<UserDeleteViewModel> provider =
      ChangeNotifierProvider<UserDeleteViewModel>(
          (ref) => UserDeleteViewModel());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: CustomAppBar.activeBack(LocaleKeys.UserDelete_appbar_title.tr(),
            showBasket: false),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomImages.delete_account,
              SizedBox(height: 20.smh),
              CustomTextLocale(LocaleKeys.UserDelete_password_prompt,
                  style: CustomFonts.bodyText2(CustomColors.backgroundText)),
              SizedBox(height: 20.smh),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.smw),
                padding: EdgeInsets.symmetric(horizontal: 20.smw),
                decoration: BoxDecoration(
                    color: CustomColors.primary,
                    borderRadius: CustomThemeData.fullInfiniteRounded),
                child: TextFormField(
                  controller: _controller,
                  style: CustomFonts.defaultField(CustomColors.primaryText),
                  validator: CustomValidators.instance.passwordValidator,
                  decoration: InputDecoration(
                      errorStyle:
                          CustomFonts.bodyText5(CustomColors.primaryText),
                      border: InputBorder.none,
                      hintText: LocaleKeys.UserDelete_password_hint.tr(),
                      hintStyle:
                          CustomFonts.defaultField(CustomColors.primaryText)),
                ),
              )
            ],
          ),
          OkCancelPrompt(
              okCallBack: _save,
              cancelCallBack: () {
                NavigationService.back();
              })
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (formKey.currentState!.validate()) {
      await ref.read(provider).deleteUser(CryptHelper.toMD5(_controller.text));
    }
  }
}
