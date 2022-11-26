import 'package:koyevi/product/models/product_over_view_model.dart';

class UserRatingModel {
  int id;
  ProductOverViewModel product;
  num ratingValue;
  String? contentValue;
  DateTime date;

  UserRatingModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        product = ProductOverViewModel.fromJson(json['Product']),
        ratingValue = json['RatingValue'],
        contentValue = json['ContentValue'],
        date = DateTime.parse(json['Date']);
}
