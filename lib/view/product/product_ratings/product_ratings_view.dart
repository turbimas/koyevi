import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/models/product/product_rating_model.dart';
import 'package:koyevi/product/models/product_detail_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_searchbar_view.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/product/product_ratings/product_ratings_view_model.dart';

class ProductRatingsView extends ConsumerStatefulWidget {
  final ProductDetailModel product;
  const ProductRatingsView({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ProductRatingsViewState();
}

class ProductRatingsViewState extends ConsumerState<ProductRatingsView> {
  late final ChangeNotifierProvider<ProductRatingsViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider(
        (ref) => ProductRatingsViewModel(product: widget.product));
    Future.delayed(Duration.zero, () {
      ref.read(provider).getRatings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: CustomAppBar.activeBack(
            LocaleKeys.ProductRatings_appbar_title.tr(
                args: [widget.product.name])),
        body: _body(),
      ),
    );
  }

  Widget _loading() => Center(child: CustomImages.loading);

  Widget _body() {
    if (ref.watch(provider).isLoading) {
      return _loading();
    } else {
      if (ref.watch(provider).ratings != null) {
        if (ref.watch(provider).ratings!.isNotEmpty) {
          return _content();
        } else {
          return _empty();
        }
      } else {
        return TryAgain(callBack: ref.read(provider).getRatings);
      }
    }
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _header(),
          ..._selectableRatingBars(),
          _searchBar(),
          ..._ratings()
        ],
      ),
    );
  }

  Widget _empty() {
    return Center(
        child: CustomTextLocale(LocaleKeys.ProductRatings_no_rating_found_yet,
            style: CustomFonts.bodyText2(CustomColors.backgroundText)));
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CustomColors.backgroundText,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Row(
          children: [
            SizedBox(
              width: 150.smw,
              child: Center(
                child: CustomText(
                  ref.watch(provider).averageRating.toStringAsFixed(1),
                  style: CustomFonts.bodyText1(CustomColors.primary)
                      .copyWith(fontSize: 90.sp),
                ),
              ),
            ),
            SizedBox(
              width: 210.smw,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextLocale(
                    LocaleKeys.ProductRatings_rating_comment_count,
                    args: [
                      ref.watch(provider).allRatingCount.toString(),
                      ref.watch(provider).onlyContentRatingCount.toString()
                    ],
                  ),
                  SizedBox(height: 20.smh),
                  RatingBarIndicator(
                    rating: ref.watch(provider).averageRating.toDouble(),
                    itemBuilder: (context, index) => CustomIcons.star_selected,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 5.smw),
                    itemSize: 30.smh,
                    direction: Axis.horizontal,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _selectableRatingBars() {
    List<num> ordered = ref.watch(provider).currentRatings.toList();
    ordered.sort((a, b) => b.compareTo(a));
    return ordered.map((e) {
      return _selectableRatingBarTile(e);
    }).toList();
  }

  Widget _searchBar() {
    return CustomSearchBarView(
      hint: LocaleKeys.ProductRatings_search_hint.tr(),
      onChanged: (String value) {
        ref.read(provider).searchFilter = value;
      },
    );
  }

  List<Widget> _ratings() {
    return ref.watch(provider).filteredRatings.map((e) {
      return _ratingTile(e);
    }).toList();
  }

  Widget _selectableRatingBarTile(num rating) {
    return InkWell(
      onTap: () => ref.read(provider).addRemoveFilter(rating),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.smh),
        height: 70.smh,
        width: AppConstants.designHeight.smw,
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(color: CustomColors.backgroundText))),
                height: 70.smh,
                width: 70.smw,
                child: Center(
                  child: CustomText(rating.toString()),
                )),
            SizedBox(
              height: 70.smh,
              width: 220.smw,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RatingBarIndicator(
                      rating: rating.toDouble(),
                      itemBuilder: (context, index) =>
                          CustomIcons.star_selected,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 5.smw),
                      itemSize: 30.smh,
                      direction: Axis.horizontal,
                    ),
                    CustomTextLocale(
                      LocaleKeys.ProductRatings_rating_comment_count,
                      args: [
                        ref
                            .watch(provider)
                            .getNumberOfRatingByRating(rating)
                            .toString(),
                        ref
                            .watch(provider)
                            .getNumberOfContentByRating(rating)
                            .toString()
                      ],
                    )
                  ]),
            ),
            SizedBox(
              height: 70.smh,
              width: 70.smw,
              child: SizedBox(
                height: 30.smw,
                width: 30.smw,
                child: Center(
                  child:
                      ref.watch(provider).currentRatingsFilter.contains(rating)
                          ? CustomIcons.checkbox_checked_icon
                          : CustomIcons.checkbox_unchecked_icon,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _ratingTile(ProductRatingModel rating) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.smh),
      width: 330.smw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  rating.cari.image(height: 25.smw, width: 25.smw),
                  SizedBox(
                    width: 10.smw,
                  ),
                  CustomText(rating.cari.name)
                ],
              ),
              CustomText(rating.date.toString())
            ],
          ),
          SizedBox(height: 10.smh),
          RatingBarIndicator(
            rating: rating.ratingValue.toDouble(),
            itemBuilder: (context, index) => CustomIcons.star_selected,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 5.smw),
            itemSize: 15.smh,
            direction: Axis.horizontal,
          ),
          SizedBox(height: 10.smh),
          rating.contentValue != null
              ? Container(
                  decoration: BoxDecoration(
                    color: CustomColors.card,
                    borderRadius: CustomThemeData.fullInfiniteRounded,
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 10.smh, horizontal: 10.smw),
                  child: CustomText(rating.contentValue!.toString()),
                )
              : Container(),
        ],
      ),
    );
  }
}
