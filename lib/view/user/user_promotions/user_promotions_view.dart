import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/models/order/promotion_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/user/user_promotions/user_promotions_view_model.dart';

class UserPromotionsView extends ConsumerStatefulWidget {
  const UserPromotionsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserPromotionsViewState();
}

class _UserPromotionsViewState extends ConsumerState<UserPromotionsView> {
  late final ChangeNotifierProvider<UserPromotionsViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => UserPromotionsViewModel());
    ref.read(provider).getPromotions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: CustomAppBar.activeBack(
            LocaleKeys.UserPromotions_appbar_title.tr()),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return _loading();
    }
    if (ref.watch(provider).promotions == null) {
      return TryAgain(callBack: ref.read(provider).getPromotions);
    }
    if (ref.watch(provider).promotions!.isEmpty) {
      return _empty();
    }
    return _content();
  }

  Widget _loading() {
    return Center(child: CustomImages.loading);
  }

  Widget _empty() {
    return Center(
      child: CustomTextLocale(
        LocaleKeys.UserPromotions_no_promotion,
        style: CustomFonts.bodyText1(CustomColors.backgroundText),
      ),
    );
  }

  Widget _content() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ref.watch(provider).promotions!.length,
      itemBuilder: (context, index) =>
          _promotionRow(ref.watch(provider).promotions![index]),
    );
  }

  Widget _promotionRow(PromotionModel promotionModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.smw),
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.card,
            borderRadius: CustomThemeData.fullRounded),
        height: promotionModel.imageUrl != null ? 180.smh : 70.smh,
        padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
        margin: EdgeInsets.only(top: 10.smh),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            promotionModel.imageUrl != null
                ? Image.network(promotionModel.imageUrl!,
                    height: 100.smh, width: 300.smw, fit: BoxFit.cover)
                : Container(),
            CustomText(
              promotionModel.promotionDescription * 50,
              maxLines: 3,
              style: CustomFonts.bodyText3(CustomColors.cardText),
            ),
          ]),
        ),
      ),
    );
  }
}
