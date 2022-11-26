import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/models/order/order_detail_row.dart';
import 'package:koyevi/product/models/user/user_orders_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/product_overview_view.dart';
import 'package:koyevi/view/order/order_cancel_return/order_cancel_return_view_model.dart';

class OrderCancelReturnView extends ConsumerStatefulWidget {
  final UserOrdersModel orderTitle;
  final List<OrderLinesModel> orderLines;
  const OrderCancelReturnView(
      {Key? key, required this.orderTitle, required this.orderLines})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderCancelReturnViewState();
}

class _OrderCancelReturnViewState extends ConsumerState<OrderCancelReturnView> {
  late final ChangeNotifierProvider<OrderCancelReturnViewModel> provider =
      ChangeNotifierProvider<OrderCancelReturnViewModel>((ref) =>
          OrderCancelReturnViewModel(
              lines: widget.orderLines, order: widget.orderTitle));

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ref.read(provider).createRequest,
          label: CustomTextLocale(widget.orderTitle.refundable
              ? LocaleKeys.OrderCancelReturn_return
              : LocaleKeys.OrderCancelReturn_cancel),
          backgroundColor: CustomColors.secondary,
          icon: Icon(Icons.check, color: CustomColors.secondaryText),
        ),
        appBar: CustomAppBar.activeBack(widget.orderTitle.refundable
            ? LocaleKeys.OrderCancelReturn_return
            : LocaleKeys.OrderCancelReturn_cancel),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return ListView.builder(
      itemCount: widget.orderLines.length,
      padding: EdgeInsets.symmetric(horizontal: 15.smw),
      itemBuilder: (context, index) {
        OrderLinesModel line = widget.orderLines[index];
        return _lineWidget(line);
      },
    );
  }

  Widget _lineWidget(OrderLinesModel linesModel) {
    return InkWell(
      onTap: () {
        if (linesModel.refundable || linesModel.voidable) {
          setState(() {
            ref.watch(provider).selectedLines.contains(linesModel)
                ? ref.watch(provider).selectedLines.remove(linesModel)
                : ref.watch(provider).selectedLines.add(linesModel);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.card,
            border: Border.all(color: CustomColors.primary),
            borderRadius: CustomThemeData.fullRounded),
        padding: EdgeInsets.symmetric(horizontal: 5.smw, vertical: 10.smh),
        margin: EdgeInsets.symmetric(vertical: 10.smh),
        width: 330.smw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child:
                    ProductOverViewHorizontalView(product: linesModel.product)),
            SizedBox(height: 20.smh),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.smw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomTextLocale(LocaleKeys.OrderCancelReturn_count,
                          args: [linesModel.amount.toStringAsFixed(2)],
                          style:
                              CustomFonts.bodyText4(CustomColors.cardTextPale)),
                      SizedBox(width: 10.smw),
                      CustomTextLocale(LocaleKeys.OrderCancelReturn_state,
                          args: [linesModel.lineStatusName],
                          style:
                              CustomFonts.bodyText4(CustomColors.cardTextPale)),
                    ],
                  ),
                  linesModel.refundable || linesModel.voidable
                      ? ref.watch(provider).selectedLines.contains(linesModel)
                          ? CustomIcons.checkbox_checked_icon
                          : CustomIcons.checkbox_unchecked_icon
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
