import 'dart:async';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/product_overview_view.dart';
import 'package:koyevi/view/order/basket/basket_view_model.dart';

class BasketView extends ConsumerStatefulWidget {
  const BasketView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BasketViewState();
}

class _BasketViewState extends ConsumerState<BasketView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  bool isExpanded = true;
  double last = 10;

  late final ChangeNotifierProvider<BasketViewModel> provider;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, value: 1);
    _scrollController.addListener(() {
      if (_scrollController.offset < last) {
        _expand();
      } else {
        _nonExpand();
      }
      last = _scrollController.offset;
    });
    provider = ChangeNotifierProvider((ref) => BasketViewModel());
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(provider).getBasket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _body(),
      appBar: CustomAppBar.inactiveBack(LocaleKeys.Basket_appbar_title.tr()),
    );
  }

  Widget _body() {
    return ref.watch(provider).retrieving ? _loading() : _content();
  }

  Widget _loading() {
    return Center(
      child: CustomImages.loading,
    );
  }

  Widget _content() {
    return ref.watch(provider).products.isEmpty ? _empty() : _notEmpty();
  }

  Widget _notEmpty() {
    return Stack(
      children: [
        Positioned(
          top: 10.smh,
          left: 15.smw,
          right: 15.smw,
          bottom: 75.smh,
          child: Column(children: [
            Row(
              children: [
                Container(
                  height: 50.smh,
                  padding: EdgeInsets.symmetric(horizontal: 20.smw),
                  decoration: BoxDecoration(
                      color: CustomColors.primary,
                      borderRadius: CustomThemeData.fullRounded),
                  width: 270.smw,
                  child: TextField(
                      onChanged: ref.read(provider).searchOnBasket,
                      style: CustomFonts.defaultField(CustomColors.primaryText),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            CustomFonts.defaultField(CustomColors.primaryText),
                        hintText: LocaleKeys.Basket_search_hint.tr(),
                      )),
                ),
                SizedBox(width: 10.smw),
                InkWell(
                  onTap: () => ref.read(provider).clearAll(context),
                  child: Container(
                    height: 50.smh,
                    width: 50.smw,
                    decoration: BoxDecoration(
                        color: CustomColors.primary,
                        borderRadius: CustomThemeData.fullRounded),
                    child: SizedBox(
                        height: 20.smh,
                        width: 15.smw,
                        child: CustomIcons.garbage_icon_light),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.smh),
            SizedBox(
              height: 500.smh,
              child: DynamicHeightGridView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  mainAxisSpacing: 10.smh,
                  crossAxisSpacing: 10.smw,
                  builder: (context, index) => Center(
                        child: ProductOverviewVerticalView(
                          product: ref.watch(provider).filteredProducts[index],
                          onBasketChanged: ref.read(provider).getBasket,
                        ),
                      ),
                  itemCount: ref.watch(provider).filteredProducts.length,
                  crossAxisCount: 2),
            ),
          ]),
        ),
        _detailExpanded()
      ],
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.smh),
            CustomImages.basket_empty,
            SizedBox(height: 40.smh),
            Text(LocaleKeys.BasketEmpty_basket_empty.tr(),
                style: CustomFonts.bodyText1(CustomColors.backgroundText)
                    .copyWith(fontSize: 30.sp)),
            SizedBox(height: 40.smh),
            InkWell(
              onTap: () => context.read<HomeIndexCubit>().set(2),
              child: Container(
                decoration: BoxDecoration(
                    color: CustomColors.secondary,
                    borderRadius: CustomThemeData.fullRounded),
                constraints:
                    BoxConstraints(maxWidth: 330.smw, minHeight: 70.smh),
                child: Center(
                    child: Text(
                  LocaleKeys.BasketEmpty_shop_now.tr(),
                  style: CustomFonts.bigButton(CustomColors.secondaryText),
                )),
              ),
            ),
          ]),
    );
  }

  Widget _detailExpanded() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Positioned(
        bottom: (-150 + _animationController.value * 225).smh,
        child: Column(
          children: [
            SizedBox(
                height: 25.smh,
                width: 300.smw,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.smw),
                    decoration: BoxDecoration(
                        color: CustomColors.card2,
                        borderRadius: CustomThemeData.topInfiniteRounded),
                    child: Center(
                        child: ref.watch(provider).basketTotal!.lineTotal >
                                ref
                                    .watch(provider)
                                    .basketTotal!
                                    .deliveryFreeAmount
                            ? CustomTextLocale(LocaleKeys.Basket_free_delivery,
                                style: CustomFonts.bodyText4(
                                    CustomColors.card2TextPale))
                            : CustomTextLocale(
                                LocaleKeys.Basket_for_free_delivery,
                                args: [
                                  (ref
                                              .watch(provider)
                                              .basketTotal!
                                              .deliveryFreeAmount -
                                          ref
                                              .watch(provider)
                                              .basketTotal!
                                              .lineTotal)
                                      .toStringAsFixed(2)
                                ],
                                style: CustomFonts.bodyText4(
                                    CustomColors.card2TextPale))))),
            Container(
              height: 200.smh,
              width: AppConstants.designWidth.smw,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: CustomColors.paymentCard,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF50745C).withOpacity(0.5),
                      blurRadius: 25,
                      blurStyle: BlurStyle.inner)
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: ref.read(provider).goBasketDetail,
                    child: Container(
                      height: 50.smh,
                      width: 300.smw,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          gradient: LinearGradient(
                            colors: CustomColors.paymentCard,
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomIcons.credit_card_icon_dark,
                          CustomTextLocale(LocaleKeys.Basket_continue_basket,
                              style:
                                  CustomFonts.bodyText2(CustomColors.cardText))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.symmetric(
                        horizontal: 25.smw, vertical: 10.smh),
                    height: 80.smh,
                    width: AppConstants.designWidth.smw,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextLocale(LocaleKeys.Basket_subtotal,
                                style: CustomFonts.bodyText4(
                                    CustomColors.cardText)),
                            CustomText(
                                ref
                                    .watch(provider)
                                    .basketTotal!
                                    .lineTotal
                                    .toStringAsFixed(2),
                                style: CustomFonts.bodyText4(
                                    CustomColors.cardText))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextLocale(LocaleKeys.Basket_delivery_cost,
                                style: CustomFonts.bodyText4(
                                    CustomColors.cardText)),
                            CustomText(
                                ref
                                    .watch(provider)
                                    .basketTotal!
                                    .deliveryTotal
                                    .toStringAsFixed(2),
                                style: CustomFonts.bodyText4(
                                    CustomColors.cardText))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextLocale(LocaleKeys.Basket_discount_cost,
                                style: CustomFonts.bodyText4(
                                    CustomColors.cardText)),
                            CustomText(
                                ref
                                    .watch(provider)
                                    .basketTotal!
                                    .promotionTotal
                                    .toStringAsFixed(2),
                                style: CustomFonts.bodyText4(
                                    CustomColors.cardText))
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(thickness: 1.smh, height: 1.smh),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 25.smw),
                      color: Colors.transparent,
                      height: 49.smh,
                      width: AppConstants.designWidth.smw,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextLocale(LocaleKeys.Basket_total,
                              style:
                                  CustomFonts.bodyText2(CustomColors.cardText)),
                          CustomText(
                              ref
                                  .watch(provider)
                                  .basketTotal!
                                  .generalTotal
                                  .toStringAsFixed(2),
                              style:
                                  CustomFonts.bodyText4(CustomColors.cardText))
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _expand() {
    if (isExpanded) {
      _animationController.animateTo(1,
          duration: const Duration(milliseconds: 800),
          curve: Curves.linearToEaseOut);
      isExpanded = false;
    }
  }

  void _nonExpand() {
    if (!isExpanded) {
      _animationController.animateTo(0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.linearToEaseOut);
      isExpanded = true;
    }
  }
}
