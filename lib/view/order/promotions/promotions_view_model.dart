import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/order/promotion_model.dart';

class PromotionsViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late int selectedPromotionID;

  List<PromotionModel> promotions = [];
  PromotionsViewModel({required this.selectedPromotionID});

  Future<void> getPromotions() async {
    try {
      isLoading = true;
      ResponseModel responseModel = await NetworkService.get(
          "orders/getapplicablepromotions/${AuthService.id}");
      if (responseModel.success) {
        promotions.clear();
        promotions.add(PromotionModel(
            promotionID: 0,
            promotionDescription: LocaleKeys.Promotions_not_use.tr()));
        promotions.addAll((responseModel.data as List)
            .map((e) => PromotionModel.fromJson(e)));
      } else {
        PopupHelper.showErrorDialog(errorMessage: responseModel.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> applyPromotion(int promotionId) async {
    try {
      isLoading = true;
      if (promotionId == 0) {
        ResponseModel clearPromotionResponse = await NetworkService.get(
            "orders/clearpromotions/${AuthService.id}");
        if (clearPromotionResponse.success) {
          selectedPromotionID = 0;
          NavigationService.back();
        } else {
          PopupHelper.showErrorDialog(
              errorMessage: clearPromotionResponse.errorMessage!);
        }
      } else {
        ResponseModel applyPromotionResponse = await NetworkService.get(
            "orders/usepromotion/${AuthService.id}/$promotionId");
        if (applyPromotionResponse.success) {
          selectedPromotionID = promotionId;
          NavigationService.back();
        } else {
          PopupHelper.showErrorDialog(
              errorMessage: applyPromotionResponse.errorMessage!);
        }
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }
}
