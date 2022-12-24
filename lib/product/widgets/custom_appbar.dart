import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/cubits/basket_model_cubit/basket_model_cubit.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';
import 'package:koyevi/product/models/order/basket_model.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/main/main_view.dart';

class CustomAppBar {
  static PreferredSize activeBack(String title, {bool showBasket = false}) =>
      PreferredSize(
        preferredSize: Size.fromHeight(50.smh),
        child: AppBar(
          backgroundColor: CustomColors.primary,
          title: showBasket
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () =>
                            Navigator.pop(NavigationService.context)),
                    CustomText(title, style: CustomFonts.appBar),
                    showBasket ? const _BasketTotalIcon() : const SizedBox()
                  ],
                )
              : CustomText(title, style: CustomFonts.appBar),
          centerTitle: showBasket ? false : true,
          automaticallyImplyLeading: !showBasket,
          leading: !showBasket
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(NavigationService.context))
              : null,
        ),
      );

  static PreferredSize inactiveBack(String title, {bool showBasket = false}) =>
      PreferredSize(
        preferredSize: Size.fromHeight(50.smh),
        child: AppBar(
          titleSpacing: 0,
          backgroundColor: CustomColors.primary,
          title: SizedBox(
            width: AppConstants.designWidth.smw,
            height: 50.smh,
            child: showBasket
                ? Stack(children: [
                    Positioned.fill(
                        child: Center(
                            child:
                                CustomText(title, style: CustomFonts.appBar))),
                    Positioned(
                        right: 10.smw,
                        top: 5.smh,
                        child: const _BasketTotalIcon())
                  ])
                : Center(child: CustomText(title, style: CustomFonts.appBar)),
          ),
          centerTitle: true,
          leading: null,
        ),
      );
}

class _BasketTotalIcon extends StatefulWidget {
  const _BasketTotalIcon();

  @override
  State<_BasketTotalIcon> createState() => __BasketTotalIconState();
}

class __BasketTotalIconState extends State<_BasketTotalIcon> {
  @override
  Widget build(BuildContext context) {
    if (!AuthService.isLoggedIn) {
      return const SizedBox();
    }
    BasketModel? basketModel =
        context.watch<BasketModelCubit>().state.basketModel;
    if (basketModel == null) {
      return const SizedBox();
    }

    if (basketModel.generalTotals == 0) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () {
        NavigationService.navigateToPageAndRemoveUntil(const MainView());
        context.read<HomeIndexCubit>().set(3);
      },
      child: Container(
        margin: EdgeInsets.only(left: 5.smw),
        height: 40.smh,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 5,
                  blurStyle: BlurStyle.outer)
            ],
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            CustomIcons.menu_basket_icon__medium,
            SizedBox(width: 5.smw),
            CustomText(basketModel.generalTotals.toStringAsFixed(2),
                style: CustomFonts.bodyText5(CustomColors.primaryText))
          ],
        ),
      ),
    );
  }
}
