import 'package:equatable/equatable.dart';
import 'package:la/domain/core/value_objects/failures/failure.dart';
import 'package:la/domain/core/value_objects/payload.dart';

sealed class StreamPayload<T> extends Equatable {
  bool get isRefresh => this is DataRefreshPayload<T>;

  bool get isReset => this is DataResetPayload<T>;

  bool get isSuccess => this is DataDeliveredPayload<T>;

  bool get isFailure => this is DataDeliveryErrorPayload<T>;

  T? get dataOrNull {
    return switch (this) {
      final DataDeliveredPayload<T> payload => payload.data,
      final DataRefreshPayload<T> payload => payload.currentData,
      final DataDeliveryErrorPayload<T> payload => payload.cachedData,
      _ => null,
    };
  }

  const StreamPayload();

  factory StreamPayload.refresh(T currentData) {
    return DataRefreshPayload<T>(currentData);
  }

  factory StreamPayload.reset() {
    return DataResetPayload<T>();
  }

  factory StreamPayload.success(T data) {
    return DataDeliveredPayload<T>(data);
  }

  factory StreamPayload.failure(
      Failure failure, {
        T? fallback,
        DateTime? cacheDataTimeStamp,
      }) {
    return DataDeliveryErrorPayload<T>(
      failure,
      cachedData: fallback,
      cacheDataTimeStamp: cacheDataTimeStamp,
    );
  }

  void resolve({
    required void Function(DataDeliveryErrorPayload<T> payload) onFailure,
    required void Function() onDataRefresh,
    void Function()? onDataCleared,
    required void Function(T data) onData,
  }) {
    switch (this) {
      case final DataDeliveryErrorPayload<T> payload:
        onFailure(payload);
      case DataRefreshPayload():
        onDataRefresh();
      case DataResetPayload():
        onDataCleared?.call();
      case final DataDeliveredPayload<T> payload:
        onData(payload.data);
    }
  }

  static StreamPayload<T> fromPayload<T>(Payload<T> payload) {
    return payload.fold(
          (Failure failure) {
        return StreamPayload.failure(failure);
      },
          (T data) {
        return StreamPayload.success(data);
      },
    );
  }
}

class DataRefreshPayload<T> extends StreamPayload<T> {
  final T currentData;

  const DataRefreshPayload(this.currentData);

  @override
  List<Object?> get props => [currentData];
}

class DataResetPayload<T> extends StreamPayload<T> {
  const DataResetPayload();

  @override
  List<Object?> get props => [];
}

class DataDeliveredPayload<T> extends StreamPayload<T> {
  final T data;

  const DataDeliveredPayload(this.data);

  @override
  List<Object?> get props => [data];
}

class DataDeliveryErrorPayload<T> extends StreamPayload<T> {
  final Failure failure;
  final T? cachedData;
  final DateTime? cacheDataTimeStamp;

  const DataDeliveryErrorPayload(
      this.failure, {
        required this.cachedData,
        this.cacheDataTimeStamp,
      });

  @override
  List<Object?> get props => [
    failure,
    cachedData,
    cacheDataTimeStamp,
  ];
}
