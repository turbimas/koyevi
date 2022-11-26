import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/product/models/product/product_rating_model.dart';
import 'package:koyevi/product/models/product_detail_model.dart';

class ProductRatingsViewModel extends ChangeNotifier {
  ProductDetailModel product;
  ProductRatingsViewModel({required this.product});

  List<ProductRatingModel>? ratings;
  List<ProductRatingModel> filteredRatings = [];

  Set<num> currentRatings = {};
  Set<num> currentRatingsFilter = {};

  void addRemoveFilter(num rating) {
    if (currentRatingsFilter.contains(rating)) {
      currentRatingsFilter.remove(rating);
    } else {
      currentRatingsFilter.add(rating);
    }

    if (searchFilter.isEmpty) {
      filteredRatings = ratings!
          .where(
              (element) => currentRatingsFilter.contains(element.ratingValue))
          .toList();
    } else {
      filteredRatings = ratings!
          .where((element) =>
              currentRatingsFilter.contains(element.ratingValue) &&
              element.contentValue
                  .toString()
                  .toLowerCase()
                  .contains(searchFilter.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  String _searchFilter = "";
  String get searchFilter => _searchFilter;
  set searchFilter(String value) {
    _searchFilter = value;
    filteredRatings.clear();
    if (value.isNotEmpty) {
      for (var rating in ratings!) {
        if (rating.contentValue
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) &&
            currentRatingsFilter.contains(rating.ratingValue)) {
          filteredRatings.add(rating);
        }
      }
    } else {
      filteredRatings.addAll(ratings!);
    }
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  num get averageRating {
    if (ratings == null || ratings!.isEmpty) {
      return 0;
    }
    num sum = 0;
    for (var element in ratings!) {
      sum += element.ratingValue;
    }
    return sum / ratings!.length;
  }

  int get allRatingCount => ratings!.length;
  int get onlyContentRatingCount =>
      ratings!.where((element) => element.contentValue != null).length;

  int getNumberOfRatingByRating(num rating) {
    return ratings!.where((element) => element.ratingValue == rating).length;
  }

  int getNumberOfContentByRating(num rating) {
    return ratings!
        .where((element) =>
            element.ratingValue == rating && element.contentValue != null)
        .length;
  }

  Future<void> getRatings() async {
    try {
      ratings = null;
      isLoading = true;
      ResponseModel response = await NetworkService.get(
          "products/evaluations/${AuthService.currentUser!.id}/${product.barcode}");

      if (response.success) {
        ratings = response.data
            .map<ProductRatingModel>(
                (element) => ProductRatingModel.fromJson(element))
            .toList();
        currentRatings.clear();
        currentRatingsFilter.clear();
        for (var element in ratings!) {
          currentRatingsFilter.add(element.ratingValue);
          currentRatings.add(element.ratingValue);
        }
        filteredRatings.clear();
        filteredRatings.addAll(ratings!);
      }
    } finally {
      isLoading = false;
    }
  }
}
