class UserModel {
  late int id;
  late String nameSurname;
  late String phone;
  late String password;
  bool? gender;
  DateTime? birthDate;
  String? imageUrl;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nameSurname = json['Name'];
    phone = json['MobilePhone'];
    password = json["Password"];
    gender = json["Cinsiyet"];
    birthDate =
        json["BornDate"] != null ? DateTime.parse(json["BornDate"]) : null;
    imageUrl = json["imageUrl"];
  }

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": nameSurname,
        "MobilePhone": phone,
        "Password": password,
        "Cinsiyet": gender,
        "BornDate": birthDate,
        "imageUrl": imageUrl
      };

  @override
  String toString() => toJson.toString();
}
