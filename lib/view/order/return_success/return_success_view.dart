import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';

class ReturnSuccessView extends StatelessWidget {
  final String returnId;
  const ReturnSuccessView({super.key, required this.returnId});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationService.navigateToPage(const MainView());
        return false;
      },
      child: CustomSafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 20.smw, vertical: 35.smh),
                  child: CustomImages.basket_done),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    height: 40.smh,
                    width: 60.smw,
                    decoration: BoxDecoration(
                        color: CustomColors.secondary,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Icon(Icons.check,
                            color: Colors.white, size: 20.smh))),
                CustomTextLocale(LocaleKeys.ReturnSuccess_success_message,
                    style: CustomFonts.bodyText1(CustomColors.backgroundText)),
              ]),
              SizedBox(height: 40.smh),
              SizedBox(
                width: 320.smw,
                height: 50.smh,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextLocale(LocaleKeys.ReturnSuccess_return_number,
                        args: [returnId],
                        maxLines: 2,
                        style:
                            CustomFonts.bodyText2(CustomColors.backgroundText)),
                    SizedBox(width: 20.smw),
                    InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: returnId));
                          PopupHelper.showSuccessDialog(
                              LocaleKeys.ReturnSuccess_success_clipboard.tr());
                        },
                        child: const Icon(Icons.copy))
                  ],
                ),
              ),
              SizedBox(height: 10.smh),
              InkWell(
                onTap: () {
                  NavigationService.navigateToPageAndRemoveUntil(
                      const MainView());
                },
                child: Container(
                  height: 80.smh,
                  width: 290.smw,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: CustomColors.secondary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 80.smh,
                          width: 225.smw,
                          child: Center(
                              child: CustomTextLocale(
                            LocaleKeys.ReturnSuccess_continue,
                            style: CustomFonts.bigButton(
                                CustomColors.secondaryText),
                          ))),
                      SizedBox(
                          height: 80.smh,
                          width: 50.smw,
                          child: const Icon(Icons.arrow_forward_ios,
                              size: 50, color: Colors.white))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
