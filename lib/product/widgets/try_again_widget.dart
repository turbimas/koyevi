// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/widgets/custom_text.dart';

class TryAgain extends StatelessWidget {
  final void Function() callBack;
  const TryAgain({required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: callBack,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.primary),
            borderRadius: CustomThemeData.fullInfiniteRounded,
          ),
          height: 50.smh,
          width: 300.smw,
          child: Center(
            child: CustomTextLocale(
              LocaleKeys.TryAgainWidget_try_again,
              style: CustomFonts.bigButton(CustomColors.backgroundText),
            ),
          ),
        ),
      ),
    );
  }
}
