import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/order/basket_total_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/product/models/user/delivery_time_model.dart';
import 'package:koyevi/view/order/order_success/order_success_view.dart';

class BasketDetailViewModel extends ChangeNotifier {
  BasketTotalModel basketTotal;
  TextEditingController noteController = TextEditingController();
  BasketDetailViewModel({required this.basketTotal, required this.addresses}) {
    _selectedDeliveryAddress = addresses.first;
    _selectedTaxAddress = addresses.first;
    pageCreatedTime = DateTime.now();
  }

  // bool get _hemenTeslimAlSelected => _selectedDeliveryTime.dates.length == 1;

  late DateTime pageCreatedTime;

  bool _hemenTeslimAl = true;
  bool get hemenTeslimAl => _hemenTeslimAl;
  set hemenTeslimAl(bool value) {
    _hemenTeslimAl = value;
    notifyListeners();
  }

  String? selectedHour;
  String? selectedDate;

  bool _deliveryTaxSame = true;
  bool get deliveryTaxSame => _deliveryTaxSame;
  set deliveryTaxSame(bool value) {
    _deliveryTaxSame = value;
    notifyListeners();
  }

  bool _acceptTerms = false;
  bool get acceptTerms => _acceptTerms;
  set acceptTerms(bool value) {
    _acceptTerms = value;
    notifyListeners();
  }

  bool _paymentTypeTerms = false;
  bool get paymentTypeTerms => _paymentTypeTerms;
  set paymentTypeTerms(bool value) {
    _paymentTypeTerms = value;
    notifyListeners();
  }

  bool _ringBell = false;
  bool get doNotRingBell => _ringBell;
  set doNotRingBell(bool value) {
    _ringBell = value;
    notifyListeners();
  }

  bool _contactlessDelivery = false;
  bool get contactlessDelivery => _contactlessDelivery;
  set contactlessDelivery(bool value) {
    _contactlessDelivery = value;
    notifyListeners();
  }

  List<AddressModel> addresses;
  List<DeliveryTimeModel>? times;

  late AddressModel _selectedDeliveryAddress;
  AddressModel get selectedDeliveryAddress => _selectedDeliveryAddress;
  set selectedDeliveryAddress(AddressModel value) {
    _selectedDeliveryAddress = value;
    if (deliveryTaxSame) {
      _selectedTaxAddress = value;
    }
    notifyListeners();
  }

  late AddressModel _selectedTaxAddress;
  AddressModel get selectedTaxAddress => _selectedTaxAddress;
  set selectedTaxAddress(AddressModel value) {
    _selectedTaxAddress = value;
    notifyListeners();
  }

  Future<void> createOrder() async {
    try {
      if (!acceptTerms) {
        await PopupHelper.showErrorDialog(
            errorMessage:
                "Sipariş oluşturabilmek için sipariş koşullarını kabul etmelisiniz");
        return;
      }
/*
      if (!paymentTypeTerms) {
        await PopupHelper.showErrorDialog(
            errorMessage:
                "Sipariş oluşturabilmek için teslimat tarihi belirleyin.");
        return;
      }
*/
      List<String> orderNotes = [];
      if (noteController.text.isNotEmpty) {
        orderNotes.add(noteController.text);
      }

      if (doNotRingBell) {
        orderNotes.add("Zili Çalma");
      }
      if (contactlessDelivery) {
        orderNotes.add("Temasız Teslimat");
      }

      ResponseModel response =
          await NetworkService.post("orders/createorder", body: {
        "CariID": AuthService.currentUser!.id,
        "DeliveryAdressID": selectedDeliveryAddress.id,
        "InvoiceAdressID": deliveryTaxSame
            ? selectedDeliveryAddress.id
            : selectedTaxAddress.id,
        "OrderNotes": orderNotes.isEmpty ? "" : orderNotes.join("\n"),
        "DeliveryOverTime": {
          "Hour": selectedHour,
          "Date": selectedDate,
          "overTime": DateTime.now().difference(pageCreatedTime).inSeconds
        }
      });
      if (response.success) {
        NavigationService.navigateToPage(
            OrderSuccessView(orderId: response.data));
      } else {
        await PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getData() async {
    try {
      isLoading = true;
      ResponseModel timeResponse =
          await NetworkService.post("orders/deliverySummary", body: {
        "lat": selectedDeliveryAddress.lat,
        "lng": selectedDeliveryAddress.lng,
      });
      ResponseModel addressResponse = await NetworkService.get(
          "users/adresses/${AuthService.currentUser!.id}");
      if (timeResponse.success && addressResponse.success) {
        isLoading = false;
        times = timeResponse.data
            .map<DeliveryTimeModel>((e) => DeliveryTimeModel.fromJson(e))
            .toList();
        addresses = addressResponse.data
            .map<AddressModel>((e) => AddressModel.fromJson(e))
            .toList();
        selectedDate = times!.first.dates.first.dayDateTime;
        selectedHour = times!.first.dates.first.hours.first;
      } else {
        PopupHelper.showErrorDialog(errorMessage: timeResponse.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }
}
