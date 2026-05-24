import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:la/infrastructure/core/platform/platform_detector.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart' hide LaPaddingAtom;
import 'package:la/presentation/core/ui_components/import.dart';

enum LaButtonSize {
  normal,
  mini,
}

enum LaButtonStyle {
  primary,
  secondary,
}

class LaButtonAtom extends StatelessWidget {
  static const double buttonHeight = 53;
  static const double miniButtonHeight = 34;

  final VoidCallback onTap;
  final String? text;
  final IconData? icon;
  final bool enabled;
  final bool busy;
  final bool loading;
  final VoidCallback? onDisabledTap;
  final LaButtonStyle buttonStyle;
  final LaButtonSize size;
  final int? maxLines;
  final String? semanticLabel;

  bool get isIOS => PlatformDetector.isIOS;

  const LaButtonAtom({
    Key? key,
    required VoidCallback onTap,
    String? text,
    IconData? icon,
    bool enabled = true,
    bool busy = false,
    bool loading = false,
    VoidCallback? onDisabledTap,
    int? maxLines,
    String? semanticLabel,
    LaButtonStyle buttonStyle = LaButtonStyle.primary,
    LaButtonSize size = LaButtonSize.normal,
  }) : this._(
          key: key,
          onTap: onTap,
          text: text,
          icon: icon,
          enabled: enabled,
          busy: busy,
          loading: loading,
          onDisabledTap: onDisabledTap,
          buttonStyle: buttonStyle,
          size: size,
          maxLines: maxLines,
          semanticLabel: semanticLabel,
        );

  const LaButtonAtom._({
    super.key,
    required this.onTap,
    this.text,
    this.icon,
    this.enabled = true,
    this.busy = false,
    this.loading = false,
    this.onDisabledTap,
    required this.buttonStyle,
    required this.size,
    this.maxLines,
    this.semanticLabel,
  });

  const LaButtonAtom.mini({
    Key? key,
    required VoidCallback onTap,
    String? text,
    IconData? icon,
    bool enabled = true,
    bool busy = false,
    VoidCallback? onDisabledTap,
    LaButtonStyle buttonStyle = LaButtonStyle.primary,
    int? maxLines,
    String? semanticLabel,
  }) : this._(
          key: key,
          onTap: onTap,
          text: text,
          icon: icon,
          enabled: enabled,
          busy: busy,
          onDisabledTap: onDisabledTap,
          buttonStyle: buttonStyle,
          size: LaButtonSize.mini,
          maxLines: maxLines,
          semanticLabel: semanticLabel,
        );

  @override
  Widget build(BuildContext context) {
    final _LaButtonColorPalette colors = _LaButtonColorPalette.fromButtonStyle(buttonStyle);

    Widget child;
    if (busy) {
      child = Center(
        child: LaDotLoaderAtom(
          color: colors.busyColor,
          size: LaSize.large,
        ),
      );
    } else {
      final Color textColor = colors.getTextColor(enabled);
      final bool hasText = text?.isNotEmpty ?? false;
      final bool hasIcon = icon != null;

      if (hasIcon && !hasText) {
        child = Center(
          child: Icon(
            icon,
            size: size.iconSize,
            color: textColor,
          ),
        );
      } else {
        child = Padding(
          padding: const EdgeInsets.all(LaPadding.small),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: size.iconSize,
                  color: textColor,
                ),
              if (icon != null && hasText) const SizedBox(width: LaPadding.small),
              if (hasText)
                Flexible(
                  child: LaTextAtom(
                    text ?? "",
                    maxLines: maxLines,
                    overflow: maxLines != null ? TextOverflow.ellipsis : null,
                    textAlign: TextAlign.center,
                    style: size.getTextStyle(buttonStyle: buttonStyle, enabled: enabled),
                  ),
                ),
            ],
          ),
        );
      }
    }

    final VoidCallback onTap = busy ? () {} : ((enabled ? this.onTap : onDisabledTap) ?? () {});

    return PlatformDetector.isIOS
        ? SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              onPressed: onTap,
              color: colors.enabledBackgroundColor,
              sizeStyle: CupertinoButtonSize.medium,
              child: child,
            ),
          )
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                elevation: LaElevation.minimal,
                padding: EdgeInsets.zero,
                side: BorderSide(color: colors.enabledBorderColor),
                backgroundColor: colors.enabledBackgroundColor,
                foregroundColor: colors.enabledTextColor,
                disabledBackgroundColor: colors.disabledBackgroundColor,
                disabledForegroundColor: colors.disabledTextColor,
              ),
              child: child,
            ),
          );
  }
}

