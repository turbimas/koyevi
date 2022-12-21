import 'package:koyevi/product/models/product_over_view_model.dart';

class BasketLineModel {
  late ProductOverViewModel product;
  late int id;
  late double quantity;
  late DateTime date;
  late double lineTotal;

  BasketLineModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        quantity = json['Quantity'],
        date = DateTime.parse(json['Date']),
        lineTotal = json['LineTotal'],
        product = ProductOverViewModel.fromJson(json['Product']);

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Quantity': quantity,
      'Date': date.toIso8601String(),
      'LineTotal': lineTotal,
      'Product': product.toJson(),
    };
  }
}
