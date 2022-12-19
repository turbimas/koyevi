import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/order/promotion_model.dart';

class UserPromotionsViewModel extends ChangeNotifier {
  UserPromotionsViewModel();
  List<PromotionModel>? promotions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getPromotions() async {
    try {
      isLoading = true;
      ResponseModelList response =
          await NetworkService.get("orders/getallpromotions/${AuthService.id}");
      if (response.success) {
        promotions =
            response.data!.map((e) => PromotionModel.fromJson(e)).toList();
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
