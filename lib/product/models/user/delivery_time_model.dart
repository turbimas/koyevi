class DeliveryTimeModel {
  String typeName;
  List<Dates> dates;

  DeliveryTimeModel.fromJson(Map<String, dynamic> json)
      : typeName = json['TypeName'],
        dates = json['Dates'].map<Dates>((e) => Dates.fromJson(e)).toList();

  toJson() {
    return {
      'TypeName': typeName,
      'Dates': dates.map((e) => e.toJson()).toList(),
    };
  }
}

class Dates {
  String dayDateTime;
  String dayExpression;
  String dayName;
  List<String> hours;

  Dates.fromJson(Map<String, dynamic> json)
      : dayDateTime = json['DayDateTime'],
        dayExpression = json['DayExpression'],
        dayName = json['DayName'],
        hours = json['Hours'].cast<String>();

  toJson() {
    return {
      'DayDateTime': dayDateTime,
      'DayExpression': dayExpression,
      'DayName': dayName,
      'Hours': hours,
    };
  }
}
