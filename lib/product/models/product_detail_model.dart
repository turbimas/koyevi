class ProductDetailModel {
  final int id;
  final String barcode;
  final String name;
  final String? tradeMark;
  final double unitPrice;
  final List<ProductPropertyModel> productNutritiveValue;
  final ProductPropertyModel productDetails;
  // final int varyantId;
  // final String colorName;
  // final String beden;
  // final double miktar;
  final String aciklama; // ürün ismi + açıklama
  final String unitCode;

  double? basketQuantity;

  double basketFactor;
  final bool inSale;
  final bool canShipped;

  int favoriteId; // 0 ise favori değil, 0> ise favori buna göre getter oluşturulacak
  bool get isFavorite => favoriteId > 0;
  set isFavorite(bool value) {
    favoriteId = value ? 1 : 0;
  }

  final Map<String, dynamic>? evaluationData;
  num get evaluationCount =>
      evaluationData != null ? evaluationData!["EvaluationsCount"] ?? 0 : 0;
  num get evaluationAverage =>
      evaluationData != null ? evaluationData!["EvaluationsAvg"] ?? 0 : 0;

  final List<String> _images;
  final List<String> _thumbNails;
  List<String> get images =>
      _images.map((e) => e.replaceAll("\\", "/")).toList();
  List<String> get thumbNails =>
      _thumbNails.map((e) => e.replaceAll("\\", "/")).toList();

  ProductDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        barcode = json['Barcode'],
        name = json['Name'],
        tradeMark = json['TradeMark'],
        unitPrice = json['UnitPrice'],
        productNutritiveValue = (json['ProductNutritiveValue'] as List)
            .map((e) => ProductPropertyModel.fromJson(e))
            .toList(),
        productDetails = (json['ProductDetails'] as List)
            .map((e) => ProductPropertyModel.fromJson(e))
            .first,
        // varyantId = json['VaryantID'],
        // colorName = json['ColorName'],
        // beden = json['Beden'],
        // miktar = json['Miktar'],
        aciklama = json['Aciklama'],
        unitCode = json['UnitCode'],
        basketQuantity = json['BasketQty'],
        basketFactor = json['BasketFactor'],
        inSale = json['InSale'],
        canShipped = json['CanShipped'],
        favoriteId = json['FavoriteID'],
        evaluationData = json['Evaluation'],
        _images = json['Images'].cast<String>(),
        _thumbNails = json['Thumbnails'].cast<String>();

  addBasket() {
    basketQuantity =
        (basketQuantity ?? 0).toPrecision(2) + basketFactor.toPrecision(2);
  }

  removeBasket() {
    basketQuantity =
        basketQuantity!.toPrecision(2) - basketFactor.toPrecision(2);
    if (basketQuantity! <= 0) {
      basketQuantity = null;
    }
  }

  toJson() {
    return {
      'ID': id,
      'Barcode': barcode,
      'Name': name,
      'TradeMark': tradeMark,
      'UnitPrice': unitPrice,
      // 'VaryantID': varyantId,
      // 'ColorName': colorName,
      // 'Beden': beden,
      // 'Miktar': miktar,
      'Aciklama': aciklama,
      'UnitCode': unitCode,
      'BasketQty': basketQuantity,
      'BasketFactor': basketFactor,
      'InSale': inSale,
      'CanShipped': canShipped,
      'FavoriteID': favoriteId,
      'Evaluation': evaluationData,
      'Images': images,
      'Thumbnails': thumbNails,
    };
  }
}

class ProductPropertyModel {
  String itemProperty;
  num value;
  num forValue;

  ProductPropertyModel.fromJson(Map<String, dynamic> json)
      : itemProperty = json['ItemProperty'],
        value = json['Value'],
        forValue = json['ForValue'];
}

extension doubleExtention on double {
  double toPrecision(int fractionDigits) {
    return double.parse(this.toStringAsPrecision(fractionDigits));
  }
}
