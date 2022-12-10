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
import 'package:koyevi/core/utils/extensions/datetime_extensions.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/models/category_model.dart';
import 'package:koyevi/product/models/home_banner_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/product/models/user/user_orders_model.dart';
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
    } else if (ref.watch(provider).banners.isNotEmpty) {
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AuthService.isLoggedIn ? _addressBar() : Container(height: 0),
          _searchBar(),
          AuthService.isLoggedIn ? _orders() : Container(height: 0),
          _bannersContent(),
        ],
      ),
    );
  }

  Widget _addressBar() {
    AddressModel? address = ref.watch(provider).defaultAddress;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.smh),
      decoration: BoxDecoration(
          borderRadius: CustomThemeData.bottomInfiniteRounded,
          color: CustomColors.secondary),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.smw),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcons.location_icon,
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.smw),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        address != null
                            ? address.addressHeader.toString()
                            : "-",
                        style: CustomFonts.bodyText4(CustomColors.cardInner),
                        maxLines: 1),
                    CustomText(
                        address != null ? address.address.toString() : "-",
                        style: CustomFonts.bodyText4(CustomColors.cardInner),
                        maxLines: 1),
                  ],
                ),
              ),
            ),
            InkWell(onTap: _addressesDialog, child: CustomIcons.order_icon)
          ],
        ),
      ),
    );
  }

  Widget _orders() {
    return Container(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ref.watch(provider).orders.length,
        itemBuilder: (context, index) {
          UserOrdersModel order = ref.watch(provider).orders[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.smw),
            child: _orderCard(order),
          );
        },
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: banners.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _fastCategories();
        } else {
          return banners[index - 1];
        }
      },
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
            itemCount: ref.watch(provider).categories.length,
            itemBuilder: (context, index) {
              CategoryModel category = ref.watch(provider).categories[index];
              return InkWell(
                onTap: () => NavigationService.navigateToPage(SubCategoriesView(
                    masterCategory: category,
                    masterCategories: ref.watch(provider).categories)),
                child: Container(
                  margin: EdgeInsets.only(
                      left: 10.smw,
                      right: index == ref.watch(provider).categories.length - 1
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
    List<HomeBannerModel> banners = ref.watch(provider).banners;
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
        List<ProductOverViewModel> products = [];
        ResponseModel response = await NetworkService.post(
            "products/ProductfromBarcodes",
            body: {"CariID": AuthService.id, "BarcodeArrays": model.barcodes});

        if (response.success) {
          products = (response.data as List)
              .map((e) => ProductOverViewModel.fromJson(e))
              .toList();
        }
        NavigationService.navigateToPage(
            SearchResultView(products: products, isSearch: false));
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

  Future<void> _addressesDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              insetPadding:
                  EdgeInsets.symmetric(horizontal: 20.smw, vertical: 0),
              backgroundColor: CustomColors.secondary,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ref.watch(provider).addresses.length + 1,
                itemBuilder: (context, index) {
                  if (index == ref.watch(provider).addresses.length) {
                    return Container(
                        margin: EdgeInsets.symmetric(vertical: 10.smh),
                        child: const SizedBox()
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     CustomIcons.add_icon,
                        //     SizedBox(width: 5.smw),
                        //     CustomTextLocale(LocaleKeys.UserAddresses_add_address,
                        //         style: CustomFonts.bodyText1(
                        //             CustomColors.secondaryText)),
                        //   ],
                        // ),
                        );
                  } else {
                    return InkWell(
                      onTap: () {
                        ref
                            .read(provider)
                            .setDefaultAddress(
                                ref.watch(provider).addresses[index].id)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.smw),
                        margin: EdgeInsets.only(top: 10.smh),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        ref
                                            .watch(provider)
                                            .addresses[index]
                                            .addressHeader,
                                        style: CustomFonts.bodyText3(
                                            CustomColors.secondaryText)),
                                    CustomText(
                                        ref
                                            .watch(provider)
                                            .addresses[index]
                                            .address,
                                        style: CustomFonts.bodyText4(
                                            CustomColors.secondaryText)),
                                  ]),
                            ),
                            ref.watch(provider).addresses[index] ==
                                    ref.watch(provider).defaultAddress
                                ? CustomIcons.radio_checked_light_icon
                                : CustomIcons.radio_unchecked_light_icon,
                          ],
                        ),
                      ),
                    );
                  }
                },
              ));
        });
  }

  Widget _orderCard(UserOrdersModel orderModel) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.smh),
      padding: EdgeInsets.symmetric(horizontal: 5.smw, vertical: 5.smh),
      decoration: BoxDecoration(
          color: CustomColors.card2,
          border: Border.all(color: CustomColors.primary, width: 1),
          borderRadius: CustomThemeData.fullRounded),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomIcons.profile_delivery,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText("Devam eden siparişiniz",
                  style: CustomFonts.bodyText3(CustomColors.card2TextPale)),
              SizedBox(height: 5.smh),
              CustomText("Sipariş tarihi: ${orderModel.orderDate}",
                  style: CustomFonts.bodyText5(CustomColors.card2TextPale)),
              CustomText(
                  "Tahmini Teslimat Tarihi: ${orderModel.deliveryAddressDetail!.deliveryDate!.toFormattedString()}",
                  style: CustomFonts.bodyText5(CustomColors.card2Text)),
              CustomText("Durumu: ${orderModel.statusName}",
                  style: CustomFonts.bodyText5(CustomColors.card2Text))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText("Sipariş no",
                  style: CustomFonts.bodyText5(CustomColors.card2Text)),
              CustomText(orderModel.orderId.toString(),
                  style: CustomFonts.bodyText5(CustomColors.card2Text)),
              Container(
                  decoration: BoxDecoration(
                      color: CustomColors.primary,
                      borderRadius: CustomThemeData.fullInfiniteRounded),
                  width: 80.smw,
                  height: 35.smh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomText("Detaylar",
                          style:
                              CustomFonts.bodyText4(CustomColors.primaryText)),
                      CustomIcons.forward_icon_light
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
