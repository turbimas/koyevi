import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_searchbar_view.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/product_overview_view.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/main/search/search_view_model.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  late final ChangeNotifierProvider<SearchViewModel> provider;
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    provider =
        ChangeNotifierProvider<SearchViewModel>(((ref) => SearchViewModel()));
    Future.delayed(Duration.zero, () {
      ref.read(provider).getLastData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
      appBar: CustomAppBar.activeBack(LocaleKeys.Search_appbar_title.tr()),
      body: _body(),
    ));
  }

  Widget _body() {
    return ref.watch(provider).isLoading
        ? _loading()
        : ref.watch(provider).loaded
            ? _content()
            : TryAgain(callBack: () {});
  }

  Widget _loading() {
    return Center(
      child: CustomImages.loading,
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.smh, horizontal: 15.smw),
        child: Column(
          children: [
            CustomSearchBarView(
              hint: LocaleKeys.Search_appbar_title.tr(),
              controller: _searchController,
              onSubmit: ref.read(provider).search,
              autofocus: true,
            ),
            SizedBox(height: 10.smh),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextLocale(LocaleKeys.Search_last_searches,
                    style: CustomFonts.bodyText2(CustomColors.backgroundText)),
                InkWell(
                  onTap: ref.read(provider).deleteAllKeywords,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomIcons.garbage_icon_dark,
                      SizedBox(width: 5.smw),
                      CustomTextLocale(LocaleKeys.Search_clear_all,
                          style: CustomFonts.bodyText2(
                              CustomColors.backgroundText))
                    ],
                  ),
                )
              ],
            ),
            Divider(height: 10.smh, thickness: 1),
            ref.watch(provider).lastSearched.isNotEmpty
                ? Column(
                    children: List.generate(
                        ref.watch(provider).lastSearched.length,
                        (index) => InkWell(
                              onTap: () {
                                ref.read(provider).search(ref
                                    .watch(provider)
                                    .lastSearched[index]
                                    .contentValue);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5.smh),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.smw, vertical: 10.smh),
                                decoration: BoxDecoration(
                                    color: CustomColors.primary,
                                    borderRadius:
                                        CustomThemeData.fullInfiniteRounded),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                        ref
                                            .watch(provider)
                                            .lastSearched[index]
                                            .contentValue,
                                        style: CustomFonts.bodyText4(
                                            CustomColors.primaryText)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _searchController.text = ref
                                                .watch(provider)
                                                .lastSearched[index]
                                                .contentValue;
                                            _searchController.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset:
                                                            _searchController
                                                                .text.length));
                                          },
                                          child: CustomIcons.edit_icon__medium,
                                        ),
                                        SizedBox(width: 20.smw),
                                        InkWell(
                                            onTap: () {
                                              ref
                                                  .read(provider)
                                                  .searchKeywordDelete(ref
                                                      .watch(provider)
                                                      .lastSearched[index]
                                                      .id);
                                            },
                                            child:
                                                CustomIcons.garbage_icon_light),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 100.smh,
                    child: Center(
                      child: CustomTextLocale(LocaleKeys.Search_no_searched,
                          style: CustomFonts.bodyText1(
                              CustomColors.backgroundText)),
                    ),
                  ),
            Align(
                alignment: Alignment.centerLeft,
                child: CustomTextLocale(LocaleKeys.Search_last_seen,
                    style: CustomFonts.bodyText2(CustomColors.backgroundText))),
            ref.watch(provider).lastViewed.isNotEmpty
                ? Column(
                    children: List.generate(
                        ref.watch(provider).lastViewed.length,
                        (index) => Container(
                              margin: EdgeInsets.symmetric(vertical: 5.smh),
                              child: ProductOverViewHorizontalView(
                                  product: ref
                                      .watch(provider)
                                      .lastViewed[index]
                                      .product),
                            )),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 100.smh,
                    child: Center(
                      child: CustomTextLocale(LocaleKeys.Search_no_last_seen,
                          style: CustomFonts.bodyText1(
                              CustomColors.backgroundText)),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
