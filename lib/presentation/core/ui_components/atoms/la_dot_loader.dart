import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:la/presentation/core/ui_components/import.dart';

class LaDotLoader extends StatefulWidget {
  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;
  final int dots;

  const LaDotLoader({
    super.key,
    this.color,
    this.size = 30.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1400),
    this.controller,
    this.dots = 3,
  });

  @override
  State createState() => _LaDotLoaderState();
}

class _LaDotLoaderState extends State<LaDotLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(widget.size * widget.dots, widget.size),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.dots, (int i) {
          return ScaleTransition(
            scale: _LaDelayTween(begin: 0.0, end: 1.0, delay: i * .2).animate(_controller),
            child: SizedBox.fromSize(
              size: Size.square(widget.size * 0.5),
              child: _itemBuilder(i),
            ),
          );
        }),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder!(context, index)
        : DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color ?? LaTheme.primary(),
              shape: BoxShape.circle,
            ),
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _LaDelayTween extends Tween<double> {
  final double delay;

  _LaDelayTween({super.begin, super.end, required this.delay});

  @override
  double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
