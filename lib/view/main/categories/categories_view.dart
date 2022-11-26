import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/models/category_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_searchbar_view.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/view/main/categories/categories_view_model.dart';
import 'package:koyevi/view/main/search/search_view.dart';
import 'package:koyevi/view/main/sub_categories/sub_categories_view.dart';

class CategoriesView extends ConsumerStatefulWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CategoriesState();
}

class CategoriesState extends ConsumerState<CategoriesView> {
  late final ChangeNotifierProvider<CategoriesViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => CategoriesViewModel());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar.inactiveBack(LocaleKeys.Categories_appbar_title.tr()),
      body: Padding(
        padding: EdgeInsets.only(
            top: 10.smh, left: 15.smw, right: 15.smw, bottom: 75.smh),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
                onTap: () =>
                    NavigationService.navigateToPage(const SearchView()),
                child: AbsorbPointer(
                    child: CustomSearchBarView(
                        hint: LocaleKeys.Categories_search_hint.tr()))),
            SizedBox(height: 15.smh),
            FutureBuilder<List<CategoryModel>?>(
              future: ref.read(provider).getCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _categories(snapshot.data!);
                } else {
                  return Container(
                      padding: EdgeInsets.only(top: 300.smh),
                      child: const Center(child: CircularProgressIndicator()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _categories(List<CategoryModel> categories) {
    List<CategoryModel> ordered = categories
        .where((element) => element.siraNo != null)
        .toList()
      ..sort((a, b) => a.siraNo!.compareTo(b.siraNo!));

    ordered.addAll(categories.where((element) => element.siraNo == null));
    return Expanded(
      child: Scrollbar(
        trackVisibility: true,
        radius: const Radius.circular(45),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.8,
            crossAxisCount: 2,
            crossAxisSpacing: 30.w,
            mainAxisSpacing: 20.h,
          ),
          itemCount: ordered.length,
          itemBuilder: (context, index) {
            CategoryModel category = ordered[index];
            return InkWell(
                onTap: () => _onCategoryTap(category, categories),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: CustomThemeData.fullRounded,
                        child: category.image(
                          height: 150.smh,
                          width: 150.smh,
                        )),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: CustomText(
                        category.groupName,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style:
                            CustomFonts.bodyText4(CustomColors.backgroundText),
                      ),
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }

  _onCategoryTap(CategoryModel category, List<CategoryModel> categories) {
    NavigationService.navigateToPage(SubCategoriesView(
      masterCategories: categories,
      masterCategory: category,
    ));
  }
}
