import 'package:flutter/material.dart';

class UserPromotionsViewModel extends ChangeNotifier {
  UserPromotionsViewModel();
  List<String> promotionMessages = [
    "Promosyon kullanmayacağım",
    "Tüm kuruyemiş ürünlerinde 50 TL üzeri alışverişlerinizde %10 indirim",
    "Tüm alışverişlerinizde geçerli %5 indirim"
  ];
}
