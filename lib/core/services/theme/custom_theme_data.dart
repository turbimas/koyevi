import 'package:flutter/material.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';

abstract class CustomThemeData {
  static double roundness = 15;
  static BorderRadius get fullInfiniteRounded => BorderRadius.circular(9999);
  static BorderRadius get leftInfiniteRounded => const BorderRadius.only(
        topLeft: Radius.circular(9999),
        bottomLeft: Radius.circular(9999),
      );
  static BorderRadius get rightInfiniteRounded => const BorderRadius.only(
        topRight: Radius.circular(9999),
        bottomRight: Radius.circular(9999),
      );
  static BorderRadius get topInfiniteRounded => const BorderRadius.only(
        topLeft: Radius.circular(9999),
        topRight: Radius.circular(9999),
      );
  static BorderRadius get bottomInfiniteRounded => const BorderRadius.only(
        bottomLeft: Radius.circular(9999),
        bottomRight: Radius.circular(9999),
      );

  static BorderRadius get fullRounded => BorderRadius.circular(roundness);
  static BorderRadius get leftRounded => BorderRadius.only(
        topLeft: Radius.circular(roundness),
        bottomLeft: Radius.circular(roundness),
      );
  static BorderRadius get rightRounded => BorderRadius.only(
        topRight: Radius.circular(roundness),
        bottomRight: Radius.circular(roundness),
      );
  static BorderRadius get topRounded => BorderRadius.only(
        topLeft: Radius.circular(roundness),
        topRight: Radius.circular(roundness),
      );
  static BorderRadius get bottomRounded => BorderRadius.only(
        bottomLeft: Radius.circular(roundness),
        bottomRight: Radius.circular(roundness),
      );

  static List<BoxShadow> get shadow1 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.75),
          blurRadius: 15,
          offset: Offset(0, 5.smh),
        ),
      ];
  static List<BoxShadow> get shadow2 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.50),
          blurRadius: 10,
          offset: Offset(0, 5.smh),
        ),
      ];
  static List<BoxShadow> get shadow3 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 5,
          offset: Offset(0, 5.smh),
        ),
      ];

  static const animationDurationLong = Duration(milliseconds: 500);
  static const animationDurationMedium = Duration(milliseconds: 300);
  static const animationDurationShort = Duration(milliseconds: 150);
}
