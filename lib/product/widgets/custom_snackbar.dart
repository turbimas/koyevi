import 'package:flutter/material.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';

class CustomSnackBar extends StatelessWidget {
  final String text;
  final bool error;
  const CustomSnackBar({super.key, required this.text, this.error = false});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
        content: Text(text,
            style: CustomFonts.bodyText4(
                error ? CustomColors.cancelText : CustomColors.primaryText)),
        backgroundColor: error ? CustomColors.cancel : CustomColors.primary);
  }
}
