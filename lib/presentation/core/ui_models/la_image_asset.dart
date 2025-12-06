import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class LaImageAsset extends Equatable {
  final String asset;

  const LaImageAsset({required this.asset});

  @override
  List<Object?> get props => [
    asset,
  ];
}
