import "package:flutter/material.dart";
import "package:la/presentation/core/ui_components/atoms/import.dart";

enum LaAuthIllustrationSize {
  small,
  medium,
  large,
}

class LaAuthIllustrationMolecule extends StatelessWidget {
  final String illustration;
  final LaAuthIllustrationSize size;

  const LaAuthIllustrationMolecule({
    super.key,
    required this.illustration,
    this.size = LaAuthIllustrationSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double illustrationSize = _sizeFactor * width;

    return LaCenterAtom(
      child: LaImageAtom(
        imageLink: illustration,
        width: illustrationSize,
        height: illustrationSize,
      ),
    );
  }

  double get _sizeFactor {
    switch (size) {
      case LaAuthIllustrationSize.small:
        return 0.36;
      case LaAuthIllustrationSize.medium:
        return 0.48;
      case LaAuthIllustrationSize.large:
        return 0.60;
    }
  }
}
