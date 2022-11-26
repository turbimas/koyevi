// ignore_for_file: hash_and_equals

import 'package:flutter/material.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';

class CategoryModel {
  late final int id;
  late final int upperGroupId;
  late final String groupName;
  late final int? siraNo;
  late final String? _imageUrl;
  Widget image({required double height, required double width}) =>
      _imageUrl != null
          ? Image.network(
              _imageUrl!.replaceAll("\\", "/"),
              height: height,
              width: width,
              fit: BoxFit.fill,
            )
          : SizedBox(
              height: height,
              width: width,
              child: CustomImages.image_not_found,
            );

  CategoryModel.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        upperGroupId = json['UpperGroupID'],
        groupName = json['GroupName'],
        siraNo = json['SiraNo'],
        _imageUrl = json['ImageUrl'];

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'UpperGroupID': upperGroupId,
      'GroupName': groupName,
      'SiraNo': siraNo,
      'ImageUrl': _imageUrl
    };
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, upperGroupId: $upperGroupId, groupName: $groupName, siraNo: $siraNo, _imageUrl: $_imageUrl}';
  }

  // equal operator
  @override
  bool operator ==(other) => other is CategoryModel && other.id == id;
}
