class LastSearchedModel {
  int id;
  String contentValue;
  DateTime date;

  LastSearchedModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        contentValue = json['ContentValue'],
        date = DateTime.parse(json['Date']);
}
