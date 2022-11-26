import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/user/user_question_model.dart';

class UserQuestionsViewModel extends ChangeNotifier {
  List<UserQuestionModel> answered = [];
  List<UserQuestionModel> unanswered = [];

  int _index = 0;
  int get index => _index;
  set index(int value) {
    if (value != _index) {
      _index = value;
      notifyListeners();
    }
  }

  UserQuestionsViewModel();

  Future<void> getQuestions() async {
    try {
      ResponseModel response = await NetworkService.get(
          "users/questions/${AuthService.currentUser!.id}");

      if (response.success) {
        List<UserQuestionModel> questions = response.data!
            .map<UserQuestionModel>((e) => UserQuestionModel.fromJson(e))
            .toList();
        for (var element in questions) {
          if (element.answer == null) {
            unanswered.add(element);
          } else {
            answered.add(element);
          }
        }
        notifyListeners();
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
