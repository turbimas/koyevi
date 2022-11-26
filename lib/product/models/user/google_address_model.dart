class GoogleAddressModel {
  String buildingNo;
  String street;
  String district;
  String town;
  String region;
  String city;
  String country;
  String postalCode;
  String formatAddress;
  late num lat;
  late num lng;

  GoogleAddressModel.fromJson(Map<String, dynamic> json)
      : buildingNo = json["BuildingNo"],
        street = json["Street"],
        district = json["District"],
        town = json["Town"],
        city = json["City"],
        region = json["Region"],
        country = json["Country"],
        postalCode = json["PostalCode"],
        formatAddress = json["format_adress"];

  toJson() {
    return {
      "BuildingNo": buildingNo,
      "Street": street,
      "District": district,
      "Town": town,
      "Region": region,
      "City": city,
      "Country": country,
      "PostalCode": postalCode,
      "format_adress": formatAddress,
      "lat": lat,
      "lng": lng
    };
  }
}
