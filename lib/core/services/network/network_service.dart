import 'dart:developer';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
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
      Dio _tempDio = Dio();
      (_tempDio.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
      Response<Map<String, dynamic>> response = await _tempDio
          .post<Map<String, dynamic>>(
              AppConstants.APP_API +
                  NavigationService.context.locale.languageCode +
                  "/app/gettoken",
              data: {
            "grant_type": "password",
            "username": "admin",
            "password": "\$inFtecH1100\%",
          });
      AppConstants.APP_TOKEN = response.data!["data"];
      notInited = false;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1), () {
        PopupHelper.showErrorToast("İnit: " + e.toString());
      });
    }

    String token = AppConstants.APP_TOKEN;
    Map<String, dynamic> headers = Map<String, dynamic>();
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
    };
  }

  static Future<ResponseModel<T>> get<T>(String url,
      {Map<String, dynamic>? queryParameters}) async {
    while (notInited) {
      await init();
    }
    String fullUrl = "${NavigationService.context.locale.languageCode}/$url";
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
      if ((e as DioError).response!.statusCode == 401) {
        notInited = true;
      }
      return ResponseModel<T>.networkError();
    }
  }

  static Future<ResponseModel<T>> post<T>(String url,
      {Map<String, dynamic>? queryParameters, dynamic body}) async {
    while (notInited) {
      await init();
    }

    String fullUrl = "${NavigationService.context.locale.languageCode}/$url";
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
      if ((e as DioError).response!.statusCode == 401) {
        notInited = true;
      }
      return ResponseModel.networkError();
    }
  }
}
