import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar:
            CustomAppBar.activeBack(LocaleKeys.Promotions_appbar_title.tr()),
        body: ListView.builder(
          itemCount: ref.watch(provider).promotionMessages.length,
          itemBuilder: (context, index) => _promotionCard(index),
        ),
      ),
    );
  }

  _promotionCard(index) {
    String promotionMessage = ref.watch(provider).promotionMessages[index];
    return Container(
        margin: EdgeInsets.only(bottom: 10.smh),
        width: AppConstants.designWidth.smw,
        decoration: BoxDecoration(
            color: CustomColors.card, boxShadow: CustomThemeData.shadow3),
        height: 215.smh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15.smw),
              height: 30.smw,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Promosyon",
                    style: CustomFonts.bodyText4(CustomColors.cardText)),
              ),
            ),
            ClipRRect(
              borderRadius: CustomThemeData.fullRounded,
              child: Image.network("https://picsum.photos/200/300",
                  fit: BoxFit.fill, width: 340.smw, height: 170.smh),
            ),
          ],
        ));
  }
}
