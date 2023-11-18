import 'dart:async';
import 'dart:io';

import "package:dio/dio.dart";
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_path_provider.dart';

class DioClient {
  static const requestTimeout =
  Duration(seconds: 25); // request to server timeout in seconds
  static const cacheInSeconds = Duration(seconds: 2);

  Dio init({String? baseUrl}) {
    Dio _dio = Dio();
    _dio.interceptors.add(ApiInterceptors());
    _dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: HiveCacheStore(AppPathProvider.path),
          policy: CachePolicy.refreshForceCache,
          hitCacheOnErrorExcept: [],
          maxStale: cacheInSeconds,
          priority: CachePriority.high,
        ),
      ),
    );

    //this is for avoiding certificates error cause by dio
    //https://issueexplorer.com/issue/flutterchina/dio/1285

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
    };
    _dio.options.baseUrl = baseUrl ?? "http://18.216.240.29:3000";
        // dotenv.get("API_URL", fallback: "http://18.216.240.29:3000");
    print("@@@ _dio.options.baseUrl = ${_dio.options.baseUrl}");

    ///////
    _dio.options.connectTimeout = requestTimeout;
    _dio.options.receiveTimeout = requestTimeout;
    _dio.options.sendTimeout = requestTimeout;
    ///////

    _dio.interceptors.add(LogInterceptor(
        responseBody: true, requestBody: true, request: true)); //开启请求日志
    return _dio;
  }
}

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');

    if (options.data != null) {
      print("Body: ${options.data}");
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    return super.onError(err, handler);
  }

  int _getStatusCode(DioException err) {
    int statusCode = 0;
    if (err.response != null && err.response!.statusCode != null) {
      statusCode = err.response!.statusCode!;
    }
    return statusCode;
  }

  bool _shouldEmitError(DioError err) {
    if (err.type == DioErrorType.connectionTimeout ||
        err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout ||
        err.type == DioErrorType.unknown ||
        _isErrorStatusCode(err)) {
      return true;
    }
    return false;
  }

  bool _isErrorStatusCode(DioError err) {
    int statusCode = _getStatusCode(err);
    return (statusCode >= 500 || statusCode == 404 || statusCode == 401);
  }

  bool _shouldBeLogged(DioError err) {
    int statusCode = _getStatusCode(err);
    return (statusCode >= 500 || statusCode == 404);
  }

  String _buildErrorMessage(DioError err) {
    String result = "No internet connection, please check and try again";
    int statusCode = _getStatusCode(err);
    if (statusCode >= 500) {
      result = "Internal server error, please try again later";
    } else if (statusCode == 404) {
      result = "Resource not found, please try again later";
    } else if (statusCode == 401) {
      result = "Error, please try again later";
      if (err.response != null && err.response!.data != null) {
        result = err.response!.data['message'] ?? result;
      }
    } else if (err.type == DioExceptionType.unknown) {
      if (!err.message!
          .toUpperCase()
          .contains("SocketException".toUpperCase())) {
        result = "Error, please try again later";
      }
    }
    return result;
  }
}
