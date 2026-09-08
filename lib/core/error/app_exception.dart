abstract base class AppException implements Exception {
  AppException({this.message, this.stackTrace});

  final String? message;
  final StackTrace? stackTrace;

  @override
  String toString() => message ?? runtimeType.toString();
}

// Network errors
base class NetworkException extends AppException {
  NetworkException({super.message, super.stackTrace, this.statusCode});

  final int? statusCode;
}

base class TimeoutException extends AppException {
  TimeoutException({super.message, super.stackTrace});
}

// Cache / local storage errors
base class CacheException extends AppException {
  CacheException({super.message, super.stackTrace});
}

// Data parsing errors
base class ParseException extends AppException {
  ParseException({super.message, super.stackTrace});
}

// Business logic errors
base class ValidationException extends AppException {
  ValidationException({super.message, super.stackTrace, this.fieldErrors});

  final Map<String, String>? fieldErrors;
}

// PubMed API errors
base class PubMedException extends AppException {
  PubMedException({super.message, super.stackTrace, this.query});
  
  final String? query;
}
