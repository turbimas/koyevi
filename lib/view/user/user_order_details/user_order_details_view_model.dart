import 'package:flutter/material.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/order/order_detail_row.dart';
import 'package:koyevi/product/models/product_detail_model.dart';
import 'package:koyevi/product/models/user/user_orders_model.dart';

class UserOrderDetailsViewModel extends ChangeNotifier {
  UserOrdersModel orderTitle;
  List<OrderLinesModel>? orderLines;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  UserOrderDetailsViewModel({required this.orderTitle});

  Future<void> getDetails() async {
    try {
      isLoading = true;
      ResponseModel response =
          await NetworkService.get("users/order_detail/${orderTitle.orderId}");
      if (response.success) {
        orderLines = (response.data as List)
            .map((e) => OrderLinesModel.fromJson(e))
            .toList();
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }
}
