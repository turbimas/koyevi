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
import 'package:koyevi/product/cubits/basket_model_cubit/basket_model_cubit.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/product/models/order/basket_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/view/order/basket_detail/basket_detail_view.dart';
import 'package:koyevi/view/user/user_addresses/user_addresses_view.dart';

class BasketViewModel extends ChangeNotifier {
  BasketViewModel();

  BasketModel? basketModel;

  ProductOverViewModel? delivery;
  List<ProductOverViewModel> filteredProducts = [];
  List<ProductOverViewModel>? products;

  bool _retrieving = false;
  bool get retrieving => _retrieving;
  set retrieving(bool value) {
    _retrieving = value;
    notifyListeners();
  }

  Future<void> getBasket() async {
    try {
      retrieving = true;
      ResponseModel basketDetails =
          await NetworkService.get("orders/getbasket/${AuthService.id}");
      if (basketDetails.success) {
        filteredProducts.clear();
        products?.clear();
        basketModel = BasketModel.fromJson(basketDetails.data);
        filteredProducts
            .addAll(basketModel!.basketDetails.map((e) => e.product));
        products = filteredProducts.cast();
      } else {
        PopupHelper.showErrorDialog(errorMessage: basketDetails.errorMessage!);
      }
    } catch (e) {
      products = null;
      filteredProducts.clear();
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      retrieving = false;
    }
  }

  Future<void> goBasketDetail() async {
    try {
      if (basketModel!.generalTotals < basketModel!.minDeliveryTotals) {
        PopupHelper.showErrorDialog(
            errorMessage: LocaleKeys.Basket_cannot_lower_than.tr(
                args: [basketModel!.minDeliveryTotals.toStringAsFixed(2)]),
            actions: {
              LocaleKeys.Basket_continue_shopping.tr(): () {
                NavigationService.context.read<HomeIndexCubit>().set(2);
                NavigationService.back();
              }
            });
        return;
      }

      ResponseModel response =
          await NetworkService.get("users/adresses/${AuthService.id}");
      if (response.success) {
        List<AddressModel> addresses = (response.data as List)
            .map((e) => AddressModel.fromJson(e))
            .toList();
        if (addresses.isNotEmpty) {
          NavigationService.navigateToPage(BasketDetailView(
                  basketModel: basketModel!, addresses: addresses))
              .then((value) {
            getBasket();
          });
        } else {
          PopupHelper.showErrorDialog(
              errorMessage: LocaleKeys.Basket_address_not_found.tr(),
              actions: {
                LocaleKeys.Basket_add_address_now.tr(): () {
                  NavigationService.back().then((value) {
                    NavigationService.navigateToPage(const UserAddressesView());
                  });
                }
              });
        }
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  void searchOnBasket(String value) {
    filteredProducts.clear();
    if (value.isNotEmpty) {
      filteredProducts = products!
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      filteredProducts.addAll(products!);
    }
    notifyListeners();
  }

  Future<void> clearAll() async {
    retrieving = true;
    try {
      ResponseModel response =
          await NetworkService.get("orders/clearbasket/${AuthService.id}");
      if (response.success) {
        products!.clear();
        filteredProducts.clear();
        NavigationService.context.read<BasketModelCubit>().refresh();
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      retrieving = false;
    }
  }
}
