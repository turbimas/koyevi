import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/theme/custom_colors.dart';
import 'package:koyevi/core/services/theme/custom_fonts.dart';
import 'package:koyevi/core/services/theme/custom_icons.dart';
import 'package:koyevi/core/services/theme/custom_images.dart';
import 'package:koyevi/core/utils/extensions/ui_extensions.dart';
import 'package:koyevi/product/models/user/address_model.dart';
import 'package:koyevi/product/widgets/custom_appbar.dart';
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/try_again_widget.dart';
import 'package:koyevi/view/user/user_address_add/user_address_add_view.dart';
import 'package:koyevi/view/user/user_addresses/user_addresses_view_model.dart';

class UserAddressesView extends ConsumerStatefulWidget {
  const UserAddressesView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAddressesViewState();
}

class _UserAddressesViewState extends ConsumerState<UserAddressesView> {
  late final ChangeNotifierProvider<UserAddressesViewModel> provider;

  @override
  void initState() {
    provider = ChangeNotifierProvider((ref) => UserAddressesViewModel());
    Future.delayed(Duration.zero, () {
      ref.read(provider).getAddresses();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        floatingActionButton: _fab(context),
        appBar:
            CustomAppBar.activeBack(LocaleKeys.UserAddresses_appbar_title.tr()),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return ref.watch(provider).isLoading
        ? _loading()
        : ref.watch(provider).addresses == null
            ? TryAgain(callBack: ref.read(provider).getAddresses)
            : ref.watch(provider).addresses!.isEmpty
                ? _empty()
                : _content();
  }

  Widget _loading() => Center(child: CustomImages.loading);

  Widget _content() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 15.smh, right: 15.smw, left: 15.smw, top: 25.smh),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
            ref.watch(provider).addresses!.map((e) => _addressTile(e)).toList(),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: CustomTextLocale(LocaleKeys.UserAddresses_no_address,
          style: CustomFonts.bodyText2(CustomColors.backgroundText)),
    );
  }

  InkWell _fab(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService.navigateToPage(const UserAddressAddView())
            .then((value) {
          ref.read(provider).getAddresses();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.smw, vertical: 10.smh),
        margin: EdgeInsets.only(right: 15.smw, bottom: 15.smh),
        height: 50.smh,
        width: 165.smw,
        decoration: BoxDecoration(
            color: CustomColors.primary,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomIcons.add_radiused_icon,
            CustomTextLocale(LocaleKeys.UserAddresses_add_address,
                style: CustomFonts.bodyText4(CustomColors.primaryText))
          ],
        ),
      ),
    );
  }

  Widget _addressTile(AddressModel address) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.smh, horizontal: 20.smw),
      margin: EdgeInsets.only(bottom: 10.smh),
      width: 330.smw,
      decoration: BoxDecoration(
          color: CustomColors.primary, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 5.smh),
              width: 240.smw,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(address.addressHeader,
                      style: CustomFonts.bodyText3(CustomColors.primaryText)),
                  CustomText(address.address,
                      style: CustomFonts.bodyText4(CustomColors.primaryText),
                      maxLines: 5)
                ],
              )),
          InkWell(
            onTap: () => ref.read(provider).deleteAddress(address.id),
            child: SizedBox(
              width: 50.smw,
              child: CustomIcons.garbage_icon_light,
            ),
          )
        ],
      ),
    );
  }
}
