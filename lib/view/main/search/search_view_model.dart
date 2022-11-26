import 'package:flutter/material.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/last_searched_model.dart';
import 'package:koyevi/product/models/user/last_viewed_model.dart';
import 'package:koyevi/view/main/search_result/search_result_view.dart';

class SearchViewModel extends ChangeNotifier {
  int lastSearchCount = 5;
  int lastViewedCount = 5;

  List<LastViewedModel> lastViewed = [];
  List<LastSearchedModel> lastSearched = [];

  SearchViewModel();

  bool _loaded = false;
  bool get loaded => _loaded;
  set loaded(bool value) {
    _loaded = value;
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getLastData() async {
    try {
      ResponseModelList lastSearches = await NetworkService.get<List>(
          "users/last_search_keywords/${AuthService.currentUser!.id}/$lastSearchCount");
      ResponseModelList lastVieweds = await NetworkService.get<List>(
          "users/lastviewed/${AuthService.currentUser!.id}/$lastViewedCount");
      if (lastSearches.success && lastVieweds.success) {
        lastSearched = lastSearches.data!
            .map((e) => LastSearchedModel.fromJson(e))
            .toList();
        lastViewed =
            lastVieweds.data!.map((e) => LastViewedModel.fromJson(e)).toList();
        _loaded = true;
      } else {
        if (!lastSearches.success) {
          PopupHelper.showErrorDialog(errorMessage: lastSearches.errorMessage!);
        }
        if (!lastVieweds.success) {
          PopupHelper.showErrorDialog(errorMessage: lastVieweds.errorMessage!);
        }
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> searchKeywordDelete(int id) async {
    try {
      ResponseModel lastSearches =
          await NetworkService.post("users/searchkeyworddelete", body: [id]);
      if (lastSearches.success) {
        lastSearched.removeWhere((element) => element.id == id);
        notifyListeners();
        PopupHelper.showSuccessToast("Arama geçmişi silindi");
      } else {
        PopupHelper.showErrorDialog(errorMessage: lastSearches.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> deleteAllKeywords() async {
    try {
      ResponseModel lastSearches = await NetworkService.post(
          "users/searchkeyworddelete/",
          body: lastSearched.map((e) => e.id).toList());
      if (lastSearches.success) {
        lastSearched.clear();
        notifyListeners();
        PopupHelper.showSuccessToast("Tüm arama geçmişi silindi");
      } else {
        PopupHelper.showErrorDialog(errorMessage: lastSearches.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> search(String searchKey) async {
    try {
      ResponseModel searchResults = await NetworkService.get(
          "products/productsearch/${AuthService.currentUser!.id}/$searchKey");

      if (searchResults.success) {
        var list = searchResults.data
            .map((e) => ProductOverViewModel.fromJson(e))
            .toList();
        var products = list.cast<ProductOverViewModel>();
        NavigationService.navigateToPage(
                SearchResultView(products: products, isSearch: true))
            .then((value) {
          getLastData();
        });
      } else {
        PopupHelper.showErrorDialog(errorMessage: searchResults.errorMessage!);
      }

      notifyListeners();
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
