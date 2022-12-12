class LocaleAddressModel {
  late int cariID;
  late String adresBasligi;
  late String mobilePhone;
  String email = "";
  String notes = "";
  String? taxOffice;
  String? taxNumber;
  bool? isPerson;
  // ignore: non_constant_identifier_names
  String? TCKNo;
  String? relatedPerson;

  toJson() {
    return {
      "CariID": cariID,
      "AdresBasligi": adresBasligi,
      "MobilePhone": mobilePhone,
      "Email": email,
      "Notes": notes,
      "TaxOffice": taxOffice,
      "TaxNumber": taxNumber,
      "isPerson": isPerson,
      "TCKNo": TCKNo,
      "RelatedPerson": relatedPerson,
    };
  }
}
