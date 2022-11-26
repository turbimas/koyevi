import 'package:koyevi/product/models/product_over_view_model.dart';

class HomeBannerModel {
  late final String title;
  late final int type;
  late final String typeName;
  late final int order;
  late final String _bannerUrl;
  String get bannerUrl => _bannerUrl.replaceAll("\\", "/");
  List<String> barcodes = [];
  List<ProductOverViewModel> products = [];

  HomeBannerModel.fromJson(Map<String, dynamic> json) {
    title = json['Tittle'];
    type = json['Type'];
    typeName = json['TypeName'];
    order = json['Order'];
    _bannerUrl = json['BannerUrl'];
    barcodes = json['Barcodes'].cast<String>();
    products = (json['Products'] as List)
        .map((e) => ProductOverViewModel.fromJson(e))
        .toList();
  }
}
