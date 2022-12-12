class GoogleAddressModel {
  final String buildingNo;
  final String street;
  final String district;
  final String town;
  final String region;
  final String city;
  final String country;
  final String postalCode;
  final String formatAddress;
  final num lat;
  final num lng;

  GoogleAddressModel.fromJson(Map<String, dynamic> json)
      : buildingNo = json["BuildingNo"],
        street = json["Street"],
        district = json["District"],
        town = json["Town"],
        city = json["City"],
        region = json["Region"],
        country = json["Country"],
        postalCode = json["PostalCode"],
        formatAddress = json["format_adress"],
        lat = json["lat"],
        lng = json["lng"];

  Map<String, dynamic> toJson() {
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
