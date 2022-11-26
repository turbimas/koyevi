import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/product_detail_model.dart';

class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel();

  String statusMessage = "";

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int _imageIndex = 0;
  int get imageIndex => _imageIndex;
  set imageIndex(int value) {
    _imageIndex = value;
    _infoExpanded = false;
    notifyListeners();
  }

  int _selectedPropertyIndex = 0;
  int get selectedPropertyIndex => _selectedPropertyIndex;
  set selectedPropertyIndex(int value) {
    _selectedPropertyIndex = value;
    _infoExpanded = false;
    notifyListeners();
  }

  bool _infoExpanded = false;
  bool get infoExpanded => _infoExpanded;
  set infoExpanded(bool value) {
    _infoExpanded = value;
    notifyListeners();
  }

  ProductDetailModel? productDetail;

  Future<void> getProductDetail(String barcode) async {
    try {
      isLoading = true;
      ResponseModelMap<String, dynamic> responseModel =
          await NetworkService.get<Map<String, dynamic>>(
              "products/productdetail/${AuthService.currentUser!.id}/$barcode");
      if (responseModel.success) {
        productDetail = ProductDetailModel.fromJson(responseModel.data!);
        statusMessage = LocaleKeys.ProductDetail_add_to_basket;
        if (!productDetail!.canShipped) {
          statusMessage = LocaleKeys.ProductDetail_cant_shipped;
        }
        if (!productDetail!.inSale) {
          statusMessage = LocaleKeys.ProductDetail_not_in_sale;
        }
      } else {
        PopupHelper.showErrorDialog(errorMessage: responseModel.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> addBasket() async {
    try {
      productDetail!.addBasket();
      notifyListeners();
      ResponseModel response =
          await NetworkService.post("orders/addbasket", body: {
        "CariID": AuthService.currentUser!.id,
        "Barcode": productDetail!.barcode,
        "Quantity": productDetail!.basketFactor
      });

      if (!response.success) {
        productDetail!.removeBasket();
        notifyListeners();

        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      productDetail!.removeBasket();
      notifyListeners();
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> updateBasket() async {
    try {
      productDetail!.removeBasket();
      notifyListeners();
      ResponseModel response =
          await NetworkService.post("orders/updatebasket", body: {
        "CariID": AuthService.currentUser!.id,
        "Barcode": productDetail!.barcode,
        "Quantity": productDetail!.basketQuantity ?? 0
      });
      if (!response.success) {
        productDetail!.addBasket();
        notifyListeners();
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      productDetail!.addBasket();
      notifyListeners();
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> favoriteUpdate() async {
    try {
      ResponseModel response = await NetworkService.get(
          "products/favoriteupdate/${AuthService.currentUser!.id}/${productDetail!.barcode}");
      if (response.success) {
        productDetail!.isFavorite = !productDetail!.isFavorite;
        PopupHelper.showSuccessToast(productDetail!.isFavorite
            ? "Ürün favorilere eklendi"
            : "Ürün favorilerden çıkarıldı");
        notifyListeners();
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
