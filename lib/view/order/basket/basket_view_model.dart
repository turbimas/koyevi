import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/order/basket_data_model.dart';
import 'package:koyevi/product/models/order/basket_total_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/view/order/basket_detail/basket_detail_view.dart';
import 'package:koyevi/view/user/user_address_add/user_address_add_view.dart';

class BasketViewModel extends ChangeNotifier {
  BasketViewModel();

  List<ProductOverViewModel> products = [];
  List<ProductOverViewModel> filteredProducts = [];

  BasketTotalModel? basketTotal;

  ProductOverViewModel? delivery;

  bool _retrieving = false;
  bool get retrieving => _retrieving;
  set retrieving(bool value) {
    _retrieving = value;
    notifyListeners();
  }

  Future<void> getBasket() async {
    retrieving = true;
    filteredProducts.clear();
    try {
      ResponseModelList basketResponse = await NetworkService.get<List>(
          "orders/getbasket/${AuthService.currentUser!.id}");
      ResponseModel totalResponse = await NetworkService.get(
          "orders/calculatetotals/${AuthService.currentUser!.id}");

      if (basketResponse.success && totalResponse.success) {
        products = basketResponse.data!
            .map((e) => BasketDataModel.fromJson(e).product)
            .toList()
            .where((element) => element.barcode != "DELIVERY")
            .map((e) => e)
            .toList();
        filteredProducts.addAll(products);

        basketTotal = BasketTotalModel.fromJson(totalResponse.data);
      } else {
        if (!totalResponse.success) {
          PopupHelper.showErrorDialog(
              errorMessage: totalResponse.errorMessage!);
        }
        if (!basketResponse.success) {
          PopupHelper.showErrorDialog(
              errorMessage: basketResponse.errorMessage!);
        }
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      retrieving = false;
    }
  }

  Future<void> goBasketDetail() async {
    try {
      ResponseModel response = await NetworkService.get(
          "users/adresses/${AuthService.currentUser!.id}");
      if (response.success) {
        List<AddressModel> addresses = (response.data as List)
            .map((e) => AddressModel.fromJson(e))
            .toList();
        if (addresses.isNotEmpty) {
          NavigationService.navigateToPage(BasketDetailView(
              basketTotal: basketTotal!, addresses: addresses));
        } else {
          PopupHelper
              .showErrorDialog(errorMessage: "Adres bulunamadı", actions: {
            "Hemen adres ekle!": () {
              NavigationService.back().then((value) {
                NavigationService.navigateToPage(const UserAddressAddView());
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
      filteredProducts = products
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      filteredProducts.addAll(products);
    }
    notifyListeners();
  }

  Future<void> clearAll(BuildContext context) async {
    await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: CustomColors.primary,
            title: CustomText(
              "Sepeti Temizle",
              style: CustomFonts.bodyText1(CustomColors.primaryText),
            ),
            content: CustomText("Sepeti temizlemek istediğinize emin misiniz?",
                maxLines: 2,
                style: CustomFonts.bodyText4(CustomColors.primaryText)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: CustomText("Hayır",
                      style: CustomFonts.bodyText2(CustomColors.primaryText))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: CustomText("Evet",
                      style: CustomFonts.bodyText2(CustomColors.primaryText))),
            ],
          );
        }).then((value) async {
      if (value == true) {
        retrieving = true;
        try {
          ResponseModel response = await NetworkService.get(
              "orders/clearbasket/${AuthService.currentUser!.id}");
          if (response.success) {
            products.clear();
            filteredProducts.clear();
            basketTotal = null;
          } else {
            PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
          }
        } catch (e) {
          PopupHelper.showErrorDialogWithCode(e);
        } finally {
          retrieving = false;
        }
      }
    });
  }
}
