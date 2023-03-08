import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/category_model.dart';
import 'package:koyevi/product/models/home_banner_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/product/models/user/user_orders_model.dart';

class HomeViewModel extends ChangeNotifier {
  Future<void> ensureLocation() async {
    LocationPermission locationPermission = await _askLocationService();
    log("location permission: $locationPermission");
    while (locationPermission == LocationPermission.denied) {
      locationPermission = await _askLocationService();
      log("waiting for location service");
    }
    Future.delayed(const Duration(seconds: 1), () {
      if (locationPermission == LocationPermission.deniedForever) {
        PopupHelper.showErrorDialog(
            errorMessage: LocaleKeys.Home_location_denied.tr(),
            actions: {
              LocaleKeys.Home_open_location_settings.tr(): () {
                Geolocator.openLocationSettings();
              },
              LocaleKeys.Home_open_app_settings.tr(): () {
                Geolocator.openAppSettings();
              }
            }).then((value) {
          _askLocationService();
        });
      }
    });
  }

  Future<LocationPermission> _askLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermission.denied;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermission.denied;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return LocationPermission.deniedForever;
    }
    return LocationPermission.whileInUse;
  }

  bool _homeLoading = true;
  bool get homeLoading => _homeLoading;
  set homeLoading(bool value) {
    _homeLoading = value;
    notifyListeners();
  }

  List<CategoryModel> categories = [];
  List<HomeBannerModel> banners = [];
  List<AddressModel> addresses = [];
  List<UserOrdersModel> orders = [];
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

      if (AuthService.isLoggedIn) {
        ResponseModelList continuingOrders =
            await NetworkService.get("main/ContinuingOrders/${AuthService.id}");
        if (continuingOrders.success) {
          if (continuingOrders.data!.isNotEmpty) {
            orders.clear();
            orders.addAll((continuingOrders.data!)
                .map((e) => UserOrdersModel.fromJson(e))
                .toList());
          }
        } else {
          PopupHelper.showErrorDialogWithCode(continuingOrders.errorMessage!);
        }
      }

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
            errorMessage: LocaleKeys.Home_check_network_connection.tr());
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      homeLoading = false;
    }
  }

  Future<void> setDefaultAddress(int id) async {
    try {
      bool cont = await PopupHelper.showSuccessDialog<bool>(
          LocaleKeys.Home_address_change_warn.tr(),
          actions: {
            LocaleKeys.Home_continue.tr(): () {
              NavigationService.back(data: true);
            }
          },
          cancelIcon: true);
      if (!cont) {
        return;
      }
      ResponseModel response =
          await NetworkService.get("users/AdressSetDefault/$id");
      if (response.success) {
        defaultAddress = addresses.firstWhere((element) => element.id == id);
        getHomeData();
      } else {
        PopupHelper.showErrorToast(response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
