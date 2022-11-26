import 'package:koyevi/product/models/product_over_view_model.dart';

class LastViewedModel {
  int id;
  DateTime date;
  ProductOverViewModel product;

  LastViewedModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        date = DateTime.parse(json['Date']),
        product = ProductOverViewModel.fromJson(json['Product']);
}
