// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/product/models/product_detail_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';
import 'package:koyevi/view/main/search_result/search_result_view.dart';

import '../../../product/cubits/basket_model_cubit/basket_model_cubit.dart';

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
      ResponseModelMap<dynamic> responseModel =
          await NetworkService.get<Map<String, dynamic>>(
              "products/productdetail/${AuthService.id}/$barcode");
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
    if (!AuthService.isLoggedIn) {
      PopupHelper.showErrorToast(LocaleKeys.ProductDetail_login_to_use.tr());
      return;
    }

    try {
      productDetail!.addBasket();
      notifyListeners();
      ResponseModel response =
          await NetworkService.post("orders/addbasket", body: {
        "CariID": AuthService.id,
        "Barcode": productDetail!.barcode,
        "Quantity": productDetail!.basketFactor
      });

      if (!response.success) {
        productDetail!.removeBasket();
        notifyListeners();
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      } else {
        NavigationService.context.read<BasketModelCubit>().refresh();
      }
    } catch (e) {
      productDetail!.removeBasket();
      notifyListeners();
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> updateBasket() async {
    if (!AuthService.isLoggedIn) {
      PopupHelper.showErrorToast(LocaleKeys.ProductDetail_login_to_use.tr());
      return;
    }
    try {
      productDetail!.removeBasket();
      notifyListeners();
      ResponseModel response =
          await NetworkService.post("orders/updatebasket", body: {
        "CariID": AuthService.id,
        "Barcode": productDetail!.barcode,
        "Quantity": productDetail!.basketQuantity ?? 0
      });

      if (!response.success) {
        productDetail!.addBasket();
        notifyListeners();
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      } else {
        NavigationService.context.read<BasketModelCubit>().refresh();
      }
    } catch (e) {
      productDetail!.addBasket();
      notifyListeners();
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> favoriteUpdate() async {
    try {
      if (!AuthService.isLoggedIn) {
        PopupHelper.showErrorToast(LocaleKeys.ProductDetail_login_to_use.tr());
        return;
      }
      ResponseModel response = await NetworkService.get(
          "products/favoriteupdate/${AuthService.id}/${productDetail!.barcode}");
      if (response.success) {
        productDetail!.isFavorite = !productDetail!.isFavorite;
        PopupHelper.showSuccessToast(productDetail!.isFavorite
            ? LocaleKeys.ProductDetail_product_added_favorites.tr()
            : LocaleKeys.ProductDetail_product_removed_favorites.tr());
        notifyListeners();
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> masterCategoryNavigate(int id) async {
    if (id == 0) {
      NavigationService.navigateToPageAndRemoveUntil(const MainView());
      NavigationService.context.read<HomeIndexCubit>().set(2);
      return;
    }
    ResponseModelList response = await NetworkService.get(
        "categories/getCategoryMembers/${AuthService.id}/$id");
    if (response.success) {
      List<ProductOverViewModel> products = response.data!.map((e) {
        return ProductOverViewModel.fromJson(e["Product"]);
      }).toList();
      NavigationService.navigateToPage(
          SearchResultView(isSearch: false, products: products));
    } else {
      PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
    }
  }
}
