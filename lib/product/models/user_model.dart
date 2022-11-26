class UserModel {
  late int id;
  late String nameSurname;
  late String email;
  late String phone;
  var password;
  var gender;
  DateTime? birthDate;
  String? imageUrl;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nameSurname = json['Name'];
    email = json['Email'];
    phone = json['MobilePhone'];
    password = json["Password"];
    gender = json["Cinsiyet"];
    birthDate =
        json["BornDate"] != null ? DateTime.parse(json["BornDate"]) : null;
    imageUrl = json["imageUrl"];
  }

  get toJson => {
        "ID": id,
        "Name": nameSurname,
        "Email": email,
        "MobilePhone": phone,
        "Password": password,
        "Cinsiyet": gender,
        "BornDate": birthDate,
        "imageUrl": imageUrl
      };
}
