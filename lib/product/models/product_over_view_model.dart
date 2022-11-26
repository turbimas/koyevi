import 'package:flutter/material.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/product/models/product_detail_model.dart';

class ProductOverViewModel {
  final int id;
  final String barcode;
  final String name;
  final String? tradeMark;
  double unitPrice;
  // int varyantId
  // String colorName
  // String beden
  final String aciklama;
  final String unitCode;
  final String? _thumbnail;
  double? basketQuantity;
  double basketFactor;
  final bool inSale;
  final bool canShipped;

  int _favoriteId;
  bool get isFavorite => _favoriteId > 0;
  set favoriteId(int id) {
    _favoriteId = id;
  }

  Map<String, dynamic>? _evaluationData;
  num get evaluationCount =>
      _evaluationData != null ? _evaluationData!["EvaluationsCount"] ?? 0 : 0;
  num get evaluationAverage =>
      _evaluationData != null ? _evaluationData!["EvaluationsAvg"] ?? 0 : 0;

  Widget image({required double height, required double width}) {
    if (_thumbnail != null) {
      if (_thumbnail!.isNotEmpty) {
        String url = _thumbnail!.replaceAll("\\", "/");
        return Image.network(
          url,
          height: height,
          width: width,
          fit: BoxFit.fill,
        );
      }
    }
    return CustomImages.image_not_found;
  }

  ProductOverViewModel.fromJson(Map<String, dynamic> json)
      : id = json["ID"],
        barcode = json["Barcode"],
        name = json["Name"],
        tradeMark = json["TradeMark"],
        unitPrice = json["UnitPrice"],
        aciklama = json["Aciklama"],
        unitCode = json["UnitCode"],
        _thumbnail = json["MainImageThumbUrl"],
        basketQuantity = json["BasketQty"],
        basketFactor = json["BasketFactor"],
        inSale = json["InSale"],
        canShipped = json["CanShipped"],
        _favoriteId = json["FavoriteID"],
        _evaluationData = json["Evaluation"];

  updateWithProductDetailModel(ProductDetailModel productDetail) {
    basketQuantity = productDetail.basketQuantity;
    _favoriteId = productDetail.favoriteId;
    _evaluationData = productDetail.evaluationData;
  }

  toJson() => {
        'ID': id,
        'Barcode': barcode,
        'Name': name,
        'TradeMark': tradeMark,
        'UnitPrice': unitPrice,
        'Aciklama': aciklama,
        'UnitCode': unitCode,
        'MainImageThumbUrl': _thumbnail,
        'BasketQty': basketQuantity,
        'BasketFactor': basketFactor,
        'FavoriteID': _favoriteId,
        'Evaluation': _evaluationData
      };

  @override
  toString() =>
      'ProductOverViewModel(id: $id, barcode: $barcode, name: $name, tradeMark: $tradeMark, unitPrice: $unitPrice, aciklama: $aciklama, unitCode: $unitCode, _thumbnail: $_thumbnail, basketQuantity: $basketQuantity, basketFactor: $basketFactor, _favoriteId: $_favoriteId, _evaluationData: $_evaluationData)';
}
