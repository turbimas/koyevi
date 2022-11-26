import 'package:easy_localization/easy_localization.dart';

typedef ResponseModelMap<K, V> = ResponseModel<Map<K, V>>;
typedef ResponseModelList<T> = ResponseModel<List<T>>;
typedef ResponseModelString = ResponseModel<String>;
typedef ResponseModelBoolean = ResponseModel<bool>;
typedef ResponseModelInt = ResponseModel<int>;
typedef ResponseModelDouble = ResponseModel<double>;

// class ResponseModel<T> {
//   late String code;
//   dynamic _data;
//   T get data => _data;
//   bool get success => code == "SUCCESS";
//   String get errorMessage => "ErrorCodes.$code".tr();

//   ResponseModel(this.code, [this._data]);

//   factory ResponseModel.fromJson(Map<String, dynamic> json) {
//     if (json["data"] is T && json["code"] == "SUCCESS") {
//       return ResponseModel<T>(json["code"], json["data"] as T);
//     } else {
//       return ResponseModel(json["code"]);
//     }
//   }

//   toJson() {
//     return {"code": code, "data": _data};
//   }

//   ResponseModel.error() : code = "ERROR";
// }

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

  factory ResponseModel.networkError() {
    return ResponseModel<T>(errorMessage: "NETWORK_ERROR".tr());
  }
}
