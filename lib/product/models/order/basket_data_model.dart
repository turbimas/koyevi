import 'package:koyevi/product/models/product_over_view_model.dart';

class BasketDataModel {
  late ProductOverViewModel product;
  late int id;
  late double quantity;
  late DateTime date;
  late double lineTotal;

  BasketDataModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        quantity = json['Quantity'],
        date = DateTime.parse(json['Date']),
        lineTotal = json['LineTotal'],
        product = ProductOverViewModel.fromJson(json['Product']);
}
