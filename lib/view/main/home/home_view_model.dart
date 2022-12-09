import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/category_model.dart';
import 'package:koyevi/product/models/home_banner_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';

class HomeViewModel extends ChangeNotifier {
  bool _homeLoading = true;
  bool get homeLoading => _homeLoading;
  set homeLoading(bool value) {
    _homeLoading = value;
    notifyListeners();
  }

  List<CategoryModel> categories = [];
  List<HomeBannerModel> banners = [];
  List<AddressModel> addresses = [];
  AddressModel? defaultAddress;
  HomeViewModel();

  Future<void> getHomeData() async {
    try {
      homeLoading = true;
      ResponseModelList categoriesResponse =
          await NetworkService.get<List>("categories/getcategories/0");

      ResponseModelList bannersResponse =
          await NetworkService.get("main/homeviews/${AuthService.id}");

      ResponseModelList addressesResponse =
          await NetworkService.get("users/adresses/${AuthService.id}");

      // TODO : UserOrders çekilip ana ekrana eklenicek

      if (categoriesResponse.success &&
          bannersResponse.success &&
          addressesResponse.success) {
        categories.clear();
        banners.clear();
        addresses.clear();
        categories.addAll((categoriesResponse.data)!
            .map((e) => CategoryModel.fromJson(e))
            .toList());
        banners.addAll((bannersResponse.data!)
            .map((e) => HomeBannerModel.fromJson(e))
            .toList());
        addresses.addAll((addressesResponse.data!)
            .map((e) => AddressModel.fromJson(e))
            .toList());
        if (addresses.isNotEmpty) {
          defaultAddress = addresses.firstWhere((element) => element.isDefault);
        }
      } else {
        PopupHelper.showErrorDialog(
            errorMessage: "İnternet bağlatınızı kontrol ediniz.");
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      homeLoading = false;
    }
  }

  Future<void> setDefaultAddress(int id) async {
    try {
      ResponseModel response =
          await NetworkService.get("users/AdressSetDefault/$id");
      if (response.success) {
        defaultAddress = addresses.firstWhere((element) => element.id == id);
      } else {
        PopupHelper.showErrorToast(response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      notifyListeners();
    }
  }
}
