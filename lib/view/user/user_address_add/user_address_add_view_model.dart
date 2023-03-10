import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/user/google_address_model.dart';
import 'package:koyevi/product/models/user/locale_address_model.dart';

class UserAddressAddViewModel extends ChangeNotifier {
  late TextEditingController buildingNoController;
  UserAddressAddViewModel({required this.buildingNoController});
  late GoogleMapController mapController;

  LocaleAddressModel localeAddressModel = LocaleAddressModel();

  GoogleAddressModel? _googleAddressModel;
  GoogleAddressModel? get googleAddressModel => _googleAddressModel;
  set googleAddressModel(GoogleAddressModel? value) {
    _googleAddressModel = value;
    buildingNoController.text = value!.buildingNo;
    notifyListeners();
  }

  Marker _marker = const Marker(
    markerId: MarkerId("marker"),
    position: LatLng(40, 40),
  );
  Marker get marker => _marker;
  set marker(Marker value) {
    _marker = value;
    notifyListeners();
  }

  bool _isInvoice = false;
  bool get isInvoice => _isInvoice;
  set isInvoice(bool value) {
    _isInvoice = value;
    notifyListeners();
  }

  bool _isPersonal = true;
  bool get isPersonal => _isPersonal;
  set isPersonal(bool value) {
    _isPersonal = value;
    notifyListeners();
  }

  bool _isExpanded = true;
  bool get isExpanded => _isExpanded;
  set isExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getLocationData() async {
    try {
      isExpanded = false;
      ResponseModel response =
          await NetworkService.post("users/googlemaptoadress", body: {
        "lat": marker.position.latitude,
        "lng": marker.position.longitude,
      });
      if (response.success) {
        googleAddressModel = GoogleAddressModel.fromJson(response.data);
      } else {
        PopupHelper.showErrorToast(response.errorMessage!);
        isExpanded = true;
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
      isExpanded = true;
    }
  }

  Future<void> addAddress({
    required String addressHeader,
    required String relatedPersonName,
    required String relatedMail,
    required String relatedPhone,
    required String identityNo,
    required String taxNo,
    required String taxOffice,
    required String buildingNo,
    required String buildingName,
    required String floorNo,
    required String doorNo,
    required String note,
  }) async {
    try {
      if (addressHeader.isEmpty) {
        PopupHelper.showErrorDialog(
            errorMessage:
                LocaleKeys.UserAddressAdd_address_header_can_not_be_empty.tr());
        return;
      }
      localeAddressModel.cariID = AuthService.id;
      localeAddressModel.adresBasligi = addressHeader;
      localeAddressModel.email = relatedMail;
      localeAddressModel.mobilePhone = relatedPhone;
      if (_isInvoice) {
        localeAddressModel.relatedPerson = relatedPersonName;
        if (_isPersonal) {
          localeAddressModel.TCKNo = identityNo;
        } else {
          localeAddressModel.taxOffice = taxOffice;
          localeAddressModel.taxNumber = taxNo;
        }
      }
      List<String> noteList = [];
      if (buildingNo.isNotEmpty) {
        noteList.add("Bina no: $buildingNo");
      }
      if (buildingName.isNotEmpty) {
        noteList.add("Bina adı: $buildingName");
      }
      if (floorNo.isNotEmpty) {
        noteList.add("Kat no: $floorNo");
      }
      if (doorNo.isNotEmpty) {
        noteList.add("Kapı no: $doorNo");
      }
      if (note.isNotEmpty) {
        noteList.add(note);
      }
      localeAddressModel.notes = noteList.join("\n");

      ResponseModel response =
          await NetworkService.post("users/adress_add", body: {
        "localAdress": localeAddressModel.toJson(),
        "googleadress": googleAddressModel!.toJson(),
      });

      if (response.success) {
        PopupHelper.showSuccessToast(
            LocaleKeys.UserAddressAdd_address_added_successfully.tr());
        NavigationService.back();
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> goCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      marker = Marker(
        markerId: const MarkerId("marker"),
        position: LatLng(position.latitude, position.longitude),
      );
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 17, target: LatLng(position.latitude, position.longitude)),
        ),
      );
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
