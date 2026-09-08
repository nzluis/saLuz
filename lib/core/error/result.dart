import 'package:meta/meta.dart';

@immutable
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T get requireSuccess {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw StateError('Called requireSuccess on a Failure');
  }

  Failure<T> get requireFailure {
    if (this is Failure<T>) {
      return this as Failure<T>;
    }
    throw StateError('Called requireFailure on a Success');
  }

  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => Success(transform(value)),
      Failure<T>(:final error) => Failure(error),
    };
  }

  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => transform(value),
      Failure<T>(:final error) => Failure(error),
    };
  }

  R fold<R>(
    R Function(T value) onSuccess,
    R Function(Object error) onFailure,
  ) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Failure<T>(:final error) => onFailure(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;

  @override
  String toString() => 'Success($value)';
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final Object error;

  @override
  String toString() => 'Failure($error)';
}
