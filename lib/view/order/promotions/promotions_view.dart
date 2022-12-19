import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/models/order/promotion_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/order/promotions/promotions_view_model.dart';

class PromotionsView extends ConsumerStatefulWidget {
  final int selectedPromotionID;
  const PromotionsView({super.key, required this.selectedPromotionID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PromotionsViewState();
}

// TODO: add localization
class _PromotionsViewState extends ConsumerState<PromotionsView> {
  late final ChangeNotifierProvider<PromotionsViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) =>
        PromotionsViewModel(selectedPromotionID: widget.selectedPromotionID));
    Future.delayed(Duration.zero, () {
      ref.read(provider).getPromotions();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: CustomAppBar.activeBack("Promosyonlar"),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return CustomImages.loading;
    }

    if (ref.watch(provider).promotions.length == 1) {
      return TryAgain(callBack: ref.read(provider).getPromotions);
    }

    return _content();
  }

  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: ref.watch(provider).promotions.length,
          itemBuilder: (context, index) {
            return _promotionRow(ref.watch(provider).promotions[index]);
          },
        )
      ],
    );
  }

  Widget _promotionRow(PromotionModel promotionModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.smw),
      child: Container(
        margin: EdgeInsets.only(top: 10.smh),
        padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
        height: promotionModel.imageUrl == null ? 70.smh : 180.smh,
        width: 320.smw,
        decoration: BoxDecoration(
            borderRadius: CustomThemeData.fullRounded,
            color: CustomColors.card),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            promotionModel.imageUrl != null
                ? Image.network(promotionModel.imageUrl!,
                    height: 100.smh, width: 300.smw)
                : Container(),
            Row(
              children: [
                CustomText(promotionModel.promotionDescription,
                    style: CustomFonts.bodyText3(CustomColors.cardText)),
                const Spacer(),
                _choiceButton(promotionModel.promotionID)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _choiceButton(int id) {
    return InkWell(
      onTap: () {
        ref.read(provider).applyPromotion(id);
      },
      child: Container(
          height: 50.smh,
          width: 50.smh,
          decoration: BoxDecoration(
            borderRadius: CustomThemeData.fullRounded,
            color: ref.watch(provider).selectedPromotionID == id
                ? CustomColors.primary
                : CustomColors.secondary,
          ),
          child: Center(
              child: ref.watch(provider).selectedPromotionID == id
                  ? CustomIcons.check_icon
                  : CustomText("Seç",
                      style:
                          CustomFonts.bodyText3(CustomColors.secondaryText)))),
    );
  }
}
