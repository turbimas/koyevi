import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/product_detail_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/user_question_model.dart';

class ProductQuestionsViewModel extends ChangeNotifier {
  ProductDetailModel product;
  ProductOverViewModel productOverViewModel;
  List<UserQuestionModel>? questions;
  List<UserQuestionModel> filteredQuestions = [];
  ProductQuestionsViewModel(
      {required this.product, required this.productOverViewModel});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getQuestions() async {
    try {
      isLoading = true;
      ResponseModel response = await NetworkService.get(
          "products/questions/${AuthService.currentUser!.id}/${product.barcode}");
      if (response.success) {
        questions = response.data
            .where((element) => element["Answer"] != null)
            .map<UserQuestionModel>((element) {
          element["Product"] = element["Product"];

          return UserQuestionModel.fromJson(element);
        }).toList();

        filteredQuestions.clear();
        filteredQuestions.addAll(questions!);
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> onChanged(String value) async {
    filteredQuestions.clear();
    if (value.isEmpty) {
      filteredQuestions.addAll(questions!);
    } else {
      filteredQuestions.addAll(questions!.where((element) =>
          element.contentValue.toLowerCase().contains(value.toLowerCase()) ||
          element.answer!.contentValue
              .toLowerCase()
              .contains(value.toLowerCase())));
    }
    notifyListeners();
  }

  Future<void> addQuestion() async {
    PopupHelper.actionPopups.showQuestionPopup(
        productOverViewModel: productOverViewModel,
        onSubmit: (String value) async {
          if (value.trim().isNotEmpty) {
            ResponseModel response =
                await NetworkService.post("products/questionadd", body: {
              "Barcode": product.barcode,
              "CariID": AuthService.currentUser!.id,
              "ContentValue": value
            });
            if (response.success) {
              PopupHelper.showSuccessDialog(
                  "Başarıyla sorunuz gönderildi! Cevaplandığı zaman profilinizde görünecektir.");
            } else {
              PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
            }
          } else {
            PopupHelper.showErrorDialog(
                errorMessage: "Lütfen sorunuzu giriniz!");
          }
        });
  }
}
