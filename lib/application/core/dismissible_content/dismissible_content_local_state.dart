part of 'dismissible_content_local_cubit.dart';

enum DismissibleContentLocalStatus {
  loading,
  loaded,
}

@immutable
class DismissibleContentLocalState extends Equatable {
  final DismissibleContentLocalStatus status;
  final List<DismissibleContentKey> trackedKeys;
  final Map<DismissibleContentKey, bool> dismissedByKey;

  const DismissibleContentLocalState({
    required this.status,
    required this.trackedKeys,
    required this.dismissedByKey,
  });

  const DismissibleContentLocalState.initial()
    : this(
        status: DismissibleContentLocalStatus.loading,
        trackedKeys: const [],
        dismissedByKey: const {},
      );

  bool isDismissed(DismissibleContentKey key) {
    return dismissedByKey[key] ?? false;
  }

  DismissibleContentLocalState copyWith({
    DismissibleContentLocalStatus? status,
    List<DismissibleContentKey>? trackedKeys,
    Map<DismissibleContentKey, bool>? dismissedByKey,
  }) {
    return DismissibleContentLocalState(
      status: status ?? this.status,
      trackedKeys: trackedKeys ?? this.trackedKeys,
      dismissedByKey: dismissedByKey ?? this.dismissedByKey,
    );
  }

  @override
  List<Object?> get props => [
    status,
    trackedKeys,
    dismissedByKey,
  ];
}
