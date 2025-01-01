import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';

@immutable
abstract class ValueObject<T> extends Equatable {
  final T? _value;
  final Failure? _failure;

  Failure? get failure => _failure;
  T? get value => _value;
  bool get valid => _failure == null;
  bool get isInvalid => _failure != null;

  const ValueObject(this._value, this._failure);

  S fold<S>(S Function(Failure failure) failure, S Function(T value) value) {
    if (_failure == null) {
      return value(_value as T);
    } else {
      return failure(_failure);
    }
  }

  T getOr(T errorValue) {
    if (_failure == null) {
      return _value as T;
    }
    return errorValue;
  }

  void whenValue<S>(S Function(T value) value) {
    if (_failure == null) {
      value(_value as T);
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ValueObject<T> &&
              runtimeType == other.runtimeType &&
              _value == other._value &&
              _failure == other._failure;

  @override
  int get hashCode => (_value?.hashCode ?? 0) + (_failure?.hashCode ?? 0);

  @override
  String toString() {
    return 'Value{ value: $_value }';
  }

  @override
  List<Object?> get props => [
    _value,
    _failure,
  ];
}
