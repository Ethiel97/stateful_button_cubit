import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'status.dart';

class ValueWrapper<T> extends Equatable {
  final T? value;
  final Status _status;
  final String message;
  final int? updateAt;

  ///
  const ValueWrapper({
    this.value,
    this.message = '',
    this.updateAt,
    Status status = Status.initial,
  }) : _status = status;

  factory ValueWrapper.fromJson(
    Map<String, dynamic>? json, {
    required T Function(dynamic value) decoder,
    T? orDefault,
  }) {
    try {
      final value = json != null && json['value'] != null
          ? decoder(json['value'])
          : orDefault;
      return ValueWrapper(
        value: value,
        status: json != null && json['status'] != null
            ? Status.values[json['status'] as int]
            : Status.initial,
        message: json != null && json['message'] != null
            ? json['message'] as String
            : '',
        updateAt: json != null && json['updateAt'] != null
            ? json['updateAt'] as int
            : null,
      );
    } catch (e, __) {
      if (kDebugMode) {
        print("$e\n$__");
      }
      return ValueWrapper(value: orDefault);
    }
  }

  Map<String, dynamic> toJson({dynamic Function(T? value)? encoder}) {
    return {
      'value': value != null && encoder != null ? encoder(value as T) : null,
      'message': message,
      'status': _status.isLoading ? Status.initial.index : _status.index,
      'updateAt': updateAt,
    };
  }

  factory ValueWrapper.fromListJson(
    Map<String, dynamic>? json, {
    required T Function(List<dynamic> values) decoder,
    T? orDefault,
  }) {
    try {
      return ValueWrapper(
        value: json != null && json['value'] != null
            ? decoder(json['value'])
            : orDefault,
        status: json != null && json['status'] != null
            ? Status.values[json['status'] as int]
            : Status.initial,
        message: json != null && json['message'] != null
            ? json['message'] as String
            : '',
        updateAt: json != null && json['updateAt'] != null
            ? json['updateAt'] as int?
            : null,
      );
    } catch (e, _) {
      return ValueWrapper(value: orDefault);
    }
  }

  Map<String, dynamic> toMap({dynamic Function(T? value)? encoder}) {
    return toJson(encoder: encoder);
  }

  String toStringJson({Map<String, dynamic> Function(T? value)? encoder}) {
    return json.encode(toJson(encoder: encoder));
  }

  ValueWrapper<T> toInitial([T? value]) => ValueWrapper(
        value: value ?? this.value,
      );

  ValueWrapper<T> toLoading([T? value]) => ValueWrapper(
        value: value ?? this.value,
        status: Status.loading,
        updateAt: updateAt,
      );

  ValueWrapper<T> toRefreshing([T? value]) => ValueWrapper(
        value: value ?? this.value,
        status: Status.refresh,
        updateAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      );

  ValueWrapper<T> toSuccess(T value) => ValueWrapper(
        value: value,
        status: Status.success,
        updateAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      );

  ValueWrapper<T> toFailed({T? value, String message = ''}) => ValueWrapper(
        value: value ?? this.value,
        status: Status.failed,
        message: message,
        updateAt: updateAt,
      );

  @override
  String toString() {
    return 'StateVariable('
        'status: $_status, '
        'value: $value, '
        'updateAt: $updateAt, '
        'message: $message';
  }

  @override
  List<Object?> get props => [
        value,
        message,
        _status,
        updateAt,
      ];

  Status get status => _status;

  ///
  bool get isInitial => _status.isInitial;

  ///
  bool get isLoading => _status.isLoading;

  ///
  bool get isRefresh => _status.isRefresh;

  ///
  bool get isSuccess => _status.isSuccess;

  ///
  bool get isFailed => _status.isFailed;

  ///
  bool get hasMessage => message.isNotEmpty;

  ///Use [requiredValue] only if [value] can never be null.
  T get requiredValue {
    return value!;
  }

  int? get getMinSinceLastUpdate {
    if (updateAt == null) {
      return null;
    }

    return DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(updateAt!))
        .inMilliseconds;
  }

  bool hasBeenUpdatedInLastMinutesOf({
    required int minutes,
    required bool Function(T? value) cacheValidator,
  }) {
    if (minutes == 0) {
      return false;
    }

    final lastUpdatedTime = getMinSinceLastUpdate;

    if (lastUpdatedTime == null) {
      return false;
    }

    return cacheValidator(value) && lastUpdatedTime < minutes;
  }
}
