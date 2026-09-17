import 'package:flutter_test/flutter_test.dart';
import 'package:saluz/core/error/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('isSuccess returns true', () {
        const result = Success(42);
        expect(result.isSuccess, isTrue);
      });

      test('isFailure returns false', () {
        const result = Success(42);
        expect(result.isFailure, isFalse);
      });

      test('requireSuccess returns value', () {
        const result = Success(42);
        expect(result.requireSuccess, 42);
      });

      test('requireFailure throws StateError', () {
        const result = Success(42);
        expect(() => result.requireFailure, throwsStateError);
      });

      test('toString returns Success(value)', () {
        const result = Success(42);
        expect(result.toString(), 'Success(42)');
      });
    });

    group('Failure', () {
      test('isSuccess returns false', () {
        final result = Failure<Object>(Exception('oops'));
        expect(result.isSuccess, isFalse);
      });

      test('isFailure returns true', () {
        final result = Failure<Object>(Exception('oops'));
        expect(result.isFailure, isTrue);
      });

      test('requireFailure returns failure', () {
        final error = Exception('oops');
        final result = Failure<Object>(error);
        expect(result.requireFailure.error, error);
      });

      test('requireSuccess throws StateError', () {
        final result = Failure<Object>(Exception('oops'));
        expect(() => result.requireSuccess, throwsStateError);
      });

      test('toString returns Failure(error)', () {
        final result = Failure<Object>(Exception('oops'));
        expect(result.toString(), startsWith('Failure('));
      });
    });

    group('map', () {
      test('transforms Success value', () {
        const result = Success(21);
        final mapped = result.map((v) => v * 2);
        expect(mapped.requireSuccess, 42);
      });

      test('preserves Failure', () {
        final error = Exception('oops');
        final result = Failure<int>(error);
        final mapped = result.map((v) => v * 2);
        expect(mapped.isFailure, isTrue);
        expect(mapped.requireFailure.error, error);
      });
    });

    group('flatMap', () {
      test('chains Success into Success', () {
        const result = Success(21);
        final flatMapped = result.flatMap((v) => Success(v * 2));
        expect(flatMapped.requireSuccess, 42);
      });

      test('chains Success into Failure', () {
        const result = Success(21);
        final error = Exception('chain error');
        final flatMapped = result.flatMap<int>((_) => Failure<int>(error));
        expect(flatMapped.isFailure, isTrue);
        expect(flatMapped.requireFailure.error, error);
      });

      test('preserves Failure', () {
        final originalError = Exception('original');
        final result = Failure<int>(originalError);
        final flatMapped = result.flatMap((v) => Success(v * 2));
        expect(flatMapped.isFailure, isTrue);
        expect(flatMapped.requireFailure.error, originalError);
      });
    });

    group('fold', () {
      test('calls onSuccess for Success', () {
        const result = Success(42);
        final folded = result.fold(
          (v) => 'value: $v',
          (e) => 'error: $e',
        );
        expect(folded, 'value: 42');
      });

      test('calls onFailure for Failure', () {
        final result = Failure<Object>(Exception('oops'));
        final folded = result.fold(
          (v) => 'value: $v',
          (e) => 'error: $e',
        );
        expect(folded, startsWith('error:'));
      });
    });
  });
}
