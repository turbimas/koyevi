import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/models/user/delivery_time_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';

class DeliveryTimesView extends ConsumerStatefulWidget {
  final DeliveryTimeModel deliveryTimeModel;
  const DeliveryTimesView({Key? key, required this.deliveryTimeModel})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryTimesViewState();
}

class _DeliveryTimesViewState extends ConsumerState<DeliveryTimesView> {
  late Dates selectedDate;
  int selectedIndex = 0;

  @override
  void initState() {
    selectedDate = widget.deliveryTimeModel.dates.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      appBar:
          CustomAppBar.activeBack(LocaleKeys.DeliveryTime_appbar_title.tr()),
      body: Padding(
        padding: EdgeInsets.only(left: 0, top: 10.smh),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20.smh),
              padding: EdgeInsets.symmetric(horizontal: 20.smw),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      widget.deliveryTimeModel.dates.length,
                      (index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedDate =
                                    widget.deliveryTimeModel.dates[index];
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10.smw),
                              height: 100.smh,
                              width: 150.smw,
                              decoration: BoxDecoration(
                                  border: selectedIndex == index
                                      ? Border.all(color: CustomColors.primary)
                                      : null,
                                  borderRadius: CustomThemeData.fullRounded),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: CustomColors.card,
                                          borderRadius:
                                              CustomThemeData.topRounded),
                                      child: Center(
                                        child: CustomText(widget
                                            .deliveryTimeModel
                                            .dates[index]
                                            .dayName),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: CustomColors.cardInner,
                                          borderRadius:
                                              CustomThemeData.bottomRounded),
                                      child: Center(
                                        child: CustomText(widget
                                            .deliveryTimeModel
                                            .dates[index]
                                            .dayDateTime),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                ),
              ),
            ),
            ...List.generate(selectedDate.hours.length,
                (index) => _timeTile(time: selectedDate.hours[index]))
          ],
        ),
      ),
    ));
  }

  _timeTile({required String time}) {
    return InkWell(
      onTap: () {
        Navigator.pop(
            context, {"Date": selectedDate.dayDateTime, "Hour": time});
      },
      child: Container(
        height: 45.smh,
        width: 320.smw,
        margin: EdgeInsets.only(bottom: 5.smh),
        padding: EdgeInsets.only(left: 20.smh),
        decoration: BoxDecoration(
          color: CustomColors.secondary,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: CustomText(time,
              style: CustomFonts.bodyText3(CustomColors.secondaryText)),
        ),
      ),
    );
  }
}
