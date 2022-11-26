import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/user_question_answer_model.dart';

class UserQuestionModel {
  int id;
  ProductOverViewModel product;
  String contentValue;
  DateTime date;
  UserQuestionAnswerModel? answer;

  UserQuestionModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        product = ProductOverViewModel.fromJson(json['Product']),
        contentValue = json['ContentValue'],
        date = DateTime.parse(json['Date']),
        answer = json["Answer"] != null
            ? UserQuestionAnswerModel.fromJson(json['Answer'])
            : null;

  toJson() => {
        'ID': id,
        'Product': product.toJson(),
        'ContentValue': contentValue,
        'Date': date.toIso8601String(),
        'Answer': answer?.toJson()
      };
  @override
  String toString() {
    return 'UserQuestionModel{id: $id, product: $product, contentValue: $contentValue, date: $date, answer: $answer}';
  }
}
