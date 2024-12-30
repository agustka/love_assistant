part of 'splash_cubit.dart';

enum SplashStatus {
  loading,
  loaded,
  error;
}

@immutable
class SplashState extends Equatable {
  final SplashStatus status;

  const SplashState({required this.status});

  const SplashState.initial() : this(status: SplashStatus.loading);

  SplashState copyWith({
    SplashStatus? status,
  }) {
    return SplashState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
      ];
}
