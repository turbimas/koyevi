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
import 'package:koyevi/product/models/order/basket_model.dart';
import 'package:koyevi/product/models/order/promotion_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/product/models/user/delivery_time_model.dart';
import 'package:koyevi/view/order/order_success/order_success_view.dart';

class BasketDetailViewModel extends ChangeNotifier {
  BasketModel basketModel;
  List<PromotionModel> promotions = [];

  TextEditingController noteController = TextEditingController();
  BasketDetailViewModel({required this.basketModel, required this.addresses}) {
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
      if (basketModel.generalTotals < basketModel.minDeliveryTotals) {
        await PopupHelper.showErrorDialog(
            errorMessage: LocaleKeys.BasketDetail_cannot_lower_than.tr(
                args: [basketModel.minDeliveryTotals.toStringAsFixed(2)]),
            actions: {
              LocaleKeys.BasketDetail_continue_shopping.tr(): () {
                NavigationService.context.read<HomeIndexCubit>().set(2);
                NavigationService.back(times: 2);
              }
            },
            dismissible: false);
        return;
      }

      if (!acceptTerms) {
        await PopupHelper.showErrorDialog(
            errorMessage: LocaleKeys.BasketDetail_term_and_conditions.tr());
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
        "CariID": AuthService.id,
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
      ResponseModelMap<dynamic> basketModelData =
          await NetworkService.get("orders/getbasket/${AuthService.id}");
      ResponseModelList timeResponse =
          await NetworkService.post("orders/deliverySummary", body: {
        "lat": selectedDeliveryAddress.lat,
        "lng": selectedDeliveryAddress.lng,
      });
      ResponseModelList addressResponse =
          await NetworkService.get("users/adresses/${AuthService.id}");
      ResponseModelList promotionResponse = await NetworkService.get(
          "orders/getapplicablepromotions/${AuthService.id}");

      if (timeResponse.success &&
          addressResponse.success &&
          promotionResponse.success &&
          basketModelData.success) {
        basketModel.reFillFromJson(basketModelData.data!);
        times = timeResponse.data!
            .map<DeliveryTimeModel>((e) => DeliveryTimeModel.fromJson(e))
            .toList();
        addresses = addressResponse.data!
            .map<AddressModel>((e) => AddressModel.fromJson(e))
            .toList();
        selectedDate = times!.first.dates.first.dayDateTime;
        selectedHour = times!.first.dates.first.hours.first;
        promotions = promotionResponse.data!
            .map<PromotionModel>((e) => PromotionModel.fromJson(e))
            .toList();
      } else {
        if (timeResponse.success == false) {
          PopupHelper.showErrorDialog(errorMessage: timeResponse.errorMessage!);
        }
        if (addressResponse.success == false) {
          PopupHelper.showErrorDialog(
              errorMessage: addressResponse.errorMessage!);
        }
        if (promotionResponse.success == false) {
          PopupHelper.showErrorDialog(
              errorMessage: promotionResponse.errorMessage!);
        }
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }
}
