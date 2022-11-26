// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String data;
  TextStyle? style;
  int maxLines;
  // double? minFontSize;
  TextAlign textAlign;
  CustomText(this.data,
      {super.key,
      this.style,
      // this.minFontSize,
      this.maxLines = 1,
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textScaleFactor: 1.0,
      style: style,
      overflow: TextOverflow.ellipsis,
      // minFontSize: minFontSize == null
      //     ? (style != null ? style!.fontSize ?? 10.sp : 10.sp)
      //     : minFontSize!,
      // stepGranularity: 1.sp,
      softWrap: true,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class CustomTextLocale extends StatelessWidget {
  String data;
  List<String> args;
  TextStyle? style;
  int maxLines;
  // double? minFontSize;
  TextAlign textAlign;
  CustomTextLocale(this.data,
      {super.key,
      this.args = const [],
      this.style,
      // this.minFontSize,
      this.maxLines = 1,
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      data.tr(args: args),
      textScaleFactor: 1.0,
      style: style,
      // minFontSize: minFontSize == null
      //     ? (style != null ? style!.fontSize ?? 10.sp : 10.sp)
      //     : minFontSize!,
      // stepGranularity: 2.sp,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
