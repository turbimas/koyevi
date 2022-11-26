// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/product_detail_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/view/product/product_detail/product_detail_view.dart';

class ProductOverviewVerticalView extends ConsumerStatefulWidget {
  ProductOverViewModel product;
  final Function? onBasketChanged;
  final Function? onFavoriteChanged;
  final Function? onBackFromDetail;
  ProductOverviewVerticalView(
      {Key? key,
      this.onBasketChanged,
      this.onFavoriteChanged,
      this.onBackFromDetail,
      required this.product})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductOverviewViewVerticalState();
}

class _ProductOverviewViewVerticalState
    extends ConsumerState<ProductOverviewVerticalView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String statusMessage = LocaleKeys.ProductOverView_add_to_basket.tr();
    if (!widget.product.canShipped) {
      statusMessage = LocaleKeys.ProductOverView_cant_shipped.tr();
    }
    if (!widget.product.inSale) {
      statusMessage = LocaleKeys.ProductOverView_not_in_sale.tr();
    }

    return AnimatedContainer(
      duration: CustomThemeData.animationDurationMedium,
      constraints: BoxConstraints(minHeight: 250.smh, maxWidth: 160.smw),
      width: 160.smw,
      decoration: BoxDecoration(
          border: widget.product.basketQuantity != null
              ? Border.all(color: CustomColors.secondary)
              : null,
          borderRadius: CustomThemeData.fullRounded,
          color: Colors.transparent),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            // image
            height: 160.smh,
            child: Stack(
              children: [
                Positioned.fill(
                  child: InkWell(
                    onTap: _goDetailPage,
                    child: ClipRRect(
                        borderRadius: CustomThemeData.topRounded,
                        child: widget.product
                            .image(height: 160.smh, width: 160.smw)),
                  ),
                ),
                Positioned(
                    bottom: 5.smh,
                    left: 5.smw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_unitCodeChip(), _favoriteChip()],
                    )),
                Positioned(
                  top: 10.smh,
                  right: 10.smw,
                  child: InkWell(
                    onTap: _favorite,
                    child: widget.product.isFavorite
                        ? CustomIcons.favorite_circle_icon
                        : CustomIcons.non_favorite_circle_icon,
                  ),
                )
              ],
            ),
          ),
          InkWell(
            // info container
            onTap: _goDetailPage,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.smw, vertical: 5.smh),
              color: CustomColors.cardInner,
              width: 160.smw,
              constraints: BoxConstraints(minHeight: 90.smh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(widget.product.name,
                          maxLines: 2,
                          style: CustomFonts.bodyText4(
                              CustomColors.cardInnerText)),
                    ],
                  ),
                  SizedBox(height: 5.smh),
                  CustomText(
                    "${widget.product.unitPrice.toStringAsFixed(2)} TL",
                    style: CustomFonts.bodyText2(CustomColors.cardInnerText),
                  )
                ],
              ),
            ),
          ),
          AnimatedContainer(
            // button container
            duration: CustomThemeData.animationDurationLong,
            height: 40.smh,
            width: 160.smw,
            decoration: BoxDecoration(
              borderRadius: CustomThemeData.bottomRounded,
              color: widget.product.canShipped && widget.product.inSale
                  ? CustomColors.secondary
                  : CustomColors.disabled,
            ),
            child: widget.product.basketQuantity == null
                ? InkWell(
                    onTap: widget.product.canShipped && widget.product.inSale
                        ? _addBasket
                        : () {},
                    child: Row(
                      mainAxisAlignment:
                          widget.product.canShipped && widget.product.inSale
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.center,
                      children: [
                        widget.product.canShipped && widget.product.inSale
                            ? CustomIcons.add_basket_outlined_icon
                            : Container(),
                        CustomText(
                          statusMessage,
                          style:
                              CustomFonts.bodyText4(CustomColors.secondaryText),
                        )
                      ],
                    ))
                : _basketCount(),
          ),
        ],
      ),
    );
  }

  Widget _unitCodeChip() {
    return Container(
      margin: EdgeInsets.only(right: 5.smh),
      constraints: BoxConstraints(minWidth: 30.smw, minHeight: 15.smh),
      decoration: BoxDecoration(
          color: CustomColors.secondary,
          borderRadius: CustomThemeData.fullInfiniteRounded),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.smw),
        child: Center(
            child: CustomText(widget.product.unitCode,
                style: CustomFonts.bodyText5(CustomColors.secondaryText))),
      ),
    );
  }

  Widget _favoriteChip() {
    bool isVisible = false;
    if (widget.product.evaluationAverage > 0) {
      isVisible = true;
    } else {
      isVisible = false;
    }

    if (isVisible) {
      return Container(
        decoration: BoxDecoration(
            color: CustomColors.secondary,
            borderRadius: CustomThemeData.fullInfiniteRounded),
        constraints: BoxConstraints(minWidth: 30.smw, minHeight: 15.smh),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.smw),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcons.star_chip_icon,
                SizedBox(width: 5.smw),
                CustomText(widget.product.evaluationAverage.toStringAsFixed(1),
                    style: CustomFonts.bodyText5(CustomColors.secondaryText))
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Future<void> _addBasket() async {
    // setState(() {
    // widget.product.basketQuantity ??= 0;
    // widget.product.basketQuantity = widget.product.basketQuantity! + 1;
    // });
    try {
      ResponseModel response =
          await NetworkService.post("orders/addbasket", body: {
        "CariID": AuthService.currentUser!.id,
        "Barcode": widget.product.barcode,
        "Quantity": widget.product.basketFactor,
      });

      if (response.success) {
        setState(() {
          widget.product.basketQuantity ??= 0;
          widget.product.basketQuantity =
              widget.product.basketQuantity! + widget.product.basketFactor;
          widget.onBasketChanged?.call();
        });
      } else {
        // setState(() {
        //   widget.product.basketQuantity = widget.product.basketQuantity! - 1;
        //   if (widget.product.basketQuantity == 0) {
        //     widget.product.basketQuantity = null;
        //   }
        // });
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      // setState(() {
      //   widget.product.basketQuantity = widget.product.basketQuantity! - 1;
      //   if (widget.product.basketQuantity == 0) {
      //     widget.product.basketQuantity = null;
      //   }
      // });
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> _removeBasket() async {
    // // setState(() {
    // widget.product.basketQuantity = widget.product.basketQuantity! - 1;
    // if (widget.product.basketQuantity! <= 0) {
    //   widget.product.basketQuantity = null;
    // }
    // // });
    try {
      ResponseModel response =
          await NetworkService.post("orders/updatebasket", body: {
        "CariID": AuthService.currentUser!.id,
        "Barcode": widget.product.barcode,
        "Quantity": widget.product.basketQuantity != null
            ? (widget.product.basketQuantity! - widget.product.basketFactor)
            : 0
      });
      if (response.success) {
        setState(() {
          widget.onBasketChanged?.call();
          widget.product.basketQuantity =
              widget.product.basketQuantity! - widget.product.basketFactor;
          if (widget.product.basketQuantity! <= 0) {
            widget.product.basketQuantity = null;
          }
        });
      } else {
        // setState(() {
        //   widget.product.basketQuantity =
        //       (widget.product.basketQuantity ?? 0) + 1;
        // });
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      // setState(() {
      //   widget.product.basketQuantity =
      //       (widget.product.basketQuantity ?? 0) + 1;
      // });
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Widget _basketCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: InkWell(
                onTap: _removeBasket,
                child: Center(
                    child: CustomText("-",
                        style: CustomFonts.bodyText1(
                            CustomColors.secondaryText))))),
        Container(color: CustomColors.secondaryText, width: 1),
        Expanded(
          child: Center(
            child: CustomText(widget.product.basketQuantity!.toStringAsFixed(2),
                style: CustomFonts.bodyText3(CustomColors.secondaryText)),
          ),
        ),
        Container(color: CustomColors.secondaryText, width: 1),
        Expanded(
            child: InkWell(
                onTap: _addBasket,
                child: Center(
                    child: CustomText("+",
                        style: CustomFonts.bodyText1(
                            CustomColors.secondaryText))))),
      ],
    );
  }

  Future<void> _favorite() async {
    setState(() {
      if (widget.product.isFavorite) {
        widget.product.favoriteId = 0;
      } else {
        widget.product.favoriteId = 1;
      }
    });
    try {
      ResponseModel response = await NetworkService.get(
          "products/favoriteupdate/${AuthService.currentUser!.id}/${widget.product.barcode}");
      if (!response.success) {
        setState(() {
          if (widget.product.isFavorite) {
            widget.product.favoriteId = 0;
          } else {
            widget.product.favoriteId = 1;
          }
        });
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      } else {
        widget.onFavoriteChanged?.call();
        PopupHelper.showSuccessToast(widget.product.isFavorite
            ? LocaleKeys.ProductOverView_product_added_favorites.tr()
            : LocaleKeys.ProductOverView_product_removed_favorites.tr());
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  void _goDetailPage() {
    NavigationService.navigateToPage<ProductDetailModel?>(
            ProductDetailView(productOverViewModel: widget.product))
        .then((value) {
      if (value != null) {
        setState(() {
          widget.product.updateWithProductDetailModel(value);
        });
      }
    }).then((value) {
      widget.onBackFromDetail?.call();
    });
  }
}

class ProductOverViewHorizontalView extends StatelessWidget {
  final ProductOverViewModel product;
  const ProductOverViewHorizontalView({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService.navigateToPage(
            ProductDetailView(productOverViewModel: product));
      },
      child: Container(
        width: 320.smw,
        height: 90.smh,
        decoration: BoxDecoration(
          color: CustomColors.cardInner,
          border: Border.all(color: CustomColors.primary, width: 1),
          borderRadius: CustomThemeData.fullRounded,
        ),
        padding: EdgeInsets.symmetric(vertical: 5.smh, horizontal: 5.smw),
        child: Row(
          children: [
            SizedBox(
              height: 80.smh,
              width: 80.smw,
              child: ClipRRect(
                borderRadius: CustomThemeData.fullRounded,
                child: product.image(height: 80.smh, width: 80.smh),
              ),
            ),
            SizedBox(width: 20.smw),
            SizedBox(
              width: 205.smw,
              height: 80.smh,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (product.tradeMark != null || product.tradeMark != null
                              ? product.tradeMark!.isEmpty
                              : false)
                          ? CustomText(
                              product.tradeMark!,
                              style: CustomFonts.bodyText3(
                                  CustomColors.cardInnerTextPale),
                            )
                          : Container(),
                      CustomText(
                        product.name + product.aciklama,
                        maxLines: 2,
                        style:
                            CustomFonts.bodyText4(CustomColors.cardInnerText),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                minHeight: 15.smh, minWidth: 30.smw),
                            padding: EdgeInsets.symmetric(horizontal: 5.smw),
                            decoration: BoxDecoration(
                                borderRadius:
                                    CustomThemeData.fullInfiniteRounded,
                                color: CustomColors.primary),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIcons.star_chip_icon,
                                  SizedBox(width: 5.smw),
                                  CustomText(
                                    product.evaluationAverage
                                        .toStringAsFixed(1),
                                    style: CustomFonts.bodyText4(
                                        CustomColors.primaryText),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 5.smw),
                          Container(
                            constraints: BoxConstraints(
                                minHeight: 15.smh, minWidth: 30.smw),
                            decoration: BoxDecoration(
                              color: CustomColors.primary,
                              borderRadius: CustomThemeData.fullInfiniteRounded,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5.smw),
                            child: Center(
                              child: CustomText(product.unitCode,
                                  style: CustomFonts.bodyText4(
                                      CustomColors.primaryText)),
                            ),
                          )
                        ],
                      ),
                      CustomText(
                        "${product.unitPrice.toStringAsFixed(2)} TL",
                        style: CustomFonts.bodyText1(CustomColors.primary),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
