import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/models/product_detail_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/product/product_detail/product_detail_view_model.dart';
import 'package:koyevi/view/product/product_questions/product_questions_view.dart';
import 'package:koyevi/view/product/product_ratings/product_ratings_view.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final ProductOverViewModel productOverViewModel;
  const ProductDetailView({Key? key, required this.productOverViewModel})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  late final PageController _pageController;
  late final ScrollController _scrollController;
  late final ChangeNotifierProvider<ProductDetailViewModel> provider;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _scrollController = ScrollController();
    provider = ChangeNotifierProvider((ref) => ProductDetailViewModel());

    Future.delayed(Duration.zero, () {
      ref.read(provider).getProductDetail(widget.productOverViewModel.barcode);
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: WillPopScope(
      onWillPop: () {
        Navigator.pop(context, ref.watch(provider).productDetail);
        return Future.value(false);
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar.activeBack(
              LocaleKeys.ProductDetail_appbar_title.tr()),
          body: ref.watch(provider).isLoading
              ? _loading()
              : ref.watch(provider).productDetail != null
                  ? _body()
                  : TryAgain(
                      callBack: () => ref.read(provider).getProductDetail(
                          widget.productOverViewModel.barcode))),
    ));
  }

  Widget _body() {
    return Stack(
      children: [
        Positioned(
            top: 0, left: 0, right: 0, bottom: 50.smh, child: _content()),
        Positioned(bottom: 0, child: _productBottomBar())
      ],
    );
  }

  Widget _content() {
    ProductDetailModel product = ref.watch(provider).productDetail!;
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _productImages(product),
          _imageIndex(product),
          _nameInfo(product),
          _chips(product),
          _options(),
          _productDetails(product),
          _showAllRatings(product),
          _showAllQuestions(product)
        ],
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: CustomImages.loading,
    );
  }

  Widget _productBottomBar() {
    return SizedBox(
      width: AppConstants.designWidth.smw,
      height: 60.smh,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            color: CustomColors.primary,
            width: 150.smw,
            child: Center(
                child: CustomText(
              "${ref.watch(provider).productDetail!.unitPrice.toStringAsFixed(2)} TL",
              style: CustomFonts.bodyText1(CustomColors.primaryText),
            ))),
        Container(
            color: ref.watch(provider).productDetail!.canShipped &&
                    ref.watch(provider).productDetail!.inSale
                ? CustomColors.secondary
                : CustomColors.disabled,
            width: 155.smw,
            child: Center(
                child: ref.watch(provider).productDetail!.basketQuantity == null
                    ? InkWell(
                        onTap: ref.watch(provider).productDetail!.canShipped &&
                                ref.watch(provider).productDetail!.inSale
                            ? ref.read(provider).addBasket
                            : () {},
                        child: Row(
                            mainAxisAlignment: ref
                                        .watch(provider)
                                        .productDetail!
                                        .canShipped &&
                                    ref.watch(provider).productDetail!.inSale
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.center,
                            children: [
                              ref.watch(provider).productDetail!.canShipped &&
                                      ref.watch(provider).productDetail!.inSale
                                  ? CustomIcons.add_basket_icon
                                  : Container(),
                              CustomTextLocale(
                                  ref.watch(provider).statusMessage,
                                  style: CustomFonts.bodyText1(
                                      CustomColors.secondaryText))
                            ]),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              onTap: ref.read(provider).updateBasket,
                              child: CustomIcons.minus_icon),
                          CustomText(
                              ref
                                  .watch(provider)
                                  .productDetail!
                                  .basketQuantity!
                                  .toStringAsFixed(2),
                              style: CustomFonts.bodyText1(
                                  CustomColors.secondaryText)),
                          InkWell(
                              onTap: ref.read(provider).addBasket,
                              child: CustomIcons.add_icon)
                        ],
                      ))),
        InkWell(
          onTap: ref.read(provider).favoriteUpdate,
          child: Container(
              color: CustomColors.primary,
              width: 55.smw,
              child: Center(
                  child: ref.watch(provider).productDetail!.isFavorite
                      ? CustomIcons.favorite_circle_icon
                      : CustomIcons.non_favorite_circle_icon)),
        ),
      ]),
    );
  }

  Widget _productImages(ProductDetailModel product) {
    return Container(
      height: 360.smw,
      width: AppConstants.designWidth.smw,
      margin: EdgeInsets.symmetric(vertical: 10.smh),
      child: PageView.builder(
        onPageChanged: _pageListener,
        controller: _pageController,
        itemCount: ref.watch(provider).productDetail!.images.length,
        itemBuilder: (context, index) => Image.network(
          product.images[index],
          fit: BoxFit.fill,
          cacheWidth: 360.smw.toInt(),
          cacheHeight: 360.smw.toInt(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Image.network(product.thumbNails[index],
                fit: BoxFit.fill,
                cacheWidth: 360.smw.toInt(),
                cacheHeight: 360.smw.toInt(),
                loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: CustomColors.primaryText,
                  color: CustomColors.primary,
                  strokeWidth: 5,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            });
          },
          height: 360.smw,
          width: AppConstants.designWidth.smw,
        ),
      ),
    );
  }

  Widget _imageIndex(ProductDetailModel product) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.smh),
      height: 10.smh,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            product.images.length,
            (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.smw),
                  height: 10.smh,
                  width: 10.smh,
                  decoration: BoxDecoration(
                      color: ref.watch(provider).imageIndex == index
                          ? CustomColors.primary
                          : CustomColors.primaryText,
                      borderRadius: CustomThemeData.fullInfiniteRounded),
                )),
      ),
    );
  }

  void _pageListener(int index) {
    ref.watch(provider).imageIndex = index;
  }

  Widget _nameInfo(ProductDetailModel product) {
    return Container(
        margin: EdgeInsets.only(bottom: 5.smh),
        width: 330.smw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            product.tradeMark == null
                ? Container()
                : CustomText(
                    ref.watch(provider).productDetail!.tradeMark ?? "",
                    style:
                        CustomFonts.bodyText3(CustomColors.backgroundTextPale),
                  ),
            CustomText(product.name,
                style: CustomFonts.bodyText2(CustomColors.backgroundText),
                maxLines: 2)
          ],
        ));
  }

  Widget _chips(ProductDetailModel product) {
    return SizedBox(
      width: 330.smw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _starChip(product.evaluationAverage, product.evaluationCount),
          _unitCodeChip(product.unitCode)
        ],
      ),
    );
  }

  Widget _starChip(num avg, num total) {
    return InkWell(
      onTap: () {
        NavigationService.navigateToPage(
            ProductRatingsView(product: ref.watch(provider).productDetail!));
      },
      child: Container(
        height: 30.smh,
        margin: EdgeInsets.only(right: 5.smw),
        padding: EdgeInsets.symmetric(horizontal: 5.smw, vertical: 5.smh),
        decoration: BoxDecoration(
            color: CustomColors.primary,
            borderRadius: CustomThemeData.fullInfiniteRounded),
        child: Row(children: [
          CustomIcons.star_chip_icon,
          SizedBox(width: 5.smw),
          CustomTextLocale(LocaleKeys.ProductDetail_rating_avg_count,
              args: [avg.toStringAsFixed(1), total.toStringAsFixed(0)],
              style: CustomFonts.bodyText5(CustomColors.primaryText))
        ]),
      ),
    );
  }

  Widget _unitCodeChip(String unitCode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.smw, vertical: 5.smh),
      decoration: BoxDecoration(
          color: CustomColors.primary,
          borderRadius: CustomThemeData.fullInfiniteRounded),
      constraints: BoxConstraints(minWidth: 30.smw),
      height: 30.smh,
      child: Center(
        child: CustomText(unitCode,
            style: CustomFonts.bodyText4(CustomColors.primaryText)),
      ),
    );
  }

  _options() {
    return Container(
      margin: EdgeInsets.only(top: 45.smh),
      height: 60.smh,
      width: 360.smw,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: CustomColors.primary, width: 1),
          bottom: BorderSide(color: CustomColors.primary, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => ref.read(provider).selectedPropertyIndex = 0,
              child: AnimatedContainer(
                duration: CustomThemeData.animationDurationShort,
                curve: Curves.easeInOut,
                color: ref.watch(provider).selectedPropertyIndex == 0
                    ? CustomColors.primary
                    : CustomColors.card,
                child: Center(
                  child: CustomTextLocale(LocaleKeys.ProductDetail_product_info,
                      style: CustomFonts.bigButton(
                          ref.watch(provider).selectedPropertyIndex == 0
                              ? CustomColors.primaryText
                              : CustomColors.cardText)),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => ref.read(provider).selectedPropertyIndex = 1,
              child: AnimatedContainer(
                duration: CustomThemeData.animationDurationShort,
                curve: Curves.easeInOut,
                color: ref.watch(provider).selectedPropertyIndex == 1
                    ? CustomColors.primary
                    : CustomColors.card,
                child: Center(
                  child: CustomTextLocale(
                      LocaleKeys.ProductDetail_product_properties,
                      style: CustomFonts.bigButton(
                          ref.watch(provider).selectedPropertyIndex == 1
                              ? CustomColors.primaryText
                              : CustomColors.cardText)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productDetails(ProductDetailModel product) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: 25.smh),
      duration: CustomThemeData.animationDurationShort,
      color: CustomColors.card,
      width: 360.smw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ref.watch(provider).selectedPropertyIndex == 0
              ? _productDetailsContent(product)
              : _productProperties(product),
          InkWell(
            onTap: () {
              ref.read(provider).infoExpanded =
                  !ref.watch(provider).infoExpanded;
              if (ref.watch(provider).infoExpanded) {
                _scrollController.jumpTo(_scrollController.offset - 5);
                _scrollController.animateTo(_scrollController.offset + 300.smh,
                    duration: CustomThemeData.animationDurationLong,
                    curve: Curves.easeInOut);
              }
            },
            child: AnimatedContainer(
              height: 60.smh,
              duration: CustomThemeData.animationDurationMedium,
              decoration: BoxDecoration(
                  color: CustomColors.secondary,
                  border: Border(
                      top: BorderSide(
                          color: CustomColors.primary, width: 1.smw))),
              child: Center(
                child: CustomTextLocale(
                  ref.watch(provider).infoExpanded
                      ? LocaleKeys.ProductDetail_show_less
                      : LocaleKeys.ProductDetail_show_more,
                  style: CustomFonts.bodyText2(CustomColors.secondaryText),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _productDetailsContent(ProductDetailModel product) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.smw, vertical: 10.smh),
      child: CustomText(
        product.productDetails.itemProperty,
        style: CustomFonts.bodyText2(CustomColors.backgroundTextPale),
        maxLines: ref.watch(provider).infoExpanded ? 1000 : 3,
      ),
    );
  }

  Widget _showAllRatings(ProductDetailModel product) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => NavigationService.navigateToPage(
            ProductRatingsView(product: product)),
        child: Container(
          height: 60.smh,
          width: 300.smw,
          decoration: BoxDecoration(
              color: CustomColors.primary,
              borderRadius: CustomThemeData.rightRounded),
          margin: EdgeInsets.only(bottom: 30.smh),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIcons.evaluations,
              CustomTextLocale(LocaleKeys.ProductDetail_show_all_ratings,
                  style: CustomFonts.bodyText1(CustomColors.primaryText)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showAllQuestions(ProductDetailModel product) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => NavigationService.navigateToPage(ProductQuestionsView(
            product: product,
            productOverViewModel: widget.productOverViewModel)),
        child: Container(
          height: 60.smh,
          width: 300.smw,
          decoration: BoxDecoration(
              color: CustomColors.primary,
              borderRadius: CustomThemeData.leftRounded),
          margin: EdgeInsets.only(bottom: 30.smh),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIcons.questions,
              CustomTextLocale(LocaleKeys.ProductDetail_show_all_questions,
                  style: CustomFonts.bodyText1(CustomColors.primaryText)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productProperties(ProductDetailModel product) {
    List<ProductPropertyModel> productNutritiveValue =
        product.productNutritiveValue.toList();
    if (productNutritiveValue.isEmpty) {
      return Container();
    }

    productNutritiveValue.sort((a, b) => a.forValue.compareTo(b.forValue));
    int max = productNutritiveValue.last.forValue.toInt();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.smw, vertical: 15.smh),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.card,
          borderRadius: CustomThemeData.fullRounded,
          border: Border.all(color: CustomColors.primary, width: 1.smw),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: CustomThemeData.topRounded),
            height: 35.smh,
            width: 330.smw,
            child: Center(
                child: CustomText(
              "$max g/ml",
              style: CustomFonts.bodyText2(CustomColors.primaryText),
            )),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.smw, vertical: 10.smh),
            decoration: BoxDecoration(
                color: CustomColors.card,
                borderRadius: CustomThemeData.bottomRounded),
            child: Column(
              children: List.generate(
                  product.productNutritiveValue.length,
                  (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            product.productNutritiveValue[index].itemProperty,
                            style: CustomFonts.bodyText4(CustomColors.cardText),
                          ),
                          CustomText(
                            product.productNutritiveValue[index].value
                                .toInt()
                                .toString(),
                            style: CustomFonts.bodyText4(
                                CustomColors.cardTextPale),
                          ),
                        ],
                      )),
            ),
          )
        ]),
      ),
    );
  }
}
