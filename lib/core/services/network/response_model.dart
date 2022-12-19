import 'package:easy_localization/easy_localization.dart';

typedef ResponseModelMap<V> = ResponseModel<Map<String, V>>;
typedef ResponseModelList<T> = ResponseModel<List<T>>;
typedef ResponseModelString = ResponseModel<String>;
typedef ResponseModelBoolean = ResponseModel<bool>;
typedef ResponseModelInt = ResponseModel<int>;
typedef ResponseModelDouble = ResponseModel<double>;

class ResponseModel<T extends dynamic> {
  String? errorMessage;
  T? data;
  bool get success => errorMessage == null;

  ResponseModel({this.errorMessage, this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    if (json["errorMessage"] == null && json["data"] is T) {
      return ResponseModel<T>(data: json["data"] as T);
    } else if (json["errorMessage"] != null) {
      return ResponseModel<T>(errorMessage: json["errorMessage"]);
    } else {
      return ResponseModel<T>.error();
    }
  }

  factory ResponseModel.error() {
    return ResponseModel<T>(errorMessage: "ERROR".tr());
  }
}
