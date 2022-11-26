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
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/models/order/order_detail_row.dart';
import 'package:koyevi/product/models/user/user_orders_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/product_overview_view.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/order/order_cancel_return/order_cancel_return_view.dart';
import 'package:koyevi/view/user/user_order_details/user_order_details_view_model.dart';

class UserOrderDetailsView extends ConsumerStatefulWidget {
  final UserOrdersModel orderTitle;
  const UserOrderDetailsView({Key? key, required this.orderTitle})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserOrderDetailsViewState();
}

class _UserOrderDetailsViewState extends ConsumerState<UserOrderDetailsView> {
  late final ChangeNotifierProvider<UserOrderDetailsViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider(
        (ref) => UserOrderDetailsViewModel(orderTitle: widget.orderTitle));
    Future.delayed(Duration.zero, () {
      ref.read(provider).getDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: CustomAppBar.activeBack(
            LocaleKeys.UserOrderDetails_appbar_title.tr()),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return ref.watch(provider).isLoading
        ? _loading()
        : ref.watch(provider).orderLines == null
            ? TryAgain(
                callBack: ref.read(provider).getDetails,
              )
            : _content();
  }

  Widget _loading() {
    return Center(
      child: CustomImages.loading,
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
        child: Column(
          children: [
            _orderDetails(),
            _deliveryDetails(),
            _invoiceDetails(),
            _paymentDetails(),
            _productsHeader(),
            const Divider(),
            _cancelReturnButton(),
            ..._products(),
          ],
        ),
      ),
    );
  }

