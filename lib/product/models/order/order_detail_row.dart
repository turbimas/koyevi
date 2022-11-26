// ignore_for_file: avoid_renaming_method_parameters, hash_and_equals

import 'package:koyevi/product/models/product_over_view_model.dart';

class OrderLinesModel {
  late int id;
  late String lineStatusName;
  late ProductOverViewModel product;
  late double amount;
  late double unitPrice;
  late double total;
  late String? notes;
  late bool voidable;
  late bool refundable;

  OrderLinesModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    lineStatusName = json['LineStatusName'];
    product = ProductOverViewModel.fromJson(json['Product']);
    amount = json['Amount'];
    unitPrice = json['UnitPrice'];
    total = json['Total'];
    notes = json['Notes'];
    voidable = json['Voidable'];
    refundable = json['Refundable'];

    product.unitPrice = unitPrice;
  }

  @override
  operator ==(o) => o is OrderLinesModel && o.id == id;
}
