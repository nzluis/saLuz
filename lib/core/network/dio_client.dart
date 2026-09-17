import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../env/env.dart';

Dio createDio(Environment env) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    _LoggingInterceptor(logLevel: env.logLevel),
    _ErrorInterceptor(),
  ]);

  return dio;
}

class _LoggingInterceptor extends Interceptor {
  _LoggingInterceptor({required this.logLevel});

  final LogLevel logLevel;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logLevel == LogLevel.debug) {
      debugPrint('[HTTP] ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (logLevel == LogLevel.debug) {
      debugPrint('[HTTP] ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logLevel.index <= LogLevel.info.index) {
      debugPrint('[HTTP ERROR] ${err.type}: ${err.message}');
    }
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    final message = switch (err.type) {
      DioExceptionType.connectionTimeout => 'Connection timed out',
      DioExceptionType.sendTimeout => 'Send timed out',
      DioExceptionType.receiveTimeout => 'Receive timed out',
      DioExceptionType.transformTimeout => 'Transform timed out',
      DioExceptionType.badResponse => 'Server error: $statusCode',
      DioExceptionType.cancel => 'Request cancelled',
      DioExceptionType.connectionError => 'No internet connection',
      DioExceptionType.badCertificate => 'Certificate error',
      DioExceptionType.unknown => 'Network error',
    };

    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: message,
        stackTrace: err.stackTrace,
      ),
    );
  }
}
