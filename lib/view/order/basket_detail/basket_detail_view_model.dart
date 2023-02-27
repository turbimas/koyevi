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
import 'package:koyevi/product/models/order/basket_payment_type_model.dart';
import 'package:koyevi/product/models/order/promotion_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/product/models/user/delivery_time_model.dart';
import 'package:koyevi/view/order/online_payment/online_payment_view.dart';
import 'package:koyevi/view/order/order_success/order_success_view.dart';

class BasketDetailViewModel extends ChangeNotifier {
  late DateTime pageCreatedTime;

  List<BasketPaymentTypeModel> paymentTypes = [];
  BasketPaymentTypeModel? _selectedPaymentType;

  BasketModel basketModel;
  List<PromotionModel> promotions = [];
  List<AddressModel> addresses;
  List<DeliveryTimeModel>? times;

  bool _isLoading = false;

  DeliveryTimeModel? _selectedDeliveryTimeModel;

  String? selectedHour;
  String? selectedDate;

  late AddressModel _selectedDeliveryAddress;
  late AddressModel _selectedTaxAddress;

  TextEditingController noteController = TextEditingController();
  BasketDetailViewModel({required this.basketModel, required this.addresses}) {
    _selectedDeliveryAddress = addresses.first;
    _selectedTaxAddress = addresses.first;
    pageCreatedTime = DateTime.now();
  }

  // bool get _hemenTeslimAlSelected => _selectedDeliveryTime.dates.length == 1;

  // getter setters

  BasketPaymentTypeModel get selectedPaymentType => _selectedPaymentType!;
  set selectedPaymentType(BasketPaymentTypeModel value) {
    _selectedPaymentType = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  DeliveryTimeModel get selectedDeliveryTimeModel =>
      _selectedDeliveryTimeModel!;
  set selectedDeliveryTimeModel(DeliveryTimeModel value) {
    _selectedDeliveryTimeModel = value;
    notifyListeners();
  }

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

  AddressModel get selectedDeliveryAddress => _selectedDeliveryAddress;
  set selectedDeliveryAddress(AddressModel value) {
    _selectedDeliveryAddress = value;
    if (deliveryTaxSame) {
      _selectedTaxAddress = value;
    }
    notifyListeners();
  }

  AddressModel get selectedTaxAddress => _selectedTaxAddress;
  set selectedTaxAddress(AddressModel value) {
    _selectedTaxAddress = value;
    notifyListeners();
  }

  Future<void> getData() async {
    try {
      isLoading = true;
      ResponseModelMap<dynamic> basketModelData =
          await NetworkService.get("orders/getbasket/${AuthService.id}");
      ResponseModelList timeResponse =
          await NetworkService.get("orders/deliverySummary/${AuthService.id}");
      ResponseModelList addressResponse =
          await NetworkService.get("users/adresses/${AuthService.id}");
      ResponseModelList promotionResponse = await NetworkService.get(
          "orders/getapplicablepromotions/${AuthService.id}");
      ResponseModelList paymentTypeResponse =
          await NetworkService.get("orders/PaymentSummary/${AuthService.id}");

      if (timeResponse.success &&
          addressResponse.success &&
          promotionResponse.success &&
          basketModelData.success &&
          paymentTypeResponse.success) {
        basketModel.reFillFromJson(basketModelData.data!);
        times = timeResponse.data!
            .map<DeliveryTimeModel>((e) => DeliveryTimeModel.fromJson(e))
            .toList();
        addresses = addressResponse.data!
            .map<AddressModel>((e) => AddressModel.fromJson(e))
            .toList();

        for (DeliveryTimeModel time in times!) {
          if (time.dates.length > 1) {
            selectedDate = time.dates.first.dayDateTime;
            selectedHour = time.dates.first.hours.first;
          }
        }
        promotions = promotionResponse.data!
            .map<PromotionModel>((e) => PromotionModel.fromJson(e))
            .toList();

        paymentTypes = paymentTypeResponse.data!
            .map<BasketPaymentTypeModel>(
                (e) => BasketPaymentTypeModel.fromJson(e))
            .toList();

        // first values init
        _selectedDeliveryTimeModel ??= times!.first;
        _selectedPaymentType ??= paymentTypes.first;
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

      ResponseModel createOrderResponse =
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
        },
        "PaymentType": selectedPaymentType.code,
      });
      if (createOrderResponse.success) {
        if (selectedPaymentType.code == 3) {
          // online credit card
          ResponseModel<String> paymentUrlResponse =
              await NetworkService.get("orders/getpaymenturl");
          String paymentUrl =
              paymentUrlResponse.data! + createOrderResponse.data!;
          NavigationService.navigateToPage<bool>(OnlinePaymentView(
                  initialUrl: paymentUrl, guid: createOrderResponse.data))
              .then((value) {
            if (value == true) {
              NavigationService.navigateToPageAndRemoveUntil(
                  OrderSuccessView(orderId: createOrderResponse.data));
              NavigationService.context.read<BasketModelCubit>().refresh();
            } else {
              PopupHelper.showErrorToast(
                  LocaleKeys.BasketDetail_payment_unsuccessful.tr(),
                  long: true);
            }
          });
        } else {
          NavigationService.navigateToPageAndRemoveUntil(
              OrderSuccessView(orderId: createOrderResponse.data));
          NavigationService.context.read<BasketModelCubit>().refresh();
        }
      } else {
        await PopupHelper.showErrorDialog(
            errorMessage: createOrderResponse.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
