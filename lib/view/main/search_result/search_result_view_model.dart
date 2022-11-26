import 'package:flutter/material.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/product/models/category_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';

class SearchResultViewModel extends ChangeNotifier {
  CategoryModel? categoryModel;
  String? searchText;

  List<ProductOverViewModel> products = [];
  List<ProductOverViewModel> filteredProducts = [];

  bool? _orderName;
  bool? _orderPrice;

  bool? get orderName => _orderName;
  bool? get orderPrice => _orderPrice;

  num? filterMax;
  num? filterMin;
  Set<String> filterTradeMark = {};
  Set<String> filterUnitCode = {};

  late final num minPrice;
  late final num maxPrice;
  late final Set<String> tradeMarks;
  late final Set<String> unitCodes;

  set orderName(bool? value) {
    _orderName = value;
    _orderPrice = null;
    notifyListeners();
  }

  set orderPrice(bool? value) {
    _orderPrice = value;
    _orderName = null;
    notifyListeners();
  }

  void order() {
    if (orderName == true) {
      filteredProducts.sort((a, b) => a.name.compareTo(b.name));
    } else if (orderName == false) {
      filteredProducts.sort((a, b) => b.name.compareTo(a.name));
    }
    if (orderPrice == true) {
      filteredProducts.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
    } else if (orderPrice == false) {
      filteredProducts.sort((a, b) => b.unitPrice.compareTo(a.unitPrice));
    }
    NavigationService.back();
    notifyListeners();
  }

  void filter() {
    List<ProductOverViewModel> copy = filteredProducts.toList();
    filteredProducts.clear();
    for (var element in copy) {
      if (filterMax != null && filterMin != null) {
        if (element.unitPrice < filterMax! && element.unitPrice > filterMin!) {
          filteredProducts.add(element);
        }
        if (filterTradeMark.contains(element.tradeMark)) {
          filteredProducts.add(element);
        }
        if (filterUnitCode.contains(element.unitCode)) {
          filteredProducts.add(element);
        }
      }
    }
    filteredProducts.addAll(copy);
    copy.clear();
    notifyListeners();
  }

  SearchResultViewModel(
      {required this.products, this.categoryModel, this.searchText}) {
    if (products.isNotEmpty) {
      filteredProducts.addAll(products);
      List<num> prices = products.map<num>((e) => e.unitPrice).toList();
      prices.sort((a, b) => a.compareTo(b));
      minPrice = prices.first;
      maxPrice = prices.last;

      tradeMarks = {};
      for (var element in products) {
        if (element.tradeMark != null) {
          tradeMarks.add(element.tradeMark!);
        }
      }

      unitCodes = {};
      for (var element in products) {
        unitCodes.add(element.unitCode);
      }
    }
  }

  void filterByName(String name) {
    List<ProductOverViewModel> copy = products.toList();
    filteredProducts.clear();
    for (var element in copy) {
      if (element.name.toLowerCase().contains(name.toLowerCase())) {
        filteredProducts.remove(element);
        filteredProducts.add(element);
      }
    }
    notifyListeners();
  }
}
