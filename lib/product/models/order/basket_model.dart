import 'package:koyevi/product/models/order/basket_line_model.dart';

class BasketModel {
  late int promotionID;
  late double minFreeDeliveryTotals;
  late double minDeliveryTotals;
  late double lineTotals;
  late double deliveryTotals;
  late double promotionTotals;
  late double generalTotals;
  late List<BasketLineModel> basketDetails;

  BasketModel.fromJson(Map<String, dynamic> json) {
    promotionID = json['PromotionID'];
    minFreeDeliveryTotals = json['MinFreeDeliveryTotals'];
    minDeliveryTotals = json['MinDeliveryTotals'];
    lineTotals = json['LineTotals'];
    deliveryTotals = json['DeliveryTotals'];
    promotionTotals = json['PromotionTotals'];
    generalTotals = json['GeneralTotals'];
    basketDetails = (json['BasketDetails'] as List)
        .map((e) => BasketLineModel.fromJson(e))
        .toList();
    basketDetails
        .removeWhere((element) => element.product.barcode == "DELIVERY");
  }

  reFillFromJson(Map<String, dynamic> json) {
    promotionID = json['PromotionID'];
    minFreeDeliveryTotals = json['MinFreeDeliveryTotals'];
    minDeliveryTotals = json['MinDeliveryTotals'];
    lineTotals = json['LineTotals'];
    deliveryTotals = json['DeliveryTotals'];
    promotionTotals = json['PromotionTotals'];
    generalTotals = json['GeneralTotals'];
    basketDetails = (json['BasketDetails'] as List)
        .map((e) => BasketLineModel.fromJson(e))
        .toList();
    basketDetails
        .removeWhere((element) => element.product.barcode == "DELIVERY");
  }

  Map<String, dynamic> toJson() {
    return {
      'PromotionID': promotionID,
      'MinFreeDeliveryTotals': minFreeDeliveryTotals,
      'MinDeliveryTotals': minDeliveryTotals,
      'LineTotals': lineTotals,
      'DeliveryTotals': deliveryTotals,
      'PromotionTotals': promotionTotals,
      'GeneralTotals': generalTotals,
      'BasketDetails': basketDetails.map((e) => e.toJson()).toList(),
    };
  }
}
