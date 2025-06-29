///
/// * author: hunghd
/// * email: hunghd.yb@gmail.com
///
/// A package provides an easy way to add shimmer effect to Flutter application

// ignore_for_file: unused_element

part of 'la_loading_box.dart';

///
/// An enum defines all supported directions of shimmer effect
///
/// * [_ShimmerDirection.ltr] left to right direction
/// * [_ShimmerDirection.rtl] right to left direction
/// * [_ShimmerDirection.ttb] top to bottom direction
/// * [_ShimmerDirection.btt] bottom to top direction
///
enum _ShimmerDirection { btt, ltr, rtl, ttb }

///
/// A widget renders shimmer effect over [child] widget tree.
///
/// [child] defines an area that shimmer effect blends on. You can build [child]
/// from whatever [Widget] you like but there're some notices in order to get
/// exact expected effect and get better rendering performance:
///
/// * Use static [Widget] (which is an instance of [StatelessWidget]).
/// * [Widget] should be a solid color element. Every colors you set on these
/// [Widget]s will be overridden by colors of [gradient].
/// * Shimmer effect only affects to opaque areas of [child], transparent areas
/// still stays transparent.
///
/// [period] controls the speed of shimmer effect. The default value is 1500
/// milliseconds.
///
/// [direction] controls the direction of shimmer effect. The default value
/// is [_ShimmerDirection.ltr].
///
/// [gradient] controls colors of shimmer effect.
///
/// [loop] the number of animation loop, set value of `0` to make animation run
/// forever.
///
/// [enabled] controls if shimmer effect is active. When set to false the animation
/// is paused
///
///
/// ## Pro tips:
///
/// * [child] should be made of basic and simple [Widget]s, such as [Container],
/// [Row] and [Column], to avoid side effect.
///
/// * use one [_Shimmer] to wrap list of [Widget]s instead of a list of many [_Shimmer]s
///
@immutable
class _Shimmer extends StatefulWidget {
  final Widget child;
  final Gradient gradient;

  const _Shimmer({
    required this.child,
    required this.gradient,
  });

  ///
  /// A convenient constructor provides an easy and convenient way to create a
  /// [_Shimmer] which [gradient] is [LinearGradient] made up of `baseColor` and
  /// `highlightColor`.
  ///
  _Shimmer.fromColors({
    required this.child,
    required Color baseColor,
    required Color highlightColor,
  }) : gradient = LinearGradient(
    begin: Alignment.topLeft,
    colors: <Color>[baseColor, baseColor, highlightColor, baseColor, baseColor],
    stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
  );

  @override
  _ShimmerInternalState createState() {
    return _ShimmerInternalState();
  }
}

class _ShimmerInternalState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = 0;
    _controller = AnimationController(vsync: this, duration: 1500.milliseconds)
      ..addStatusListener((AnimationStatus status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        _count++;
        if (0 <= 0) {
          _controller.repeat();
        } else if (_count < 0) {
          _controller.forward(from: 0.0);
        }
      });
    _controller.forward(from: 0.5);
  }

  @override
  void didUpdateWidget(_Shimmer oldWidget) {
    _controller.forward();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) => _ShimmerInternal(
        direction: _ShimmerDirection.ltr,
        gradient: widget.gradient,
        percent: _controller.value,
        child: child,
      ),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _ShimmerInternal extends SingleChildRenderObjectWidget {
  final double? percent;
  final _ShimmerDirection? direction;
  final Gradient gradient;

  const _ShimmerInternal({
    super.child,
    this.percent,
    this.direction,
    required this.gradient,
  });

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, direction, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  final _ShimmerDirection? _direction;
  Gradient _gradient;
  double? _percent;

  _ShimmerFilter(this._percent, this._direction, this._gradient);

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double? newValue) {
    assert(newValue != null);
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  double? get percent => _percent;

  set gradient(Gradient? newValue) {
    assert(newValue != null);
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue!;
    markNeedsPaint();
  }

  Gradient? get gradient => _gradient;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child!.size.width;
      final double height = child!.size.height;
      Rect rect;
      double dx;
      double dy;
      if (_direction == _ShimmerDirection.rtl) {
        dx = _offset(width, -width, _percent ?? 0);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      } else if (_direction == _ShimmerDirection.ttb) {
        dx = 0.0;
        dy = _offset(-height, height, _percent ?? 0);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else if (_direction == _ShimmerDirection.btt) {
        dx = 0.0;
        dy = _offset(height, -height, _percent ?? 0);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else {
        dx = _offset(-width, width, _percent ?? 0);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      }
      layer ??= ShaderMaskLayer();
      layer!
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
