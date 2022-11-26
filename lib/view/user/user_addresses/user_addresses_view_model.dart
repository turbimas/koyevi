import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/user/address_model.dart';

class UserAddressesViewModel extends ChangeNotifier {
  UserAddressesViewModel();
  List<AddressModel>? addresses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getAddresses() async {
    try {
      isLoading = true;
      ResponseModel response = await NetworkService.get(
          "users/adresses/${AuthService.currentUser!.id}");
      if (response.success) {
        addresses = (response.data as List)
            .map((e) => AddressModel.fromJson(e))
            .toList();
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      isLoading = true;
      ResponseModel response =
          await NetworkService.get("users/deleteadress/$id");
      if (response.success) {
        addresses!.removeWhere((element) => element.id == id);
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }
}