class _LaButtonColorPalette {
  final Color enabledTextColor;
  final Color enabledBackgroundColor;
  final Color enabledBorderColor;
  final Color enabledSplashColor;
  final Color disabledTextColor;
  final Color disabledBackgroundColor;
  final Color disabledBorderColor;
  final Color disabledSplashColor;
  final Color busyColor;

  const _LaButtonColorPalette._({
    required this.enabledTextColor,
    required this.enabledBackgroundColor,
    required this.enabledBorderColor,
    required this.enabledSplashColor,
    required this.disabledTextColor,
    required this.disabledBackgroundColor,
    required this.disabledBorderColor,
    required this.disabledSplashColor,
    required this.busyColor,
  });

  factory _LaButtonColorPalette.fromButtonStyle(LaButtonStyle style) => switch (style) {
        LaButtonStyle.primary => _LaButtonColorPalette.primary(),
        LaButtonStyle.secondary => _LaButtonColorPalette.secondary(),
      };

  factory _LaButtonColorPalette.primary() => _LaButtonColorPalette._(
        enabledTextColor: LaTheme.onPrimary(),
        enabledBackgroundColor: LaTheme.primary(),
        enabledBorderColor: Colors.transparent,
        enabledSplashColor: LaTheme.onPrimary(),
        disabledTextColor: LaTheme.hintText(),
        disabledBackgroundColor: LaTheme.primary().withValues(alpha: 155),
        disabledBorderColor: Colors.transparent,
        disabledSplashColor: LaTheme.onPrimary().withValues(alpha: 155),
        busyColor: LaTheme.onPrimary(),
      );

  factory _LaButtonColorPalette.secondary() => _LaButtonColorPalette._(
        enabledTextColor: LaTheme.onTertiaryContainer(),
        enabledBackgroundColor: LaTheme.tertiaryContainer(),
        enabledBorderColor:  Colors.transparent,
        enabledSplashColor: LaTheme.onSecondaryContainer(),
        disabledTextColor: LaTheme.hintText(),
        disabledBackgroundColor: LaTheme.tertiaryContainer(),
        disabledBorderColor: Colors.transparent,
        disabledSplashColor: LaTheme.onTertiaryContainer(),
        busyColor: LaTheme.onTertiaryContainer(),
      );

  Color getTextColor(bool enabled) => enabled ? enabledTextColor : disabledTextColor;

  Color getBackgroundColor(bool enabled) => enabled ? enabledBackgroundColor : disabledBackgroundColor;

  Color getBorderColor(bool enabled) => enabled ? enabledBorderColor : disabledBorderColor;

  Color getSplashColor(bool enabled, bool iOS) => iOS
      ? Colors.transparent
      : enabled
          ? enabledSplashColor
          : disabledSplashColor;
}

extension _LaButtonSizeX on LaButtonSize {
  double get width => switch (this) {
        LaButtonSize.normal => double.infinity,
        LaButtonSize.mini => 0,
      };

  double get height => switch (this) {
        LaButtonSize.normal => LaButtonAtom.buttonHeight,
        LaButtonSize.mini => LaButtonAtom.miniButtonHeight,
      };

  double get borderRadius => switch (this) {
        LaButtonSize.normal => LaCornerRadius.large,
        LaButtonSize.mini => LaCornerRadius.extraSmall,
      };

  double get iconSize => switch (this) {
        LaButtonSize.normal => LaSize.large,
        LaButtonSize.mini => LaSize.medium,
      };

  LaTextAtomStyle getTextStyle({required LaButtonStyle buttonStyle, required bool enabled}) {
    final LaTextAtomStyle sizeStyle = switch (this) {
      LaButtonSize.normal => LaTextAtomStyle.body16,
      LaButtonSize.mini => LaTextAtomStyle.body14,
    };

    if (!enabled) {
      return sizeStyle.hintText;
    }

    return switch (buttonStyle) {
      LaButtonStyle.primary => sizeStyle.onPrimary,
      LaButtonStyle.secondary => sizeStyle.onTertiaryContainer,
    };
  }
}
