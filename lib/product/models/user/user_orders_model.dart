import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/product/models/order/basket_total_model.dart';
import 'package:koyevi/product/models/order/order_delivery_address.dart';
import 'package:koyevi/product/models/order/order_invoice_address.dart';

class UserOrdersModel {
  late final int orderId;
  late final String ficheNo;
  late final String deliveryCode;
  late final DateTime orderDate; // siparişin verildiği tarih
  DateTime? realDeliveryDate; // teslim edildiyse
  late final String statusName;
  String? paymentStatusName;
  String? paymentTypeName;
  late final int lineCount;
  late final num total;
  late final String? firstImageUrl;
  OrderDeliveryAddress? deliveryAddressDetail;
  OrderInvoiceAddress? invoiceAddressDetail;
  BasketTotalModel? orderTotals;
  late final bool refundable;
  late final bool voidable;

  Widget image({required double height, required double width}) {
    if (firstImageUrl != null) {
      return CachedNetworkImage(
          imageUrl: firstImageUrl!.replaceAll("\\", "/"),
          height: height,
          width: width,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(color: CustomColors.primary));
    } else {
      return SizedBox(
          height: height, width: width, child: CustomImages.image_not_found);
    }
  }

  UserOrdersModel.fromJson(Map<String, dynamic> json) {
    orderId = json['OrderID'];
    ficheNo = json['FicheNo'];
    deliveryCode = json['DeliveryCode'];
    orderDate = DateTime.parse(json['OrderDate']);
    realDeliveryDate = json['RealDeliveryDate'] != null
        ? DateTime.parse(json['RealDeliveryDate'])
        : null;
    statusName = json['StatusName'];
    paymentStatusName = json['PaymentStatusName'];
    paymentTypeName = json['PaymentTypeName'];
    lineCount = json['LineCount'];
    total = json['Total'];
    firstImageUrl = json['FirstImageUrl'];
    deliveryAddressDetail = json['DeliveryAdressDetail'] != null
        ? OrderDeliveryAddress.fromJson(json['DeliveryAdressDetail'])
        : null;
    invoiceAddressDetail = json['InvoiceAdressDetail'] != null
        ? OrderInvoiceAddress.fromJson(json['InvoiceAdressDetail'])
        : null;
    orderTotals = json['OrderTotals'] != null
        ? BasketTotalModel.fromJson(json['OrderTotals'])
        : null;
    refundable = json["Refundable"];
    voidable = json["Voidable"];
  }
}