  Widget _orderDetails() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.smh),
      width: 320.smw,
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.primary),
          borderRadius: CustomThemeData.fullRounded,
          color: CustomColors.card2),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
            width: 340.smw,
            decoration: BoxDecoration(
              color: CustomColors.primary,
              borderRadius: CustomThemeData.topRounded,
            ),
            child: Center(
                child: CustomTextLocale(LocaleKeys.UserOrderDetails_order_info,
                    style: CustomFonts.bodyText3(CustomColors.primaryText))),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
            constraints: BoxConstraints(minHeight: 80.smh),
            width: 340.smw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(LocaleKeys.UserOrderDetails_no,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(widget.orderTitle.ficheNo,
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(LocaleKeys.UserOrderDetails_date,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.orderDate.toString(),
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(
                          LocaleKeys.UserOrderDetails_status,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(widget.orderTitle.statusName,
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _deliveryDetails() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.smh),
      width: 320.smw,
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.primary),
          borderRadius: CustomThemeData.fullRounded,
          color: CustomColors.card2),
      child: Column(
        children: [
          Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
              width: 340.smw,
              decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: CustomThemeData.topRounded,
              ),
              child: Center(
                  child: CustomTextLocale(
                      LocaleKeys.UserOrderDetails_delivery_info,
                      style: CustomFonts.bodyText3(CustomColors.primaryText)))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
            constraints: BoxConstraints(minHeight: 100.smh),
            width: 340.smw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(
                          LocaleKeys.UserOrderDetails_estimated_delivery_time,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.deliveryAddressDetail!
                                        .deliveryDate !=
                                    null
                                ? widget.orderTitle.deliveryAddressDetail!
                                    .deliveryDate
                                    .toString()
                                : "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(
                          LocaleKeys.UserOrderDetails_delivery_time,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.realDeliveryDate != null
                                ? widget.orderTitle.realDeliveryDate.toString()
                                : "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(LocaleKeys.UserOrderDetails_name,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.deliveryAddressDetail
                                    ?.relatedPerson ??
                                "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(LocaleKeys.UserOrderDetails_phone,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.deliveryAddressDetail?.phone ??
                                "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(
                          LocaleKeys.UserOrderDetails_address,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.deliveryAddressDetail?.address ??
                                "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _invoiceDetails() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.smh),
      width: 320.smw,
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.primary),
          borderRadius: CustomThemeData.fullRounded,
          color: CustomColors.card2),
      child: Column(
        children: [
          Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
              width: 340.smw,
              decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: CustomThemeData.topRounded,
              ),
              child: Center(
                  child: CustomTextLocale(
                      LocaleKeys.UserOrderDetails_invoice_info,
                      style: CustomFonts.bodyText3(CustomColors.primaryText)))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
            constraints: BoxConstraints(minHeight: 100.smh),
            width: 340.smw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(LocaleKeys.UserOrderDetails_name,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.invoiceAddressDetail
                                    ?.relatedPerson ??
                                "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(LocaleKeys.UserOrderDetails_phone,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.invoiceAddressDetail?.phone ??
                                "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(
                          LocaleKeys.UserOrderDetails_tax_office,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.invoiceAddressDetail?.taxOffice ??
                                "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(
                          widget.orderTitle.invoiceAddressDetail?.isPerson ??
                                  false
                              ? LocaleKeys.UserOrderDetails_identity_no
                              : LocaleKeys.UserOrderDetails_tax_no,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.invoiceAddressDetail?.isPerson ??
                                    false
                                ? widget.orderTitle.invoiceAddressDetail
                                        ?.tcNo ??
                                    "-"
                                : widget.orderTitle.invoiceAddressDetail
                                        ?.taxNumber ??
                                    "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextLocale(
                          LocaleKeys.UserOrderDetails_address,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.smw),
                        child: CustomText(
                            widget.orderTitle.invoiceAddressDetail?.address ??
                                "-",
                            style:
                                CustomFonts.bodyText4(CustomColors.card2Text)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _paymentDetails() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.smh),
      width: 320.smw,
      decoration: BoxDecoration(
          border: Border.all(color: CustomColors.primary),
          borderRadius: CustomThemeData.fullRounded,
          color: CustomColors.card2),
      child: Column(
        children: [
          Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
              width: 340.smw,
              decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: CustomThemeData.topRounded,
              ),
              child: Center(
                  child: CustomTextLocale(
                      LocaleKeys.UserOrderDetails_payment_info,
                      style: CustomFonts.bodyText3(CustomColors.primaryText)))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
            constraints: BoxConstraints(minHeight: 100.smh),
            width: 340.smw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextLocale(LocaleKeys.UserOrderDetails_subtotal,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                      CustomText(
                          "${widget.orderTitle.orderTotals?.lineTotal.toStringAsFixed(2)} TL",
                          style: CustomFonts.bodyText4(CustomColors.card2Text)),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextLocale(
                          LocaleKeys.UserOrderDetails_delivery_cost,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                      CustomText(
                          "${widget.orderTitle.orderTotals?.deliveryTotal.toStringAsFixed(2)} TL",
                          style: CustomFonts.bodyText4(CustomColors.card2Text)),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextLocale(LocaleKeys.UserOrderDetails_total,
                          style: CustomFonts.bodyText4(
                              CustomColors.card2TextPale)),
                      CustomText(
                          "${widget.orderTitle.orderTotals?.generalTotal.toStringAsFixed(2)} TL",
                          style: CustomFonts.bodyText4(CustomColors.card2Text)),
                    ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cancelReturnButton() {
    late String text = "";
    if (widget.orderTitle.refundable) {
      text = LocaleKeys.UserOrderDetails_return.tr();
    } else if (widget.orderTitle.voidable) {
      text = LocaleKeys.UserOrderDetails_cancel.tr();
    } else {
      return Container();
    }
    return InkWell(
      onTap: () {
        NavigationService.navigateToPage(OrderCancelReturnView(
            orderTitle: widget.orderTitle,
            orderLines: ref.watch(provider).orderLines!));
      },
      child: Container(
        height: 50.smh,
        color: CustomColors.primary,
        child: Center(
            child: CustomText(text,
                style: CustomFonts.bodyText2(CustomColors.primaryText))),
      ),
    );
  }

  Widget _productsHeader() {
    return Container(
      width: AppConstants.designWidth.smw,
      margin: EdgeInsets.only(top: 10.smh, bottom: 5.smh),
      child: Center(
        child: CustomTextLocale(
          LocaleKeys.UserOrderDetails_products,
          style: CustomFonts.bodyText2(CustomColors.backgroundText),
        ),
      ),
    );
  }

  List<Widget> _products() {
    return List.generate(ref.watch(provider).orderLines!.length,
        (index) => _productCard(ref.watch(provider).orderLines![index]));
  }

  Widget _productCard(OrderLinesModel linesModel) {
    return Container(
      decoration: BoxDecoration(
          color: CustomColors.card,
          border: Border.all(color: CustomColors.primary),
          borderRadius: CustomThemeData.fullRounded),
      padding: EdgeInsets.symmetric(horizontal: 5.smw, vertical: 10.smh),
      margin: EdgeInsets.symmetric(vertical: 10.smh),
      height: 150.smh,
      width: 330.smw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductOverViewHorizontalView(product: linesModel.product),
          SizedBox(height: 20.smh),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.smw),
            child: Row(
              children: [
                CustomTextLocale(LocaleKeys.UserOrderDetails_amount,
                    args: [linesModel.amount.toStringAsFixed(2)],
                    style: CustomFonts.bodyText4(CustomColors.cardTextPale)),
                SizedBox(width: 10.smw),
                CustomTextLocale(LocaleKeys.UserOrderDetails_status,
                    args: [linesModel.lineStatusName],
                    style: CustomFonts.bodyText4(CustomColors.cardTextPale)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
