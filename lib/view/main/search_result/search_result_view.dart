// ignore_for_file: must_be_immutable

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/product/models/category_model.dart';
import 'package:koyevi/product/models/product_over_view_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_searchbar_view.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';
import 'package:koyevi/product/widgets/product_overview_view.dart';
import 'package:koyevi/view/main/search_result/search_result_view_model.dart';
import 'package:koyevi/view/main/sub_categories/sub_categories_view.dart';

class SearchResultView extends ConsumerStatefulWidget {
  CategoryModel? categoryModel;
  List<CategoryModel>? masterCategories;
  String? searchText;
  List<ProductOverViewModel> products;
  bool isSearch;
  SearchResultView(
      {Key? key,
      this.categoryModel,
      this.masterCategories,
      this.searchText,
      required this.isSearch,
      required this.products})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchResultViewState();
}

class _SearchResultViewState extends ConsumerState<SearchResultView> {
  late final ChangeNotifierProvider<SearchResultViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => SearchResultViewModel(
        products: widget.products,
        categoryModel: widget.categoryModel,
        searchText: widget.searchText));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      appBar:
          CustomAppBar.activeBack(LocaleKeys.SearchResult_appbar_title.tr()),
      body: Column(
        children: [_actions(), _products(), _mainMenu()],
      ),
    ));
  }

  Widget _actions() {
    return Container(
      height: 110.smh,
      margin: EdgeInsets.symmetric(vertical: 10.smh, horizontal: 15.smw),
      child: Column(
        children: [
          AbsorbPointer(
            absorbing: ref.watch(provider).products.isEmpty,
            child: Row(
              children: [
                _order(),
                SizedBox(width: 10.smw),
                _filter(),
                SizedBox(width: 10.smw),
                _categories()
              ],
            ),
          ),
          SizedBox(height: 10.smh),
          CustomSearchBarView(
            hint: LocaleKeys.SearchResult_search.tr(),
            onChanged: ref.read(provider).filterByName,
          )
        ],
      ),
    );
  }

  InkWell _categories() {
    return InkWell(
      onTap: () {
        if (widget.categoryModel != null) {
          NavigationService.navigateToPage(SubCategoriesView(
            masterCategory: widget.categoryModel,
            masterCategories: widget.masterCategories,
          ));
        } else {
          NavigationService.navigateToPage(const SubCategoriesView());
        }
      },
      child: Container(
        width: 130.smw,
        height: 50.smh,
        decoration: BoxDecoration(
            color: CustomColors.secondary,
            borderRadius: CustomThemeData.fullRounded),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIcons.categories_icon,
            CustomTextLocale(
              LocaleKeys.SearchResult_change_category,
              maxLines: 1,
              style: CustomFonts.bodyText4(CustomColors.secondaryText),
            )
          ],
        ),
      ),
    );
  }

  Widget _filter() {
    return InkWell(
      onTap: _showFilterPopup,
      child: Container(
        width: 90.smw,
        height: 50.smh,
        decoration: BoxDecoration(
            color: CustomColors.secondary,
            borderRadius: CustomThemeData.fullRounded),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIcons.filter_icon,
            CustomTextLocale(
              LocaleKeys.SearchResult_filter,
              maxLines: 1,
              style: CustomFonts.bodyText4(CustomColors.secondaryText),
            )
          ],
        ),
      ),
    );
  }

  Widget _order() {
    return InkWell(
      onTap: _showOrderPopup,
      child: Container(
        width: 90.smw,
        height: 50.smh,
        decoration: BoxDecoration(
            color: CustomColors.secondary,
            borderRadius: CustomThemeData.fullRounded),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIcons.order_icon,
            CustomTextLocale(
              LocaleKeys.SearchResult_order,
              maxLines: 1,
              style: CustomFonts.bodyText4(CustomColors.secondaryText),
            )
          ],
        ),
      ),
    );
  }

  Widget _products() {
    if (ref.watch(provider).filteredProducts.isEmpty) {
      return SizedBox(
        height: 535.smh,
        child: Center(
            child: CustomTextLocale(LocaleKeys.SearchResult_not_found,
                maxLines: 2,
                style: CustomFonts.bodyText2(CustomColors.backgroundText))),
      );
    } else {
      return SizedBox(
        height: 535.smh,
        child: DynamicHeightGridView(
            shrinkWrap: true,
            mainAxisSpacing: 10.smh,
            crossAxisSpacing: 0.smw,
            builder: (context, index) => Center(
                  child: ProductOverviewVerticalView(
                      product: ref.watch(provider).filteredProducts[index]),
                ),
            itemCount: ref.watch(provider).filteredProducts.length,
            crossAxisCount: 2),
      );
    }
  }

  void _showFilterPopup() {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, child) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 0.smw),
              backgroundColor: Colors.transparent,
              child: Container(
                width: 330.smw,
                height: 500.smh,
                decoration: BoxDecoration(
                    borderRadius: CustomThemeData.fullRounded,
                    color: CustomColors.primary),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.smh),
                      padding: EdgeInsets.symmetric(horizontal: 30.smw),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomTextLocale(
                            LocaleKeys.SearchResult_filter,
                            style:
                                CustomFonts.bodyText1(CustomColors.primaryText),
                          )),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void _showOrderPopup() {
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(
            builder: (context, ref, child) {
              return Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 0.smw),
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 330.smw,
                  height: 330.smh,
                  decoration: BoxDecoration(
                      borderRadius: CustomThemeData.fullRounded,
                      color: CustomColors.primary),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.smh),
                            padding: EdgeInsets.symmetric(horizontal: 30.smw),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomTextLocale(
                                  LocaleKeys.SearchResult_order,
                                  style: CustomFonts.bodyText1(
                                      CustomColors.primaryText),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              ref.read(provider).orderPrice = true;
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: 5.smh),
                                padding: EdgeInsets.symmetric(vertical: 10.smh),
                                width: 300,
                                decoration: BoxDecoration(
                                    color: CustomColors.secondary,
                                    borderRadius:
                                        CustomThemeData.fullInfiniteRounded),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                              child: ref
                                                          .watch(provider)
                                                          .orderPrice ==
                                                      true
                                                  ? CustomIcons
                                                      .radio_checked_light_icon
                                                  : CustomIcons
                                                      .radio_unchecked_light_icon)),
                                      Expanded(
                                          flex: 5,
                                          child: CustomTextLocale(
                                            LocaleKeys
                                                .SearchResult_price_low_high,
                                            style: CustomFonts.bodyText4(
                                                CustomColors.secondaryText),
                                          ))
                                    ])),
                          ),
                          InkWell(
                            onTap: () {
                              ref.read(provider).orderPrice = false;
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: 5.smh),
                                padding: EdgeInsets.symmetric(vertical: 10.smh),
                                width: 300,
                                decoration: BoxDecoration(
                                    color: CustomColors.secondary,
                                    borderRadius:
                                        CustomThemeData.fullInfiniteRounded),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                              child: ref
                                                          .watch(provider)
                                                          .orderPrice ==
                                                      false
                                                  ? CustomIcons
                                                      .radio_checked_light_icon
                                                  : CustomIcons
                                                      .radio_unchecked_light_icon)),
                                      Expanded(
                                          flex: 5,
                                          child: CustomTextLocale(
                                            LocaleKeys
                                                .SearchResult_price_high_low,
                                            style: CustomFonts.bodyText4(
                                                CustomColors.secondaryText),
                                          ))
                                    ])),
                          ),
                          InkWell(
                            onTap: () {
                              ref.read(provider).orderName = true;
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: 5.smh),
                                padding: EdgeInsets.symmetric(vertical: 10.smh),
                                width: 300,
                                decoration: BoxDecoration(
                                    color: CustomColors.secondary,
                                    borderRadius:
                                        CustomThemeData.fullInfiniteRounded),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                              child: ref
                                                          .watch(provider)
                                                          .orderName ==
                                                      true
                                                  ? CustomIcons
                                                      .radio_checked_light_icon
                                                  : CustomIcons
                                                      .radio_unchecked_light_icon)),
                                      Expanded(
                                          flex: 5,
                                          child: CustomTextLocale(
                                            LocaleKeys.SearchResult_name_a_z,
                                            style: CustomFonts.bodyText4(
                                                CustomColors.secondaryText),
                                          ))
                                    ])),
                          ),
                          InkWell(
                            onTap: () {
                              ref.read(provider).orderName = false;
                            },
                            child: Container(
                                margin: EdgeInsets.only(bottom: 5.smh),
                                padding: EdgeInsets.symmetric(vertical: 10.smh),
                                width: 300,
                                decoration: BoxDecoration(
                                    color: CustomColors.secondary,
                                    borderRadius:
                                        CustomThemeData.fullInfiniteRounded),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                              child: ref
                                                          .watch(provider)
                                                          .orderName ==
                                                      false
                                                  ? CustomIcons
                                                      .radio_checked_light_icon
                                                  : CustomIcons
                                                      .radio_unchecked_light_icon)),
                                      Expanded(
                                          flex: 5,
                                          child: CustomTextLocale(
                                            LocaleKeys.SearchResult_name_z_a,
                                            style: CustomFonts.bodyText4(
                                                CustomColors.secondaryText),
                                          ))
                                    ])),
                          ),
                        ],
                      ),
                      OkCancelPrompt.forPopup(
                          okCallBack: ref.read(provider).order,
                          cancelCallBack: () {
                            NavigationService.back();
                          }),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _mainMenu() {
    return Container(
      height: 75.smh,
      margin: EdgeInsets.only(top: 10.smh),
      color: CustomColors.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
              onTap: () {
                context.read<HomeIndexCubit>().set(0);
                NavigationService.navigateToPageAndRemoveUntil(
                    const MainView());
              },
              child: CustomIcons.menu_search_icon),
          InkWell(
              onTap: () {
                context.read<HomeIndexCubit>().set(1);
                NavigationService.navigateToPageAndRemoveUntil(
                    const MainView());
              },
              child: CustomIcons.menu_favorite_icon),
          InkWell(
              onTap: () {
                context.read<HomeIndexCubit>().set(2);
                NavigationService.navigateToPageAndRemoveUntil(
                    const MainView());
              },
              child: CustomIcons.menu_home_icon),
          InkWell(
              onTap: () {
                context.read<HomeIndexCubit>().set(3);
                NavigationService.navigateToPageAndRemoveUntil(
                    const MainView());
              },
              child: CustomIcons.menu_basket_icon),
          InkWell(
              onTap: () {
                context.read<HomeIndexCubit>().set(4);
                NavigationService.navigateToPageAndRemoveUntil(
                    const MainView());
              },
              child: CustomIcons.menu_profile_icon)
        ],
      ),
    );
  }

  void addSearchWidget() {}
}
