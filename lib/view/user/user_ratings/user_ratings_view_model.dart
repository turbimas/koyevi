import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/user_rating_model.dart';

class UserRatingsViewModel extends ChangeNotifier {
  List<UserRatingModel> rated = [];
  List<ProductOverViewModel> unrated = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int _index = 0;
  int get index => _index;
  set index(int value) {
    if (value != _index) {
      _index = value;
      notifyListeners();
    }
  }

  UserRatingsViewModel();

  Future<void> getData() async {
    try {
      isLoading = true;
      ResponseModel evaluatedResponse = await NetworkService.get(
          "users/evaluated/${AuthService.currentUser!.id}");

      ResponseModel nonEvaluatedResponse = await NetworkService.get(
          "users/non_evaluated/${AuthService.currentUser!.id}");

      if (evaluatedResponse.success && nonEvaluatedResponse.success) {
        rated = (evaluatedResponse.data as List)
            .map((e) => UserRatingModel.fromJson(e))
            .toList();

        unrated = (nonEvaluatedResponse.data as List)
            .map((e) => ProductOverViewModel.fromJson(e))
            .toList();
      } else {
        if (!evaluatedResponse.success) {
          PopupHelper.showErrorDialog(
              errorMessage: evaluatedResponse.errorMessage!);
        }
        if (!nonEvaluatedResponse.success) {
          PopupHelper.showErrorDialog(
              errorMessage: nonEvaluatedResponse.errorMessage!);
        }
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> addEvaluation(
      {required int rating,
      required String comment,
      required String barcode}) async {
    try {
      isLoading = true;
      Map<String, dynamic> data = {
        "Barcode": barcode,
        "CariID": AuthService.currentUser!.id,
        "RatingValue": rating
      };
      if (comment.isNotEmpty) {
        data["ContentValue"] = comment;
      }
      log(data.toString());
      ResponseModel response =
          await NetworkService.post("products/evaluationadd", body: data);

      if (response.success) {
        getData();
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
