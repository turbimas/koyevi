import 'package:koyevi/core/services/network/network_service.dart';
import 'package:koyevi/core/services/network/response_model.dart';

class RequestModel {
  String url;
  Map<String, dynamic>? queryParameters;

  bool success = false;
  ResponseModel? response;

  RequestModel({required this.url, this.queryParameters});

  Future<void> action() async {}
}

class RequestGetModel extends RequestModel {
  RequestGetModel({required String url, Map<String, dynamic>? queryParameters})
      : super(url: url, queryParameters: queryParameters);

  @override
  Future<void> action() async {
    try {
      response =
          await NetworkService.get(url, queryParameters: queryParameters);
      success = response!.success;
    } catch (e) {
      success = false;
    }
  }
}

class RequestPostModel extends RequestModel {
  Map<String, dynamic>? body;

  RequestPostModel(
      {required String url, Map<String, dynamic>? queryParameters, this.body})
      : super(url: url, queryParameters: queryParameters);

  @override
  Future<void> action() async {
    try {
      response = await NetworkService.post(url,
          body: body, queryParameters: queryParameters);
      success = response!.success;
    } catch (e) {
      success = false;
    }
  }
}
