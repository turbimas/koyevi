class OrderInvoiceAddress {
  late final int id;
  String? addressHeader;
  String? address;
  String? phone;
  String? email;
  String? relatedPerson;
  String? taxOffice;
  String? taxNumber;
  bool? isPerson;
  String? tcNo;
  DateTime? deliveryDate;

  OrderInvoiceAddress.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    addressHeader = json['AdresBasligi'];
    address = json['Address'];
    phone = json['MobilePhone'];
    email = json['Email'];
    relatedPerson = json['RelatedPerson'];
    taxOffice = json['TaxOffice'];
    taxNumber = json['TaxNumber'];
    isPerson = json['isPerson'];
    tcNo = json['TCKNo'];
    deliveryDate = json["DeliveryDate"] != null
        ? DateTime.parse(json['DeliveryDate'])
        : null;
  }
}
