import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koyevi/core/services/auth/authservice.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/models/user/google_address_model.dart';

class UserAddressAddViewModel extends ChangeNotifier {
  late TextEditingController countryController;
  late TextEditingController cityController;
  late TextEditingController regionController;
  late TextEditingController districtController;
  late TextEditingController townController;
  late TextEditingController streetController;
  late TextEditingController buildingController;
  late TextEditingController postalCodeController;

  UserAddressAddViewModel(
      {required this.countryController,
      required this.cityController,
      required this.regionController,
      required this.districtController,
      required this.townController,
      required this.streetController,
      required this.buildingController,
      required this.postalCodeController});
  late GoogleMapController mapController;
  GoogleAddressModel? _googleAddressModel;
  GoogleAddressModel? get googleAddressModel => _googleAddressModel;
  set googleAddressModel(GoogleAddressModel? value) {
    _googleAddressModel = value;
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

  Map<String, dynamic> formData = {};

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
        googleAddressModel!.lat = marker.position.latitude;
        googleAddressModel!.lng = marker.position.longitude;
        countryController.text = googleAddressModel!.country;
        cityController.text = googleAddressModel!.city;
        regionController.text = googleAddressModel!.region;
        districtController.text = googleAddressModel!.district;
        townController.text = googleAddressModel!.town;
        streetController.text = googleAddressModel!.street;
        buildingController.text = googleAddressModel!.buildingNo;
        postalCodeController.text = googleAddressModel!.postalCode;
      } else {
        PopupHelper.showErrorToast(response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> addAddress() async {
    try {
      formData["CariID"] = AuthService.currentUser!.id;
      googleAddressModel!.country = countryController.text;
      googleAddressModel!.city = cityController.text;
      googleAddressModel!.district = districtController.text;
      googleAddressModel!.region = regionController.text;
      googleAddressModel!.town = townController.text;
      googleAddressModel!.street = streetController.text;
      googleAddressModel!.buildingNo = buildingController.text;
      googleAddressModel!.postalCode = postalCodeController.text;
      if (formData["AdresBasligi"]
          .toString()
          .replaceAll("null", "")
          .trim()
          .isEmpty) {
        PopupHelper.showErrorDialog(errorMessage: "Adres Başlığı Boş Olamaz");
        return;
      }
      ResponseModel response =
          await NetworkService.post("users/adress_add", body: {
        "localAdress": formData,
        "googleadress": googleAddressModel!.toJson(),
      });

      if (response.success) {
        PopupHelper.showSuccessToast("Adres başarıyla eklendi");
        NavigationService.back();
      } else {
        PopupHelper.showErrorDialog(errorMessage: response.errorMessage!);
      }
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }

  Future<void> goCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      if (await Geolocator.isLocationServiceEnabled()) {
        _goCurrentLocation();
      } else {
        PopupHelper.showErrorDialog(
            errorMessage: "Lütfen konum servislerini açın");
      }
    } else {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        if (await Geolocator.isLocationServiceEnabled()) {
          _goCurrentLocation();
        } else {
          PopupHelper.showErrorDialog(
              errorMessage: "Lütfen konum servislerini açın");
        }
      } else {
        PopupHelper.showErrorDialog(errorMessage: "Lütfen konum iznini verin");
      }
    }
  }

  Future<void> _goCurrentLocation() async {
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
              zoom: await mapController.getZoomLevel(),
              target: LatLng(position.latitude, position.longitude)),
        ),
      );
    } catch (e) {
      PopupHelper.showErrorDialogWithCode(e);
    }
  }
}
