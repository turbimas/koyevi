import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_searchbar_view.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/login_page_widget.dart';
import 'package:koyevi/product/widgets/product_overview_view.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/main/favorites/favorites_view_model.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  late final ChangeNotifierProvider<FavoritesViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider<FavoritesViewModel>(
        (ref) => FavoritesViewModel());
    if (AuthService.isLoggedIn) {
      Future.delayed(Duration.zero, () {
        ref.read(provider).getFavorites();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar.inactiveBack(
            LocaleKeys.Favorites_appbar_title.tr(),
            showBasket: true),
        body: _body());
  }

  Widget _body() {
    if (!AuthService.isLoggedIn) {
      return const LoginPageWidget();
    }
    if (ref.watch(provider).isLoading) {
      return _loading();
    }
    if (ref.watch(provider).products == null) {
      return TryAgain(callBack: ref.read(provider).getFavorites);
    }
    if (ref.watch(provider).products!.isEmpty) {
      return _empty();
    }
    return _content();
  }

  Widget _loading() => Center(child: CustomImages.loading);

  Widget _empty() {
    return Center(
      child: SizedBox(
        height: 50.smh,
        width: 300.smw,
        child: Center(
          child: CustomTextLocale(LocaleKeys.Favorites_non_favorite,
              style: CustomFonts.bodyText1(CustomColors.backgroundText)),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 10.smh),
            child: CustomSearchBarView(
                onChanged: ref.read(provider).onChanged,
                hint: LocaleKeys.Favorites_search_hint.tr())),
        SizedBox(
          height: 600.smh,
          child: DynamicHeightGridView(
              shrinkWrap: true,
              mainAxisSpacing: 10.smh,
              crossAxisSpacing: 0.smw,
              builder: (context, index) => Center(
                    child: ProductOverviewVerticalView(
                        onFavoriteChanged: ref.read(provider).getFavorites,
                        onBackFromDetail: ref.read(provider).getFavorites,
                        product: ref.watch(provider).filteredProducts[index]),
                  ),
              itemCount: ref.watch(provider).filteredProducts.length,
              crossAxisCount: 2),
        ),
      ],
    );
  }
}
