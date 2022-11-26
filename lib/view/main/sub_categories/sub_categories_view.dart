import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/models/category_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';
import 'package:koyevi/view/main/sub_categories/sub_categories_view_model.dart';

class SubCategoriesView extends ConsumerStatefulWidget {
  final CategoryModel? masterCategory;
  final List<CategoryModel>? masterCategories;
  const SubCategoriesView(
      {Key? key, this.masterCategory, this.masterCategories})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SubCategoriesViewState();
}

class _SubCategoriesViewState extends ConsumerState<SubCategoriesView> {
  late final ChangeNotifierProvider<SubCategoriesViewModel> provider;
  late final ScrollController _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController = ScrollController();

    provider = ChangeNotifierProvider((ref) => SubCategoriesViewModel(
        masterCategory: widget.masterCategory,
        masterCategories: widget.masterCategories,
        scrollController: _scrollController));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
        child: Scaffold(
            appBar: CustomAppBar.activeBack(
                LocaleKeys.Subcategories_appbar_title.tr()),
            body: ref.watch(provider).retrieving ? _loading() : _body()));
  }

  Widget _body() {
    return Stack(
      children: [
        Positioned(
            top: 0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              margin: EdgeInsets.only(bottom: 50.smh),
              child: ListView.custom(
                  controller: _scrollController,
                  childrenDelegate: SliverChildListDelegate([
                    _masterCategories(),
                    ...ref
                        .watch(provider)
                        .subCategories
                        .map((e) => _subCategories(e))
                        .toList()
                  ])),
            )),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          top: 700.smh,
          child: OkCancelPrompt(
              okCallBack: ref.read(provider).approve,
              cancelCallBack: ref.read(provider).cancel),
        )
      ],
    );
  }

  Widget _loading() {
    return Center(child: CustomImages.loading);
  }

  Widget _masterCategories() {
    return Container(
      color: CustomColors.card,
      margin: EdgeInsets.only(top: 10.smh),
      padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
      width: AppConstants.designWidth.smw,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ref.watch(provider).masterCategories!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.5,
              crossAxisSpacing: 10.smw,
              mainAxisSpacing: 10.smh),
          itemBuilder: (context, index) {
            CategoryModel category =
                ref.watch(provider).masterCategories![index];
            bool isSelected =
                ref.watch(provider).selectedCategories.contains(category);
            return InkWell(
              onTap: () => ref.read(provider).getSubCategories(category),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: isSelected
                              ? CustomColors.primary
                              : Colors.transparent,
                          width: 2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected
                                  ? CustomColors.primary
                                  : Colors.transparent,
                              width: 3),
                          borderRadius: CustomThemeData.fullRounded),
                      child: ClipRRect(
                        borderRadius: CustomThemeData.fullRounded,
                        child: category.image(height: 60.smh, width: 60.smh),
                      ),
                    ),
                    SizedBox(height: 10.smh),
                    Expanded(
                      child: CustomText(
                        category.groupName,
                        style: CustomFonts.bodyText4(CustomColors.cardText),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _subCategories(List<CategoryModel> categories) {
    if (categories.isEmpty) return Container();
    return Container(
      margin: EdgeInsets.only(top: 10.smh),
      padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
      color: CustomColors.card,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ref
              .watch(provider)
              .subCategories[
                  ref.watch(provider).subCategories.indexOf(categories)]
              .length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10.smw,
              mainAxisSpacing: 10.smh),
          itemBuilder: (context, index) {
            CategoryModel category = categories[index];
            bool isSelected = ref
                .watch(provider)
                .selectedCategories
                .any((element) => element.id == category.id);
            return InkWell(
              onTap: () => ref.read(provider).getSubCategories(category),
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: isSelected
                        ? CustomThemeData.shadow1
                        : CustomThemeData.shadow3,
                    color: isSelected
                        ? CustomColors.primary
                        : CustomColors.cardInner,
                    borderRadius: CustomThemeData.fullRounded,
                  ),
                  child: Center(
                      child: CustomText(category.groupName,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: CustomFonts.bodyText4(isSelected
                              ? CustomColors.primaryText
                              : CustomColors.cardInnerText)))),
            );
          }),
    );
  }
}
