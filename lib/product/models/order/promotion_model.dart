class PromotionModel {
  int promotionID;
  String promotionDescription;
  String? imageUrl;

  PromotionModel({
    required this.promotionID,
    required this.promotionDescription,
    this.imageUrl,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      promotionID: json['PromotionID'],
      promotionDescription: json['PromotionDescription'],
      imageUrl: json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PromotionID': promotionID,
      'PromotionDescription': promotionDescription,
      'imageUrl': imageUrl,
    };
  }
}
