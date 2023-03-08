import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:koyevi/product/widgets/custom_safearea.dart';
import 'package:koyevi/product/widgets/custom_text.dart';
import 'package:koyevi/product/widgets/ok_cancel_prompt.dart';
import 'package:koyevi/view/user/user_address_add/user_address_add_view_model.dart';

class UserAddressAddView extends ConsumerStatefulWidget {
  const UserAddressAddView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAddressAddViewState();
}

class _UserAddressAddViewState extends ConsumerState<UserAddressAddView> {
  late final ChangeNotifierProvider<UserAddressAddViewModel> provider;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> invoiceFormKey = GlobalKey<FormState>();

  late final TextEditingController addressHeaderController;
  late final TextEditingController buildingNoController;
  late final TextEditingController buildingNameController;
  late final TextEditingController floorNoController;
  late final TextEditingController doorNoController;
  late final TextEditingController relatedMailController;
  late final TextEditingController relatedPhoneController;
  late final TextEditingController noteController;

  late final TextEditingController relatedPersonNameController;
  late final TextEditingController identityNoController;
  late final TextEditingController taxOfficeController;
  late final TextEditingController taxNoController;

  @override
  void initState() {
    addressHeaderController = TextEditingController();
    buildingNoController = TextEditingController();
    buildingNameController = TextEditingController();
    floorNoController = TextEditingController();
    doorNoController = TextEditingController();
    relatedMailController = TextEditingController();
    relatedPhoneController =
        TextEditingController(text: AuthService.currentUser!.phone);
    noteController = TextEditingController();

    relatedPersonNameController = TextEditingController();
    identityNoController = TextEditingController();
    taxOfficeController = TextEditingController();
    taxNoController = TextEditingController();

    provider = ChangeNotifierProvider((ref) =>
        UserAddressAddViewModel(buildingNoController: buildingNoController));
    Future.delayed(Duration.zero, () {
      ref.read(provider).goCurrentLocation();
    });

    super.initState();
  }

