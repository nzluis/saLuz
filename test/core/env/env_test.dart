import 'package:flutter_test/flutter_test.dart';
import 'package:saluz/core/env/env.dart';

void main() {
  group('Environment', () {
    test('dev has correct values', () {
      const env = Environment.dev;
      expect(env.name, 'dev');
      expect(env.apiBaseUrl, 'http://localhost:3000');
      expect(env.enableOfflineMode, isTrue);
      expect(env.logLevel, LogLevel.debug);
    });

    test('staging has correct values', () {
      const env = Environment.staging;
      expect(env.name, 'staging');
      expect(env.apiBaseUrl, 'https://api-staging.saluz.app');
      expect(env.logLevel, LogLevel.info);
    });

    test('prod has correct values', () {
      const env = Environment.prod;
      expect(env.name, 'prod');
      expect(env.apiBaseUrl, 'https://api.saluz.app');
      expect(env.logLevel, LogLevel.warning);
    });

    test('fromName returns correct environment', () {
      expect(Environment.fromName('dev'), Environment.dev);
      expect(Environment.fromName('staging'), Environment.staging);
      expect(Environment.fromName('prod'), Environment.prod);
    });

    test('fromName throws on unknown name', () {
      expect(
        () => Environment.fromName('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('LogLevel', () {
    test('has correct order', () {
      expect(LogLevel.debug.index, lessThan(LogLevel.info.index));
      expect(LogLevel.info.index, lessThan(LogLevel.warning.index));
      expect(LogLevel.warning.index, lessThan(LogLevel.error.index));
    });
  });
}
