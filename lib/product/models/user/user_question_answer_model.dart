class UserQuestionAnswerModel {
  int id;
  String contentValue;
  DateTime date;

  UserQuestionAnswerModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        contentValue = json['ContentValue'],
        date = DateTime.parse(json['Date']);

  toJson() => {
        'ID': id,
        'ContentValue': contentValue,
        'Date': date.toIso8601String(),
      };

  @override
  String toString() {
    return 'UserQuestionAnswerModel{id: $id, contentValue: $contentValue, date: $date}';
  }
}
