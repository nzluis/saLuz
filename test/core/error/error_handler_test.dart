import 'package:flutter_test/flutter_test.dart';
import 'package:saluz/core/error/error.dart';

void main() {
  late ErrorHandler handler;

  setUp(() {
    handler = ErrorHandler();
  });

  group('userMessage', () {
    test('NetworkException 404 returns not found message', () {
      expect(
        handler.userMessage(NetworkException(statusCode: 404)),
        'Resource not found.',
      );
    });

    test('NetworkException 429 returns rate limit message', () {
      expect(
        handler.userMessage(NetworkException(statusCode: 429)),
        'Too many requests. Please try again later.',
      );
    });

    test('NetworkException 500 returns server error message', () {
      expect(
        handler.userMessage(NetworkException(statusCode: 500)),
        'Server error. Please try again later.',
      );
    });

    test('NetworkException unknown status returns generic message', () {
      expect(
        handler.userMessage(NetworkException(statusCode: 418)),
        'Network error. Check your connection.',
      );
    });

    test('TimeoutException returns timeout message', () {
      expect(
        handler.userMessage(TimeoutException()),
        'Request timed out. Check your connection.',
      );
    });

    test('CacheException returns cache message', () {
      expect(
        handler.userMessage(CacheException()),
        'Local storage error.',
      );
    });

    test('ParseException returns parse message', () {
      expect(
        handler.userMessage(ParseException()),
        'Failed to parse data.',
      );
    });

    test('ValidationException with field errors returns first error', () {
      expect(
        handler.userMessage(ValidationException(
          fieldErrors: {'name': 'Name is required'},
        )),
        'Name is required',
      );
    });

    test('ValidationException without field errors returns generic', () {
      expect(
        handler.userMessage(ValidationException()),
        'Invalid input.',
      );
    });

    test('PubMedException returns medical data message', () {
      expect(
        handler.userMessage(PubMedException()),
        'Error fetching medical data.',
      );
    });

    test('unknown error returns unexpected error message', () {
      expect(
        handler.userMessage(Exception('something')),
        'An unexpected error occurred.',
      );
    });
  });

  group('handleAsync', () {
    test('returns value on success', () async {
      final result = await handler.handleAsync(() async => 42);
      expect(result, 42);
    });

    test('rethrows AppException', () async {
      expect(
        () => handler.handleAsync(() async {
          throw NetworkException(statusCode: 500);
        }),
        throwsA(isA<NetworkException>()),
      );
    });

    test('wraps FormatException in ParseException', () async {
      expect(
        () => handler.handleAsync(() async {
          throw FormatException('bad format');
        }),
        throwsA(isA<ParseException>()),
      );
    });

    test('wraps generic exception in AppExceptionBase', () async {
      expect(
        () => handler.handleAsync(
          () async {
            throw Exception('something');
          },
          context: 'test',
        ),
        throwsA(isA<AppExceptionBase>()),
      );
    });
  });
}
