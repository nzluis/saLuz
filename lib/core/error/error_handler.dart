import 'package:injectable/injectable.dart';

import 'app_exception.dart';

@injectable
class ErrorHandler {
  /// Wraps an async operation in a try-catch, returning AppException on failure.
  Future<T?> handleAsync<T>(
    Future<T> Function() operation, {
    String? context,
  }) async {
    try {
      return await operation();
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ParseException(
        message: e.message,
      );
    } catch (e, stackTrace) {
      throw AppExceptionBase(
        message: context != null ? 'Error: $context' : e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  /// Maps an AppException to a user-friendly message.
  String userMessage(Object error) {
    return switch (error) {
      NetworkException(:final statusCode) => switch (statusCode) {
        404 => 'Resource not found.',
        429 => 'Too many requests. Please try again later.',
        500 => 'Server error. Please try again later.',
        _ => 'Network error. Check your connection.',
      },
      TimeoutException() => 'Request timed out. Check your connection.',
      CacheException() => 'Local storage error.',
      ParseException() => 'Failed to parse data.',
      ValidationException(:final fieldErrors) =>
        fieldErrors?.values.first ?? 'Invalid input.',
      PubMedException() => 'Error fetching medical data.',
      _ => 'An unexpected error occurred.',
    };
  }
}

/// Generic AppException for catch-all cases.
base class AppExceptionBase extends AppException {
  AppExceptionBase({super.message, super.stackTrace});
}
