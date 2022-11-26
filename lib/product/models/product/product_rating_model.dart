import 'package:flutter/material.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';

class ProductRatingModel {
  int id;
  ProductRatingCariModel cari;
  double ratingValue;
  String? contentValue;
  DateTime date;

  ProductRatingModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        cari = ProductRatingCariModel.fromJson(json['Cari']),
        ratingValue = json['RatingValue'],
        contentValue = json['ContentValue'],
        date = DateTime.parse(json['Date']);
}

class ProductRatingCariModel {
  int id;
  String name;
  final String? _imageUrl;
  Widget image({required double height, required double width}) =>
      _imageUrl != null && _imageUrl!.isNotEmpty
          ? Image.network(
              _imageUrl!.replaceAll("\\", "/"),
              height: height,
              width: width,
              fit: BoxFit.fill,
            )
          : SizedBox(
              height: height,
              width: width,
              child: CustomImages.image_not_found);

  ProductRatingCariModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        name = json['Name'],
        _imageUrl = json['ImageUrl'];
}
