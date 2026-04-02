import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

class LaBannerOrganism extends StatelessWidget {
  final String asset;

  const LaBannerOrganism({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height * 0.15;
    final double width = MediaQuery.sizeOf(context).width;
    return LaImageAtom(
      imageLink: asset,
      fit: BoxFit.scaleDown,
      width: width,
      height: height,
    );
  }
}
