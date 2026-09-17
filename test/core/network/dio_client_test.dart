import 'package:flutter_test/flutter_test.dart';
import 'package:saluz/core/env/env.dart';
import 'package:saluz/core/network/dio_client.dart';

void main() {
  group('createDio', () {
    test('creates Dio with correct base options', () {
      final dio = createDio(Environment.dev);

      expect(dio.options.connectTimeout, const Duration(seconds: 10));
      expect(dio.options.receiveTimeout, const Duration(seconds: 15));
      expect(dio.options.sendTimeout, const Duration(seconds: 10));
      expect(dio.options.headers['Accept'], 'application/json');
      expect(dio.options.headers['Content-Type'], 'application/json');

      dio.close();
    });

    test('creates Dio with interceptors', () {
      final dio = createDio(Environment.dev);

      expect(dio.interceptors.length, greaterThanOrEqualTo(2));

      dio.close();
    });

    test('creates Dio for each environment', () {
      final devDio = createDio(Environment.dev);
      final prodDio = createDio(Environment.prod);

      expect(devDio.options.connectTimeout, const Duration(seconds: 10));
      expect(prodDio.options.connectTimeout, const Duration(seconds: 10));

      devDio.close();
      prodDio.close();
    });
  });
}
