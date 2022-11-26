import 'package:flutter/material.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';

class CustomSafeArea extends StatelessWidget {
  final Widget child;
  const CustomSafeArea({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.primary,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: CustomColors.background,
                    ),
                  ),
                  child: child),
            ),
          ],
        ),
      ),
    );
  }
}
