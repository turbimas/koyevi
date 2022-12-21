import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/order/basket_model.dart';

part 'basket_model_state.dart';

class BasketModelCubit extends Cubit<BasketModelState> {
  BasketModelCubit() : super(const BasketModelState());

  Future<void> refresh() async {
    if (!AuthService.isLoggedIn) {
      return;
    }
    ResponseModel basketData =
        await NetworkService.get("orders/getbasket/${AuthService.id}");
    if (basketData.success) {
      BasketModel basketModel = BasketModel.fromJson(basketData.data!);
      emit(BasketModelState(basketModel));
    } else {
      PopupHelper.showErrorDialog(errorMessage: basketData.errorMessage!);
    }
  }
}
