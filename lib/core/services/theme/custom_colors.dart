import 'package:flutter/material.dart';
import 'package:koyevi/core/services/theme/theme_manager.dart';

abstract class CustomColors {
  static late final Color primary;
  static late final Color secondary;
  static late final List<Color> background;

  static late final Color primaryText;
  static late final Color secondaryText;
  static late final Color backgroundText;
  static late final Color backgroundTextPale;
  static late final Color cancelText;
  static late final Color approveText;

  static late final Color cardText;
  static late final Color cardTextPale;

  static late final Color card2Text;
  static late final Color card2TextPale;

  static late final Color cardInnerText;
  static late final Color cardInnerTextPale;

  static late final Color card;
  static late final Color card2;
  static late final Color cardInner;

  static late final Color cancel;
  static late final Color approve;
  static late final Color disabled;

  static late final List<Color> paymentCard;

  static void loadColors() {
    primary =
        Color(int.parse(AppTheme.colorData["Basic"]['primary'], radix: 16));
    secondary =
        Color(int.parse(AppTheme.colorData["Basic"]['secondary'], radix: 16));
    background = [
      Color(int.parse(AppTheme.colorData["Basic"]['background'][0], radix: 16)),
      Color(int.parse(AppTheme.colorData["Basic"]['background'][1], radix: 16)),
    ];

    primaryText =
        Color(int.parse(AppTheme.colorData["Text"]['primaryText'], radix: 16));
    secondaryText = Color(
        int.parse(AppTheme.colorData["Text"]['secondaryText'], radix: 16));
    backgroundText = Color(
        int.parse(AppTheme.colorData["Text"]['backgroundText'], radix: 16));
    backgroundTextPale = Color(
        int.parse(AppTheme.colorData["Text"]['backgroundTextPale'], radix: 16));
    cancelText =
        Color(int.parse(AppTheme.colorData["Text"]['cancelText'], radix: 16));
    approveText =
        Color(int.parse(AppTheme.colorData["Text"]['approveText'], radix: 16));
    cardText =
        Color(int.parse(AppTheme.colorData["Text"]['cardText'], radix: 16));
    cardTextPale =
        Color(int.parse(AppTheme.colorData["Text"]['cardTextPale'], radix: 16));
    card2Text =
        Color(int.parse(AppTheme.colorData["Text"]['card2Text'], radix: 16));
    card2TextPale = Color(
        int.parse(AppTheme.colorData["Text"]['card2TextPale'], radix: 16));

    cardInnerText = Color(
        int.parse(AppTheme.colorData["Text"]['cardInnerText'], radix: 16));
    cardInnerTextPale = Color(
        int.parse(AppTheme.colorData["Text"]['cardInnerTextPale'], radix: 16));

    card = Color(int.parse(AppTheme.colorData["Widget"]['card'], radix: 16));
    card2 = Color(int.parse(AppTheme.colorData["Widget"]['card2'], radix: 16));
    cardInner =
        Color(int.parse(AppTheme.colorData["Widget"]['cardInner'], radix: 16));
    cancel =
        Color(int.parse(AppTheme.colorData["Widget"]['cancel'], radix: 16));
    approve =
        Color(int.parse(AppTheme.colorData["Widget"]['approve'], radix: 16));

    disabled =
        Color(int.parse(AppTheme.colorData["Widget"]['disabled'], radix: 16));

    paymentCard = [
      Color(
          int.parse(AppTheme.colorData["Widget"]['paymentCard'][0], radix: 16)),
      Color(
          int.parse(AppTheme.colorData["Widget"]['paymentCard'][1], radix: 16)),
    ];
  }
}
