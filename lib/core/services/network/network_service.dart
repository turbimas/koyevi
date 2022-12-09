import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:koyevi/core/services/localization/locale_keys.g.dart';
import 'package:koyevi/core/services/navigation/navigation_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';
import 'package:koyevi/core/utils/helpers/popup_helper.dart';
import 'package:koyevi/product/constants/app_constants.dart';

abstract class NetworkService {
  static late Dio _dio;
  static const debug = true;
  static bool notInited = true;

  static Future<void> init() async {
    try {
      Dio tempDio = Dio(BaseOptions(
          sendTimeout: 5000, connectTimeout: 5000, receiveTimeout: 5000));
      (tempDio.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return null;
      };
      Response<Map<String, dynamic>> response = await tempDio
          .post<Map<String, dynamic>>("${AppConstants.APP_API}/app/gettoken",
              data: {
            "grant_type": "password",
            "username": "admin",
            "password": "\$inFtecH1100%",
          });
      AppConstants.APP_TOKEN = response.data!["data"];
      notInited = false;
    } catch (e) {
      await PopupHelper.showErrorDialog(
          errorMessage: LocaleKeys.NETWORK_ERROR.tr(),
          actions: {
            LocaleKeys.TRY_AGAIN.tr(): () {
              NavigationService.back();
            }
          });
    }

    String token = AppConstants.APP_TOKEN;
    Map<String, dynamic> headers = <String, dynamic>{};
    headers["Authorization"] = "Bearer $token";

    _dio = Dio(BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        headers: headers,
        contentType: Headers.jsonContentType,
        baseUrl: AppConstants.APP_API));

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return null;
    };
  }

  static Future<ResponseModel<T>> get<T>(String url,
      {Map<String, dynamic>? queryParameters}) async {
    while (notInited) {
      await init();
    }
    String fullUrl = url;
    try {
      if (debug) {
        log("GET : $fullUrl");
      }

      Response<Map<String, dynamic>> data =
          await _dio.get<Map<String, dynamic>>(
        fullUrl,
        queryParameters: queryParameters,
      );
      if (debug) {
        log("GET DATA: ${data.data}");
      }
      return ResponseModel<T>.fromJson(data.data!);
    } catch (e) {
      int? statusCode = (e as DioError).response!.statusCode;
      if (statusCode == 401) {
        notInited = true;
      }
      await PopupHelper.showErrorDialog(
          errorMessage: statusCode == 500
              ? LocaleKeys.ERROR_DUE_TO_SERVER.tr()
              : LocaleKeys.NETWORK_ERROR.tr(),
          actions: {
            LocaleKeys.TRY_AGAIN.tr(): () {
              NavigationService.back();
            }
          });
      return await get<T>(url, queryParameters: queryParameters);
      // return ResponseModel<T>.networkError();
    }
  }

  static Future<ResponseModel<T>> post<T>(String url,
      {Map<String, dynamic>? queryParameters, dynamic body}) async {
    while (notInited) {
      await init();
    }

    String fullUrl = url;
    try {
      if (debug) {
        log("POST: $fullUrl");
        log("POST BODY: $body");
      }

      Response<Map<String, dynamic>> response =
          await _dio.post<Map<String, dynamic>>(
        fullUrl,
        queryParameters: queryParameters,
        data: body,
      );
      if (debug) {
        log("POST DATA: ${response.data}");
      }
      return ResponseModel<T>.fromJson(response.data!);
    } catch (e) {
      // token expired
      int? statusCode = (e as DioError).response!.statusCode;
      if (statusCode == 401) {
        notInited = true;
      }
      await PopupHelper.showErrorDialog(
          errorMessage: statusCode == 500
              ? LocaleKeys.ERROR_DUE_TO_SERVER.tr()
              : LocaleKeys.NETWORK_ERROR.tr(),
          actions: {
            LocaleKeys.TRY_AGAIN.tr(): () {
              NavigationService.back();
            }
          });
      return await post<T>(url, queryParameters: queryParameters, body: body);
      // return ResponseModel.networkError();
    }
  }
}
