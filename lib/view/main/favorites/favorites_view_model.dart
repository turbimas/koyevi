import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';

class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel();

  List<ProductOverViewModel>? products;
  List<ProductOverViewModel> filteredProducts = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getFavorites() async {
    try {
      isLoading = true;
      ResponseModel response = await NetworkService.get(
          "users/favorites/${AuthService.currentUser!.id}");
      if (response.success) {
        products = (response.data as List)
            .map((e) => ProductOverViewModel.fromJson(e))
            .toList();
        filteredProducts.clear();
        filteredProducts.addAll(products!);
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> onChanged(String value) async {
    filteredProducts.clear();
    if (value.isEmpty) {
      filteredProducts.addAll(products!);
    } else {
      filteredProducts.addAll(products!
          .where((element) => element.name.toLowerCase().contains(value)));
    }
    notifyListeners();
  }
}
