import 'package:xerkonix_error_handler/xerkonix_error_handler.dart';
import 'package:xerkonix_logger/xerkonix_logger.dart';
import 'package:http/http.dart';

import '../constant/http_constant.dart';
import '../http_utils/xerkonix_http_config.dart';
import '../http_utils/xerkonix_http_utils.dart';

class XkHttpResponse {
  XkHttpResponse({required this.httpConfig});

  final XkHttpConfig httpConfig;

  dynamic get(Response response) {
    switch (response.statusCode) {
      case 200: // OK
      case 201: // Created
        final responseJson = _decodeResponse(response);
        if (httpConfig.isLoggingEnabled) {
          Logger.httpResponse(httpResponse: response);
        }
        return responseJson;
      case 204: // No Content
        if (httpConfig.isLoggingEnabled) {
          Logger.httpResponse(httpResponse: response);
        }
        return null;
      case 400: // Bad Request
        return _handleErrorResponse(response, XkErrors.badRequest);
      case 401: // Unauthorized
        return _handleErrorResponse(response, XkErrors.unauthorized);
      case 403: // Forbidden
        return _handleErrorResponse(response, XkErrors.forbidden);
      case 404: // Not Found
        return _handleErrorResponse(response, XkErrors.notFound);
      case 408: // Request Timeout
        return _handleErrorResponse(response, XkErrors.requestTimeout);
      case 409: // Conflict
        return _handleErrorResponse(response, XkErrors.conflict);
      case 422: // Unprocessable Entity
        return _handleErrorResponse(response, XkErrors.unprocessableEntity);
      case 500: // Internal Server Error
        return _handleErrorResponse(response, XkErrors.internalServerError);
      case 503: // Service Unavailable
        return _handleErrorResponse(response, XkErrors.serviceUnavailable);
      case 520: // Unknown Error (Web Server Unknown Error)
        return _handleErrorResponse(response, XkErrors.unknownError);
      default:
        final xkError = XkErrors.unknownError();
        throw XkException(xkError);
    }
  }

  /// JSON 디코딩을 수행하는 공통 메서드
  dynamic _decodeResponse(Response response) {
    return httpConfig.jsonDecodingOption == XkHttpConst.jsonEncodingOption.utf8
            ? XkHttpUtils.jsonDecodeFromUTF8(response: response)
            : XkHttpUtils.jsonDecode(response: response);
  }

  /// 에러 응답을 처리하는 공통 메서드
  Never _handleErrorResponse(
    Response response,
    XkError Function({
      String? type,
      String? message,
      String? title,
      String? detail,
    }) errorFactory,
  ) {
    final responseJson = _decodeResponse(response);
        final errorData = _extractErrorData(responseJson);
    final xkError = errorFactory(
            type: errorData['type'],
            message: errorData['message'],
            title: errorData['title'],
      detail: errorData['detail'],
    );
    throw XkException(xkError);
  }

  Map<String, String?> _extractErrorData(dynamic responseJson) {
    if (responseJson is Map<String, dynamic>) {
      final error = responseJson['error'];
      if (error is Map<String, dynamic>) {
        return {
          'type': error['type']?.toString(),
          'message': error['message']?.toString(),
          'title': error['title']?.toString(),
          'detail': error['detail']?.toString(),
        };
      }
    }
    return {
      'type': null,
      'message': null,
      'title': null,
      'detail': null,
    };
  }
}
