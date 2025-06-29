import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/infrastructure/core/time/i_poll_and_debounce.dart';
import 'package:la/presentation/core/widgets/import.dart';
import 'package:la/setup.dart';

class LaTapVisual extends StatefulWidget {
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;
  final ShapeBorder? customBorder;
  final Function()? onTap;
  final Function()? onLongPress;
  final Widget child;
  final Color? splashColor;
  final Color? highlightColor;
  final Color backgroundColor;
  final BuildContext? overrideContext;
  final bool enabled;
  final bool excludeFromSemantics;
  final bool useDebounce;
  final Duration? debounceTime;
  final bool noEffects;

  const LaTapVisual({
    super.key,
    required this.onTap,
    required this.child,
    this.onLongPress,
    this.borderRadius,
    this.shape,
    this.customBorder,
    this.splashColor,
    this.highlightColor,
    this.overrideContext,
    this.debounceTime,
    this.backgroundColor = Colors.transparent,
    this.enabled = true,
    this.excludeFromSemantics = false,
    this.useDebounce = true,
    this.noEffects = false,
  });

  @override
  State<StatefulWidget> createState() => _IsbTapVisualState();
}

class _IsbTapVisualState extends State<LaTapVisual> {
  late final IPollAndDebounce _debouncer;

  @override
  void initState() {
    super.initState();

    _debouncer = getIt<IPollAndDebounce>();
  }

  @override
  void dispose() {
    _debouncer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext defaultContext) {
    if (!widget.enabled) {
      return widget.child;
    }
    if (PlatformDetector.isIOS) {
      return _LaCupertinoTappable(
        onTap: () {
          if (widget.useDebounce) {
            _debouncer.delayCall(
              delay: Duration(milliseconds: widget.debounceTime?.inMilliseconds ?? 100),
              action: () {
                widget.onTap?.call();
              },
            );
          } else {
            widget.onTap?.call();
          }
        },
        onLongPress: widget.onLongPress,
        excludeFromSemantics: widget.excludeFromSemantics,
        child: Semantics(
          button: true,
          container: true,
          child: Material(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius,
            shape: widget.shape,
            child: widget.child,
          ),
        ),
      );
    } else {
      return Semantics(
        button: true,
        container: true,
        child: Material(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          shape: widget.shape,
          child: InkWell(
            borderRadius: widget.borderRadius,
            customBorder: widget.customBorder,
            splashColor:
            widget.noEffects ? Colors.transparent : widget.splashColor ?? LaTheme.secondaryContainer(),
            highlightColor: widget.noEffects ? Colors.transparent : widget.highlightColor,
            onTap: () {
              if (widget.useDebounce) {
                _debouncer.delayCall(
                  delay: Duration(milliseconds: widget.debounceTime?.inMilliseconds ?? 100),
                  action: () {
                    widget.onTap?.call();
                  },
                );
              } else {
                widget.onTap?.call();
              }
            },
            onLongPress: widget.onLongPress,
            excludeFromSemantics: widget.excludeFromSemantics,
            child: widget.child,
          ),
        ),
      );
    }
  }
}

class _LaCupertinoTappable extends StatefulWidget {
  final Function()? onTap;
  final Function()? onLongPress;
  final Widget child;
  final bool excludeFromSemantics;

  const _LaCupertinoTappable({
    this.onTap,
    this.onLongPress,
    required this.child,
    this.excludeFromSemantics = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _LaCupertinoTappableState();
  }
}

class _LaCupertinoTappableState extends State<_LaCupertinoTappable> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.onTap == null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onCancelTap,
        onLongPressUp: widget.onLongPress,
        excludeFromSemantics: widget.excludeFromSemantics,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 80),
          opacity: tapped ? 0.4 : 1,
          child: widget.child,
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      tapped = true;
    });
  }

  void _onCancelTap() {
    setState(() {
      tapped = false;
    });
  }

  Future _onTapUp(TapUpDetails details) async {
    setState(() {
      tapped = false;
    });
    await Future.delayed(const Duration(milliseconds: 100));
    widget.onTap?.call();
  }
}
