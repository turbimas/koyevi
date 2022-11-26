import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/models/category_model.dart';
import 'package:koyevi/product/models/home_banner_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/product/widgets/custom_searchbar_view.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/product_overview_view.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/main/home/home_view_model.dart';
import 'package:koyevi/view/main/search/search_view.dart';
import 'package:koyevi/view/main/search_result/search_result_view.dart';
import 'package:koyevi/view/main/sub_categories/sub_categories_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late final ChangeNotifierProvider<HomeViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => HomeViewModel());
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(provider).getHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    if (ref.watch(provider).homeLoading) {
      return _loading();
    } else if (ref.watch(provider).categories != null &&
        ref.watch(provider).banners != null) {
      return _content();
    } else {
      return TryAgain(callBack: ref.read(provider).getHomeData);
    }
  }

  Widget _loading() {
    return Center(
      child: CustomImages.loading,
    );
  }

  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //_addressBar(),
        _searchBar(),
        _bannersContent(),
      ],
    );
  }

  Widget _addressBar() {
    AddressModel? address = ref.watch(provider).address;
    if (address == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.smh),
      decoration: BoxDecoration(
          borderRadius: CustomThemeData.bottomInfiniteRounded,
          color: CustomColors.secondary),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.watch(provider).address!.addressHeader.toString(),
                    style: CustomFonts.bodyText4(CustomColors.cardInner),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  Text(
                    ref.watch(provider).address!.address.toString(),
                    style: CustomFonts.bodyText4(CustomColors.cardInner),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.smh),
      child: InkWell(
          onTap: () {
            NavigationService.navigateToPage(const SearchView());
          },
          child: AbsorbPointer(
              child:
                  CustomSearchBarView(hint: LocaleKeys.Home_search_hint.tr()))),
    );
  }

  Widget _bannersContent() {
    List<Widget> banners = _banners();
    return SizedBox(
      height: 650.smh,
      child: ListView.builder(
        itemCount: banners.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _fastCategories();
          } else {
            return banners[index - 1];
          }
        },
      ),
    );
  }

  Widget _fastCategories() {
    return Container(
      height: 120.smh,
      margin: EdgeInsets.only(bottom: 10.smh),
      color: CustomColors.card,
      width: AppConstants.designWidth.smw,
      padding: EdgeInsets.symmetric(vertical: 5.smh),
      child: Scrollbar(
        trackVisibility: true,
        radius: CustomThemeData.fullInfiniteRounded.topLeft,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ref.watch(provider).categories!.length,
            itemBuilder: (context, index) {
              CategoryModel category = ref.watch(provider).categories![index];
              return InkWell(
                onTap: () => NavigationService.navigateToPage(SubCategoriesView(
                    masterCategory: category,
                    masterCategories: ref.watch(provider).categories)),
                child: Container(
                  margin: EdgeInsets.only(
                      left: 10.smw,
                      right: index == ref.watch(provider).categories!.length - 1
                          ? 0
                          : 10.smw),
                  width: 60.smw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration:
                            BoxDecoration(boxShadow: CustomThemeData.shadow2),
                        child: ClipRRect(
                            borderRadius: CustomThemeData.fullRounded,
                            child: category.image(height: 60.h, width: 60.h)),
                      ),
                      SizedBox(height: 5.smh),
                      Expanded(
                        child: SizedBox(
                          width: 60.smw,
                          child: CustomText(
                            category.groupName,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: CustomFonts.bodyText5(CustomColors.cardText),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  List<Widget> _banners() {
    List<HomeBannerModel> banners = ref.watch(provider).banners!;
    return List.generate(banners.length, (index) {
      HomeBannerModel banner = banners[index];
      if (banner.type == 2) {
        return _imageBanner(banner);
      } else {
        return _productBanner(banner);
      }
    });
  }

  Widget _imageBanner(HomeBannerModel model) {
    return InkWell(
      onTap: () async {
        var _products = null;
        ResponseModel response =
            await NetworkService.post("products/ProductfromBarcodes", body: {
          "CariID": AuthService.currentUser!.id,
          "BarcodeArrays": model.barcodes
        });

        if (response.success) {
          _products = (response.data as List)
              .map((e) => ProductOverViewModel.fromJson(e))
              .toList();
        }
        NavigationService.navigateToPage(
            SearchResultView(products: _products, isSearch: false));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10.smh),
          width: AppConstants.designWidth.smw,
          decoration: BoxDecoration(
              color: CustomColors.card, boxShadow: CustomThemeData.shadow3),
          height: 215.smh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 15.smw),
                  height: 30.smw,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      model.title,
                      style: CustomFonts.bodyText4(CustomColors.cardText),
                    ),
                  )),
              ClipRRect(
                borderRadius: CustomThemeData.fullRounded,
                child: Image.network(model.bannerUrl,
                    fit: BoxFit.fill, width: 340.smw, height: 170.smh),
              ),
            ],
          )),
    );
  }

  Widget _productBanner(HomeBannerModel model) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.smh),
      margin: EdgeInsets.only(bottom: 10.smh),
      decoration: BoxDecoration(
          color: CustomColors.card, boxShadow: CustomThemeData.shadow3),
      width: AppConstants.designWidth.smw,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15.smw),
              height: 30.smh,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    model.title,
                    style: CustomFonts.bodyText4(CustomColors.cardText),
                  ),
                  InkWell(
                    onTap: () {
                      NavigationService.navigateToPage(SearchResultView(
                          products: model.products, isSearch: false));
                    },
                    child: Container(
                      width: 90.smw,
                      height: 20.smh,
                      decoration: BoxDecoration(
                          color: CustomColors.cardInner,
                          borderRadius: CustomThemeData.fullInfiniteRounded),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText(LocaleKeys.Home_all.tr(),
                              style: CustomFonts.bodyText4(
                                  CustomColors.cardInnerText)),
                          CustomIcons.arrow_right_circle_icon
                        ],
                      ),
                    ),
                  )
                ],
              )),
          SizedBox(height: 5.smh),
          Scrollbar(
            trackVisibility: true,
            radius: CustomThemeData.fullInfiniteRounded.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    model.products.length,
                    (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.smw),
                          child: ProductOverviewVerticalView(
                              product: model.products[index]),
                        )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
