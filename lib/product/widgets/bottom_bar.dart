import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/cubits/home_index_cubit/home_index_cubit.dart';

class BottomBar extends StatelessWidget {
  static const double iconSize = 25;
  static const int iconCount = 5;
  static const double startPixel = 30;

  static const _animationDuration = Duration(milliseconds: 100);

  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtil.defaultSize.width;

    double gapPixel =
        ((screenWidth - (2 * startPixel) - (iconCount * iconSize)) /
                (iconCount - 1)) -
            startPixel / iconCount;

    return Container(
        color: Colors.transparent,
        width: ScreenUtil.defaultSize.width.smw,
        height: 100.smh,
        child: Stack(
          children: [
            Positioned(
              // Container
              bottom: 0,
              child: Container(
                color: CustomColors.secondary,
                height: 75.smh,
                width: ScreenUtil.defaultSize.width.w,
              ),
            ),
            _iconContainer(
                context,
                0,
                startPixel + (gapPixel * 0) + (iconSize * 0),
                CustomIcons.menu_search_icon),
            _iconContainer(
                context,
                1,
                startPixel + (gapPixel * 1) + (iconSize * 1),
                CustomIcons.menu_favorite_icon),
            _iconContainer(
                context,
                2,
                startPixel + (gapPixel * 2) + (iconSize * 2),
                CustomIcons.menu_home_icon),
            _iconContainer(
                context,
                3,
                startPixel + (gapPixel * 3) + (iconSize * 3),
                CustomIcons.menu_basket_icon),
            _iconContainer(
                context,
                4,
                startPixel + (gapPixel * 4) + (iconSize * 4),
                CustomIcons.menu_profile_icon),
          ],
        ));
  }

  _iconContainer(
          BuildContext context, int index, double location, Widget icon) =>
      AnimatedPositioned(
        duration: _animationDuration,
        bottom: context.watch<HomeIndexCubit>().state.counter == index
            ? 50.smh
            : 15.smh,
        left: location.w,
        child: InkWell(
          onTap: () {
            context.read<HomeIndexCubit>().set(index);
          },
          child: AnimatedContainer(
              duration: _animationDuration,
              width: 50.smh,
              height: 50.smh,
              decoration: BoxDecoration(
                color: context.watch<HomeIndexCubit>().state.counter == index
                    ? CustomColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(child: icon)),
        ),
      );
}
