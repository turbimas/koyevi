import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_theme_data.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/constants/app_constants.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/view/auth/login/login_view.dart';
import 'package:koyevi/view/user/user_addresses/user_addresses_view.dart';
import 'package:koyevi/view/user/user_orders/user_orders_view.dart';
import 'package:koyevi/view/user/user_profile/user_profile_view.dart';
import 'package:koyevi/view/user/user_promotions/promotions_view.dart';
import 'package:koyevi/view/user/user_questions/user_questions_view.dart';
import 'package:koyevi/view/user/user_ratings/user_ratings_view.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.inactiveBack(LocaleKeys.Profile_appbar_title.tr()),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _notificationRow(),
            _profilePhoto(),
            _greeting(),
            _options(),
            SizedBox(height: 85.smh)
          ],
        ),
      ),
    );
  }

  Widget _greeting() {
    return Container(
        margin: EdgeInsets.only(bottom: 10.smw),
        width: AppConstants.designWidth.smw,
        child: Center(
            child: CustomTextLocale(LocaleKeys.Profile_greeting,
                args: [AuthService.currentUser!.nameSurname],
                style: CustomFonts.bodyText1(CustomColors.backgroundText),
                maxLines: 2,
                textAlign: TextAlign.center)));
  }

  Widget _notificationRow() {
    return Padding(
      padding: EdgeInsets.only(left: 20.smw, right: 20.smw, top: 10.smh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              NavigationService.navigateToPage(const UserProfileView());
            },
            child: Container(
              constraints: BoxConstraints(minWidth: 185.smw, minHeight: 40.smh),
              decoration: BoxDecoration(
                  color: CustomColors.secondary,
                  borderRadius: CustomThemeData.fullInfiniteRounded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomIcons.edit_icon__medium,
                  CustomTextLocale(LocaleKeys.Profile_edit_profile,
                      style: CustomFonts.bodyText2(CustomColors.secondaryText))
                ],
              ),
            ),
          ),
          // Container(
          //   constraints: BoxConstraints(minWidth: 80.smw, minHeight: 40.smh),
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: CustomColors.secondary),
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         CustomText("0",
          //             style: CustomFonts.bodyText2(CustomColors.secondaryText)),
          //         CustomIcons.notification_icon
          //       ]),
          // )
        ],
      ),
    );
  }

  Widget _option(
      {required String title,
      required Widget page,
      required Widget icon,
      bool noBack = false}) {
    return InkWell(
      onTap: () {
        if (noBack) {
          AuthService.logout();
        } else {
          NavigationService.navigateToPage(page);
        }
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10.smh),
          padding: EdgeInsets.symmetric(vertical: 10.smh, horizontal: 20.smw),
          constraints: BoxConstraints(minHeight: 60.smh),
          width: 330.smw,
          decoration: BoxDecoration(
              color: CustomColors.card,
              borderRadius: CustomThemeData.fullRounded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon,
              SizedBox(width: 20.smw),
              CustomText(title,
                  style: CustomFonts.bodyText1(CustomColors.cardText))
            ],
          )),
    );
  }

  Widget _profilePhoto() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.smh, horizontal: 70.smw),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(220.smh),
          child: AuthService.userImage(height: 220.smw, width: 220.smw)),
    );
  }

  Widget _options() {
    return Column(
      children: [
        _option(
            title: LocaleKeys.Profile_orders.tr(),
            page: const UserOrdersView(),
            icon: CustomIcons.profile_delivery),
        //_option(
        //    title: LocaleKeys.Profile_promotions.tr(),
        //  page: const UserPromotionsView(),
        //icon: CustomIcons.profile_gift),
        _option(
            title: LocaleKeys.Profile_addresses.tr(),
            page: const UserAddressesView(),
            icon: CustomIcons.profile_address),
        // _option(
        //     title: LocaleKeys.Profile_saved_cards.tr(),
        //     path: NavigationConstants.userCards,
        //     icon: CustomIcons.profile_cards),
        _option(
            title: LocaleKeys.Profile_ratings.tr(),
            page: const UserRatingsView(),
            icon: CustomIcons.profile_ratings),
        _option(
            title: LocaleKeys.Profile_questions.tr(),
            page: const UserQuestionsView(),
            icon: CustomIcons.profile_questions),
        _option(
            title: LocaleKeys.Profile_logout.tr(),
            page: const LoginView(),
            icon: CustomIcons.profile_logout,
            noBack: true)
      ],
    );
  }
}
