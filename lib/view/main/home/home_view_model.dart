import 'dart:developer';

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

  List<CategoryModel>? categories;
  List<HomeBannerModel>? banners;
  AddressModel? address;
  HomeViewModel();

  Future<void> getHomeData() async {
    try {
      homeLoading = true;
      ResponseModelList categoriesResponse =
          await NetworkService.get<List>("categories/getcategories/0");

      ResponseModelList bannersResponse = await NetworkService.get(
          "main/homeviews/${AuthService.currentUser!.id}");

      ResponseModel addressesResponse = await NetworkService.get(
          "users/adresses/${AuthService.currentUser!.id}");

      // TODO : UserOrders çekilip ana ekrana eklenicek

      if (categoriesResponse.success &&
          bannersResponse.success &&
          addressesResponse.success) {
        categories = (categoriesResponse.data)!
            .map((e) => CategoryModel.fromJson(e))
            .toList();
        banners = (bannersResponse.data!)
            .map((e) => HomeBannerModel.fromJson(e))
            .toList();
        Map<String, dynamic>? addressData = (addressesResponse.data as List)
            .firstWhere((element) => element["isDefault"] == true,
                orElse: () => null);
        if (addressData != null) {
          address = AddressModel.fromJson(addressData);
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
}