  @override
  void dispose() {
    addressHeaderController.dispose();
    buildingNameController.dispose();
    floorNoController.dispose();
    doorNoController.dispose();
    relatedMailController.dispose();
    relatedPhoneController.dispose();
    noteController.dispose();

    relatedPersonNameController.dispose();
    identityNoController.dispose();
    taxOfficeController.dispose();
    taxNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar: CustomAppBar.activeBack(
            LocaleKeys.UserAddressAdd_appbar_title.tr(),
            showBasket: true),
        body: _content(),
      ),
    );
  }

  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: CustomThemeData.animationDurationMedium,
          height: ref.watch(provider).isExpanded ? 750.smh : 0,
          width: AppConstants.designWidth.smw,
          child: Stack(
            children: [
              Positioned.fill(
                  child: GoogleMap(
                compassEnabled: true,
                mapToolbarEnabled: true,
                myLocationEnabled: false,
                trafficEnabled: false,
                onCameraMove: (position) {
                  ref.read(provider).marker = Marker(
                    markerId: const MarkerId("marker"),
                    position: position.target,
                  );
                  if (ref.watch(provider).isExpanded == false) {
                    ref.read(provider).isExpanded = true;
                  }
                },
                onMapCreated: (controller) async {
                  ref.read(provider).mapController = controller;
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        target: LatLng(40, 40),
                        zoom: 15,
                      ),
                    ),
                  );
                },
                markers: {ref.watch(provider).marker},
                initialCameraPosition: const CameraPosition(
                  target: LatLng(41.015137, 28.979530),
                  zoom: 14.4746,
                ),
              )),
              Positioned(
                left: 80.smw,
                bottom: 10.smh,
                child: ref.watch(provider).isExpanded
                    ? InkWell(
                        onTap: ref.read(provider).getLocationData,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: CustomThemeData.fullRounded,
                                color: CustomColors.primary),
                            height: 50.smh,
                            width: 200.smw,
                            child: Center(
                              child: CustomTextLocale(
                                  LocaleKeys
                                      .UserAddressAdd_use_current_location,
                                  style: CustomFonts.bodyText2(
                                      CustomColors.primaryText)),
                            )),
                      )
                    : Container(),
              ),
              Positioned(
                top: 10.smh,
                right: 10.smh,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: CustomThemeData.fullRounded,
                      color: Colors.white),
                  padding: const EdgeInsets.all(2),
                  child: IconButton(
                    icon: const Icon(Icons.location_on_outlined),
                    onPressed: ref.read(provider).goCurrentLocation,
                  ),
                ),
              )
            ],
          ),
        ),
        AnimatedContainer(
          margin: ref.watch(provider).isExpanded
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(vertical: 10.smh),
          duration: CustomThemeData.animationDurationMedium,
          height: ref.watch(provider).isExpanded ? 0 : 50.smh,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    ref.read(provider).isExpanded = true;
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.smw),
                    decoration: BoxDecoration(
                        borderRadius: CustomThemeData.fullRounded,
                        color: CustomColors.primary),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextLocale(LocaleKeys.UserAddressAdd_open_map,
                              style: CustomFonts.bodyText2(
                                  CustomColors.primaryText)),
                          SizedBox(width: 10.smw),
                          Icon(Icons.map, color: CustomColors.primaryText)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    ref.read(provider).isExpanded = true;
                    ref.read(provider).goCurrentLocation();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.smw),
                    decoration: BoxDecoration(
                        borderRadius: CustomThemeData.fullRounded,
                        color: CustomColors.primary),
                    child: Center(
                        child: Icon(Icons.location_on_outlined,
                            color: CustomColors.primaryText)),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _addressSummary(),
                    _customTextField(
                        label: LocaleKeys.UserAddressAdd_address_header,
                        controller: addressHeaderController),
                    _customTextField(
                      label: LocaleKeys.UserAddressAdd_building_no,
                      controller: buildingNoController,
                    ),
                    _customTextField(
                      label: LocaleKeys.UserAddressAdd_building_name,
                      controller: buildingNameController,
                    ),
                    _customTextField(
                      label: LocaleKeys.UserAddressAdd_floor_no,
                      controller: floorNoController,
                    ),
                    _customTextField(
                      label: LocaleKeys.UserAddressAdd_door_no,
                      controller: doorNoController,
                    ),
                    _customTextField(
                      label: LocaleKeys.UserAddressAdd_email,
                      controller: relatedMailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _customTextField(
                      label: LocaleKeys.UserAddressAdd_phone,
                      controller: relatedPhoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    _customTextField(
                        label: LocaleKeys.UserAddressAdd_note,
                        controller: noteController,
                        lines: 3),
                    CheckboxListTile(
                        title: CustomTextLocale(
                            LocaleKeys.UserAddressAdd_add_tax_info,
                            style: CustomFonts.bodyText2(
                                CustomColors.backgroundText)),
                        value: ref.watch(provider).isInvoice,
                        activeColor: CustomColors.primary,
                        checkColor: CustomColors.primaryText,
                        onChanged: (value) {
                          ref.read(provider).isInvoice = value!;
                        }),
                    ref.watch(provider).isInvoice
                        ? _invoiceInfo()
                        : Container(),
                    OkCancelPrompt(okCallBack: () {
                      formKey.currentState!.save();
                      if (ref.watch(provider).isInvoice) {
                        invoiceFormKey.currentState!.save();
                      }
                      ref.read(provider).addAddress(
                            addressHeader: addressHeaderController.text,
                            buildingNo: buildingNoController.text,
                            buildingName: buildingNameController.text,
                            floorNo: floorNoController.text,
                            doorNo: doorNoController.text,
                            relatedMail: relatedMailController.text,
                            relatedPhone: relatedPhoneController.text,
                            note: noteController.text,
                            identityNo: identityNoController.text,
                            relatedPersonName: relatedPersonNameController.text,
                            taxNo: taxNoController.text,
                            taxOffice: taxOfficeController.text,
                          );
                    }, cancelCallBack: () {
                      NavigationService.back();
                    })
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget _addressSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.smw, vertical: 10.smh),
      child: Center(
          child: CustomText(
        ref.watch(provider).googleAddressModel != null
            ? ref.watch(provider).googleAddressModel!.formatAddress
            : LocaleKeys.UserAddressAdd_location_retrieving.tr(),
        style: CustomFonts.bodyText2(CustomColors.backgroundText),
        maxLines: 3,
      )),
    );
  }

  Widget _customTextField(
      {String? label,
      int lines = 1,
      TextInputType keyboardType = TextInputType.text,
      required TextEditingController controller}) {
    return Container(
      width: 330.smw,
      padding: EdgeInsets.symmetric(horizontal: 10.smw),
      margin: EdgeInsets.symmetric(vertical: 5.smh),
      decoration: BoxDecoration(
          // border: Border.all(color: CustomColors.primary),
          borderRadius: CustomThemeData.fullRounded),
      child: Center(
        child: TextField(
          keyboardType: keyboardType,
          controller: controller,
          maxLines: lines,
          style: CustomFonts.defaultField(CustomColors.backgroundText),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: CustomThemeData.fullRounded,
                borderSide: BorderSide(color: CustomColors.primary)),
            enabledBorder: OutlineInputBorder(
                borderRadius: CustomThemeData.fullRounded,
                borderSide: BorderSide(color: CustomColors.primary)),
            border: OutlineInputBorder(
                borderRadius: CustomThemeData.fullRounded,
                borderSide: BorderSide(color: CustomColors.primary)),
            labelText: label?.tr(),
            labelStyle: CustomFonts.bodyText2(CustomColors.backgroundTextPale),
            floatingLabelStyle:
                CustomFonts.bodyText2(CustomColors.backgroundText),
          ),
        ),
      ),
    );
  }

  Widget _invoiceInfo() {
    return Form(
      key: invoiceFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () => ref.read(provider).isPersonal = true,
                  child: Row(children: [
                    ref.watch(provider).isPersonal
                        ? CustomIcons.radio_checked_dark_icon
                        : CustomIcons.radio_unchecked_dark_icon,
                    SizedBox(width: 15.smw),
                    CustomTextLocale(LocaleKeys.UserAddressAdd_person,
                        style:
                            CustomFonts.bodyText2(CustomColors.backgroundText))
                  ])),
              InkWell(
                  onTap: () {
                    ref.read(provider).isPersonal = false;
                  },
                  child: Row(children: [
                    !ref.watch(provider).isPersonal
                        ? CustomIcons.radio_checked_dark_icon
                        : CustomIcons.radio_unchecked_dark_icon,
                    SizedBox(width: 15.smw),
                    CustomTextLocale(LocaleKeys.UserAddressAdd_corporate,
                        style:
                            CustomFonts.bodyText2(CustomColors.backgroundText))
                  ])),
            ],
          ),
          ..._invoiceInformations()
        ],
      ),
    );
  }

  List<Widget> _invoiceInformations() {
    if (ref.watch(provider).isPersonal) {
      return _personalInvoice();
    } else {
      return _companyInvoice();
    }
  }

  List<Widget> _personalInvoice() {
    return [
      _customTextField(
          label: LocaleKeys.UserAddressAdd_related_person,
          controller: relatedPersonNameController),
      _customTextField(
          label: LocaleKeys.UserAddressAdd_identity_no,
          controller: identityNoController),
    ];
  }

  List<Widget> _companyInvoice() {
    return [
      _customTextField(
          label: LocaleKeys.UserAddressAdd_related_person,
          controller: relatedPersonNameController),
      _customTextField(
          label: LocaleKeys.UserAddressAdd_tax_number,
          controller: taxNoController),
      _customTextField(
          label: LocaleKeys.UserAddressAdd_tax_office,
          controller: taxOfficeController),
    ];
  }
}
