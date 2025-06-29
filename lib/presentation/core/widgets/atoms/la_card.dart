import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

enum CardType {
  main,
  secondary,
}

extension _CardTypeExtension on CardType {
  Color get backgroundColor {
    return switch (this) {
      CardType.main => LaTheme.surface(),
      CardType.secondary => LaTheme.secondaryContainer(),
    };
  }

  double get elevation {
    return switch (this) {
      CardType.main => LaElevation.medium,
      CardType.secondary => LaElevation.minimal,
    };
  }
}

class LaCard extends StatelessWidget {
  final Widget child;
  final CardType type;

  const LaCard({
    super.key,
    required this.child,
    this.type = CardType.main,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(LaCornerRadius.large);
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: const BorderSide(color: Colors.transparent),
      ),
      elevation: type.elevation,
      shadowColor: LaTheme.shadow(),
      color: LaTheme.surface(),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}
