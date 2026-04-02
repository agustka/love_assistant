import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LaPagerOrganism extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function(int index)? onDotClicked;
  final PageController? controller;
  final ScrollPhysics? physics;

  const LaPagerOrganism({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onDotClicked,
    this.controller,
    this.physics,
  });

  @override
  State<StatefulWidget> createState() {
    return _LaPagerOrganismState();
  }
}

class _LaPagerOrganismState extends State<LaPagerOrganism> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LaColumnAtom(
      children: [
        LaExpandedAtom(
          child: LaPageViewAtom(
            controller: widget.controller ?? _controller,
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
            physics: widget.physics,
          ),
        ),
        const LaSizedBoxAtom(height: LaPadding.extraSmall),
        SmoothPageIndicator(
          controller: widget.controller ?? _controller,
          count: widget.itemCount,
          effect: SwapEffect(
            type: SwapType.yRotation,
            activeDotColor: LaTheme.primary(),
            dotColor: LaTheme.singleElement(),
          ),
          onDotClicked: widget.onDotClicked,
        ),
      ],
    );
  }
}
