class BasketPaymentTypeModel {
  int code;
  String typeName;
  String typeDescription;

  BasketPaymentTypeModel({
    required this.code,
    required this.typeName,
    required this.typeDescription,
  });

  // to json
  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'TypeName': typeName,
      'TypeDescription': typeDescription,
    };
  }

  // from json
  factory BasketPaymentTypeModel.fromJson(Map<String, dynamic> json) {
    return BasketPaymentTypeModel(
      code: json['Code'],
      typeName: json['TypeName'],
      typeDescription: json['TypeDescription'],
    );
  }
}
