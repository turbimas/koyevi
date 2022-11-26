import 'package:flutter/material.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/order/order_detail_row.dart';
import 'package:koyevi/product/models/user/user_orders_model.dart';
import 'package:koyevi/view/order/cancel_success/cancel_success_view.dart';
import 'package:koyevi/view/order/return_success/return_success_view.dart';

class OrderCancelReturnViewModel extends ChangeNotifier {
  UserOrdersModel order;
  List<OrderLinesModel> lines;
  List<OrderLinesModel> selectedLines = [];
  OrderCancelReturnViewModel({required this.order, required this.lines});

  Future<void> createRequest() async {
    if (selectedLines.isEmpty) {
      PopupHelper.showErrorDialog(errorMessage: "Hiçbir satır seçilmedi");
      return;
    }
    try {
      String requestUrl =
          order.refundable ? "orders/CreateReturnOrder" : "orders/cancelorder";
      ResponseModel response = await NetworkService.post(requestUrl,
          body: selectedLines.map((e) => e.id).toList());
      if (response.success) {
        if (order.refundable) {
          NavigationService.navigateToPageReplace(
              ReturnSuccessView(returnId: response.data));
        } else {
          NavigationService.navigateToPageReplace(const CancelSuccessView());
        }
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
