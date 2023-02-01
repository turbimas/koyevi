class PromotionModel {
  int promotionID;
  String promotionDescription;
  String? imageUrl;
  List barcodes;

  PromotionModel(
      {required this.promotionID,
      required this.promotionDescription,
      this.imageUrl,
      required this.barcodes});

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
        promotionID: json['PromotionID'],
        promotionDescription: json['PromotionDescription'],
        imageUrl: json['ImageUrl'],
        barcodes: json['Barcodes']);
  }

  Map<String, dynamic> toJson() {
    return {
      'PromotionID': promotionID,
      'PromotionDescription': promotionDescription,
      'imageUrl': imageUrl,
      'Barcodes': barcodes
    };
  }
}
