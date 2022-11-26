// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:koyevi/core/services/theme/theme_manager.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';

abstract class CustomIcons {
  static late final Widget menu_search_icon;
  static late final Widget menu_favorite_icon;
  static late final Widget menu_home_icon;
  static late final Widget menu_basket_icon;
  static late final Widget menu_profile_icon;
  static late final Widget cancel_icon__medium;
  static late final Widget cancel_icon__large;
  static late final Widget check_icon;
  static late final Widget favorite_circle_icon;
  static late final Widget non_favorite_circle_icon;
  static late final Widget add_icon;
  static late final Widget minus_icon;
  static late final Widget add_basket_outlined_icon;
  static late final Widget add_basket_icon;
  static late final Widget edit_icon__small;
  static late final Widget edit_icon__medium;
  static late final Widget back_icon_light;
  static late final Widget back_icon_dark;
  static late final Widget forward_icon_light;
  static late final Widget forward_icon_dark;
  static late final Widget radio_checked_light_icon;
  static late final Widget radio_unchecked_light_icon;
  static late final Widget radio_checked_dark_icon;
  static late final Widget radio_unchecked_dark_icon;
  static late final Widget checkbox_checked_icon;
  static late final Widget checkbox_unchecked_icon;
  static late final Widget add_radiused_icon;
  static late final Widget enter_icon;
  static late final Widget credit_card_icon_dark;
  static late final Widget credit_card_icon_light;
  static late final Widget search_icon;
  static late final Widget field_profile_icon;
  static late final Widget field_phone_icon;
  static late final Widget field_mail_icon;
  static late final Widget field_password_icon;
  static late final Widget field_hide_password;
  static late final Widget arrow_right_circle_icon;
  static late final Widget answer_icon;
  static late final Widget success_icon_big;
  static late final Widget questions_icon;
  static late final Widget clipboard_icon;
  static late final Widget profile_delivery;
  static late final Widget profile_gift;
  static late final Widget profile_address;
  static late final Widget profile_cards;
  static late final Widget profile_ratings;
  static late final Widget profile_questions;
  static late final Widget profile_logout;
  static late final Widget notification_icon;
  static late final Widget evaluations;
  static late final Widget questions;
  static late final Widget star_selected;
  static late final Widget start_unselected;
  static late final Widget star_white;
  static late final Widget order_icon;
  static late final Widget filter_icon;
  static late final Widget categories_icon;
  static late final Widget order_done_icon;
  static late final Widget star_chip_icon;
  static late final Widget garbage_icon_dark;
  static late final Widget garbage_icon_light;

  static void loadIcons() {
    menu_search_icon = _svgPicture("menu_search_icon");
    menu_favorite_icon = _svgPicture("menu_favorite_icon");
    menu_home_icon = _svgPicture("menu_home_icon");
    menu_basket_icon = _svgPicture("menu_basket_icon");
    menu_profile_icon = _svgPicture("menu_profile_icon");
    cancel_icon__medium = _svgPicture("cancel_icon__medium");
    cancel_icon__large = _svgPicture("cancel_icon__large");
    check_icon = _svgPicture("check_icon");
    favorite_circle_icon = _svgPicture("favorite_circle_icon");
    non_favorite_circle_icon = _svgPicture("non_favorite_circle_icon");
    add_icon = _svgPicture("add_icon");
    minus_icon = _svgPicture("minus_icon");
    add_basket_outlined_icon = _svgPicture("add_basket_outlined_icon");
    add_basket_icon = _svgPicture("add_basket_icon");
    edit_icon__small = _svgPicture("edit_icon__small");
    edit_icon__medium = _svgPicture("edit_icon__medium");
    back_icon_light = _svgPicture("back_icon_light");
    back_icon_dark = _svgPicture("back_icon_dark");
    forward_icon_light = _svgPicture("forward_icon_light");
    forward_icon_dark = _svgPicture("forward_icon_dark");
    radio_checked_light_icon = _svgPicture("radio_checked_light_icon");
    radio_unchecked_light_icon = _svgPicture("radio_unchecked_light_icon");
    radio_checked_dark_icon = _svgPicture("radio_checked_dark_icon");
    radio_unchecked_dark_icon = _svgPicture("radio_unchecked_dark_icon");
    checkbox_checked_icon = _svgPicture("checkbox_checked_icon");
    checkbox_unchecked_icon = _svgPicture("checkbox_unchecked_icon");
    add_radiused_icon = _svgPicture("add_radiused_icon");
    enter_icon = _svgPicture("enter_icon");
    credit_card_icon_dark = _svgPicture("credit_card_icon_dark");
    credit_card_icon_light = _svgPicture("credit_card_icon_light");
    search_icon = _svgPicture("search_icon");
    field_profile_icon = _svgPicture("field_profile_icon");
    field_phone_icon = _svgPicture("field_phone_icon");
    field_mail_icon = _svgPicture("field_mail_icon");
    field_password_icon = _svgPicture("field_password_icon");
    field_hide_password = _svgPicture("field_hide_password");
    arrow_right_circle_icon = _svgPicture("arrow_right_circle_icon");
    answer_icon = _svgPicture("answer_icon");
    success_icon_big = _svgPicture("success_icon_big");
    questions_icon = _svgPicture("questions_icon");
    clipboard_icon = _svgPicture("clipboard_icon");
    profile_delivery = _svgPicture("profile_delivery");
    profile_gift = _svgPicture("profile_gift");
    profile_address = _svgPicture("profile_address");
    profile_cards = _svgPicture("profile_cards");
    profile_ratings = _svgPicture("profile_ratings");
    profile_questions = _svgPicture("profile_questions");
    profile_logout = _svgPicture("profile_logout");
    notification_icon = _svgPicture("notification_icon");
    evaluations = _svgPicture("evaluations");
    questions = _svgPicture("questions");
    star_selected = _svgPicture("star_selected");
    start_unselected = _svgPicture("start_unselected");
    star_white = _svgPicture("star_white");
    order_icon = _svgPicture("order_icon");
    filter_icon = _svgPicture("filter_icon");
    categories_icon = _svgPicture("categories_icon");
    order_done_icon = _svgPicture("order_done_icon");
    star_chip_icon = _svgPicture("star_chip_icon");
    garbage_icon_dark = _svgPicture("garbage_icon_dark");
    garbage_icon_light = _svgPicture("garbage_icon_light");
  }

  // static SvgPicture? _;
  // static Widget get _ => _ ??= _svgPicture("");

  static Widget _svgPicture(
    String assetName,
  ) {
    Map<String, dynamic> iconData = AppTheme.iconData[assetName];
    int? size = iconData['size'];
    int? width = iconData['width'];
    int? height = iconData['height'];
    String path = iconData['path'];

    if (size == null && height != null && width != null) {
      return SizedBox(
          height: height.smh,
          width: width.smw,
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SvgPicture.asset(path,
                  height: height.smh, width: width.smw)));
    } else if (size != null) {
      return SizedBox(
          height: size.smh,
          width: size.smh,
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child:
                  SvgPicture.asset(path, height: size.smh, width: size.smh)));
    } else {
      throw Exception("Wrong size info");
    }
  }
}
