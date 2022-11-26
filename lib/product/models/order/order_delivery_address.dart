class OrderDeliveryAddress {
  late final int id;
  String? addressHeader;
  String? address;
  String? phone;
  String? email;
  String? relatedPerson;
  DateTime? deliveryDate; // tahmini teslimat

  OrderDeliveryAddress.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    addressHeader = json['AdresBasligi'];
    address = json['Address'];
    phone = json['MobilePhone'];
    email = json['Email'];
    relatedPerson = json['RelatedPerson'];
    deliveryDate = json["DeliveryDate"] != null
        ? DateTime.parse(json['DeliveryDate'])
        : null;
  }
}
