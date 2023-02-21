import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';

class OrderSuccessView extends ConsumerStatefulWidget {
  final String orderId;
  const OrderSuccessView({Key? key, required this.orderId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderSuccessViewState();
}

class _OrderSuccessViewState extends ConsumerState<OrderSuccessView> {
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
                CustomTextLocale(LocaleKeys.OrderSuccess_success_message,
                    style: CustomFonts.bodyText1(CustomColors.backgroundText)),
              ]),
              // SizedBox(height: 40.smh),
              // SizedBox(
              //   width: 320.smw,
              //   height: 50.smh,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       CustomTextLocale(LocaleKeys.OrderSuccess_order_number,
              //           args: [widget.orderId.toString()],
              //           maxLines: 2,
              //           style:
              //               CustomFonts.bodyText2(CustomColors.backgroundText)),
              //       SizedBox(width: 20.smw),
              //       InkWell(
              //           onTap: () {
              //             Clipboard.setData(
              //                 ClipboardData(text: widget.orderId));
              //             PopupHelper.showSuccessDialog(
              //                 LocaleKeys.OrderSuccess_success_clipboard.tr());
              //           },
              //           child: const Icon(Icons.copy))
              //     ],
              //   ),
              // ),
              SizedBox(height: 170.smh),
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
                            LocaleKeys.OrderSuccess_continue,
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
