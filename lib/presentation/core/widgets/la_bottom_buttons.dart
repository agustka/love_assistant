import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:la/presentation/core/widgets/import.dart';

enum BottomButtonsStyle {
  sideBySide,
  sandwich,
}

@immutable
class BottomButtonsDefinition extends Equatable {
  final String drawerHeading;
  final BottomButtonsStyle type;
  final bool loading;
  final bool showDropShadow;
  final List<BottomButtonDefinition> buttons;
  final Widget? aboveButtonsWidget;
  final bool addBottomPadding;
  final bool exit;
  final bool shouldPushOnKeyboard;
  final Color? background;

  const BottomButtonsDefinition({
    this.buttons = const [],
    this.aboveButtonsWidget,
    this.addBottomPadding = true,
    this.showDropShadow = true,
    this.type = BottomButtonsStyle.sideBySide,
    this.drawerHeading = "",
    this.background,
    this.loading = false,
    this.exit = false,
    this.shouldPushOnKeyboard = true,
  });

  @override
  List<Object?> get props => [
        drawerHeading,
        type,
        loading,
        buttons,
        aboveButtonsWidget,
        exit,
        shouldPushOnKeyboard,
        background,
        addBottomPadding,
        showDropShadow,
      ];
}

@immutable
class BottomButtonDefinition extends Equatable {
  final String text;
  final String? drawerText;
  final String? icon;
  final bool enabled;
  final bool busy;
  final Key? key;
  final void Function() onTap;
  final void Function()? onDisabledTap;

  const BottomButtonDefinition({
    required this.text,
    required this.onTap,
    this.drawerText,
    this.enabled = true,
    this.busy = false,
    this.icon,
    this.onDisabledTap,
    this.key,
  });

  factory BottomButtonDefinition.empty() {
    return BottomButtonDefinition(text: "", onTap: () {});
  }

  @override
  List<Object?> get props => [
        key,
        text,
        drawerText,
        icon,
        enabled,
        busy,
        onTap,
        onDisabledTap,
      ];
}

class LaBottomButtons extends StatefulWidget {
  static const Key bottomButtonsMoreButtonKey = Key("bottomButtonsMoreButtonKey");
  static double bottomPadding = LaPadding.medium;

  final BottomButtonsDefinition buttons;

  final bool shouldPushOnKeyboard;

  static double getBottomButtonsHeight({BottomButtonsStyle style = BottomButtonsStyle.sideBySide}) {
    return switch (style) {
      BottomButtonsStyle.sideBySide => LaButton.buttonHeight + LaPadding.bottomPadding + bottomPadding,
      BottomButtonsStyle.sandwich => (LaButton.buttonHeight * 2) + (LaPadding.bottomPadding * 3) + bottomPadding,
    };
  }

  const LaBottomButtons({
    super.key,
    required this.buttons,
    this.shouldPushOnKeyboard = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _LaBottomButtonsState();
  }
}

class _LaBottomButtonsState extends State<LaBottomButtons> with WidgetsBindingObserver, TickerProviderStateMixin {
  BottomButtonsDefinition get _buttons => widget.buttons;

  @override
  Widget build(BuildContext context) {
    if (widget.buttons.buttons.isEmpty && widget.buttons.aboveButtonsWidget == null) {
      return const SizedBox.shrink();
    }

    final double padding = MediaQuery.of(context).padding.bottom;
    if (padding < LaPadding.extraLarge) {
      LaBottomButtons.bottomPadding = padding + LaPadding.medium;
    } else {
      LaBottomButtons.bottomPadding = padding + LaPadding.extraSmall;
    }

    final bool padBottom = (widget.buttons.buttons.isNotEmpty || widget.buttons.aboveButtonsWidget != null) &&
        widget.buttons.addBottomPadding;

    return Material(
      color: widget.buttons.background ?? LaTheme.background(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.buttons.aboveButtonsWidget == null) const SizedBox(height: LaPadding.small),

          widget.buttons.aboveButtonsWidget ?? const SizedBox.shrink(),

          if (widget.buttons.buttons.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
              child: SizedBox(
                width: double.infinity,
                child: _getMainButtonEntries(context),
              ),
            ),

          if (padBottom) SizedBox(height: LaBottomButtons.bottomPadding),

          // Pushes buttons up for keyboard
          if (widget.shouldPushOnKeyboard && padBottom)
            SizedBox(height: max(0, MediaQuery.of(context).viewInsets.bottom)),
        ],
      ),
    );
  }

  Widget _getMainButtonEntries(BuildContext context) {
    switch (widget.buttons.type) {
      case BottomButtonsStyle.sideBySide:
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _getSideBySideButtons(context),
          ),
        );
      case BottomButtonsStyle.sandwich:
        return LaSeparatedColumn(
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: LaPadding.medium);
          },
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._getSandwichButtons(context),
          ],
        );
    }
  }

  List<Widget> _getSandwichButtons(BuildContext context) {
    return _buttons.buttons.map(
      (BottomButtonDefinition button) {
        final int index = _buttons.buttons.indexOf(button);
        return _loadingIndicator(
          child: LaButton(
            key: button.key,
            buttonStyle: index == 0 ? LaButtonStyle.primary : LaButtonStyle.secondary,
            text: button.text,
            maxLines: 1,
            onTap: button.onTap,
            enabled: button.enabled,
            busy: button.busy,
            onDisabledTap: button.onDisabledTap,
          ),
        );
      },
    ).toList();
  }

  List<Widget> _getSideBySideButtons(BuildContext context) {
    int flex = 50;
    int overflowFlex = 18;
    if (_buttons.buttons.length > 2) {
      flex = 41;
    }

    if (Accessibility.of(context).isInAccessibilityMode) {
      overflowFlex = 20;
      flex = 100;
      if (_buttons.buttons.length > 1) {
        flex = 80;
      }
    }

    final List<Widget> entries = [];
    int cnt = 0;
    for (final BottomButtonDefinition button in _buttons.buttons) {
      if (Accessibility.of(context).isInAccessibilityMode && cnt > 0) {
        break;
      }
      if (cnt > 1) {
        break;
      }
      if (cnt > 0) {
        entries.add(const SizedBox(width: 10));
      }
      cnt++;
      entries.add(
        Flexible(
          flex: flex,
          child: _loadingIndicator(
            child: LaButton(
              key: button.key,
              text: button.text,
              buttonStyle: cnt == 1 ? LaButtonStyle.primary : LaButtonStyle.secondary,
              maxLines: 2,
              onTap: button.onTap,
              enabled: button.enabled,
              busy: button.busy,
              onDisabledTap: button.onDisabledTap,
            ),
          ),
        ),
      );
    }
    final bool shouldDisplayMoreButton =
        _buttons.buttons.length > 2 || (Accessibility.of(context).isInAccessibilityMode && _buttons.buttons.length > 1);
    if (shouldDisplayMoreButton) {
      entries.add(const SizedBox(width: 10));
      entries.add(
        Flexible(
          flex: overflowFlex,
          child: _loadingIndicator(
            child: Semantics(
              container: true,
              button: true,
              label: S.of(context).global_more,
              child: ExcludeSemantics(
                child: LaButton(
                  key: LaBottomButtons.bottomButtonsMoreButtonKey,
                  onTap: () => _showOverflowOptions(context),
                  buttonStyle: LaButtonStyle.secondary,
                  icon: LaIcons.more,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return entries.reversed.toList();
  }

  Widget _loadingIndicator({required Widget child}) {
    if (widget.buttons.loading) {
      return IgnorePointer(
        child: LaLoadingBox(
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: child,
          ),
        ),
      );
    }
    return child;
  }

  Widget _getIgnorePointer({required Widget child}) {
    return IgnorePointer(child: child);
  }

  TextStyle _getButtonTextStyle({required BuildContext context}) {
    final TextStyle regular = LaTheme.font.body16.bold;
    final Accessibility accessibility = Accessibility.of(context);
    switch (accessibility.size) {
      case AccessibilitySize.small:
      case AccessibilitySize.normal:
      case AccessibilitySize.large:
        return regular;
      case AccessibilitySize.huge:
        return LaTheme.font.body12;
    }
  }

  TextStyle _getHeadingTextStyle({required BuildContext context}) {
    final TextStyle regular = LaTheme.font.body20.bold;
    final Accessibility accessibility = Accessibility.of(context);
    switch (accessibility.size) {
      case AccessibilitySize.small:
      case AccessibilitySize.normal:
      case AccessibilitySize.large:
        return regular;
      case AccessibilitySize.huge:
        return LaTheme.font.body16;
    }
  }

  Widget _excludeMainSemantics({
    required Widget child,
    required bool excludeChildren,
    String? label,
    void Function()? onTap,
  }) {
    if (!MediaQuery.of(context).accessibleNavigation) {
      return child;
    }
    return ExcludeSemantics(child: child);
  }

  void _showOverflowOptions(BuildContext context) {
    List<BottomButtonDefinition> overflowing = [];
    if (Accessibility.of(context).isInAccessibilityMode) {
      if (widget.buttons.buttons.length == 1) {
        return;
      }
      overflowing = widget.buttons.buttons.sublist(1);
    } else {
      if (widget.buttons.buttons.length == 2) {
        return;
      }
      overflowing = widget.buttons.buttons.sublist(2);
    }
    /*
    LaBottomDrawer.fromTemplate(
      builder: (BuildContext context) {
        return SafeArea(
          child: LaSeparatedColumn(
            mainAxisSize: MainAxisSize.min,
            separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: LaPadding.medium),
              child: LaDivider(),
            ),
            children: overflowing
                .map(
                  (BottomButtonDefinition button) => LaTapVisual(
                    key: button.key,
                    onTap: () {
                      Navigator.pop(context);
                      getIt<IPollAndDebounce>().delayCall(
                        delay: 200.milliseconds,
                        action: button.onTap,
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                        top: LaPadding.medium,
                        bottom: LaPadding.medium,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: LaPadding.medium),
                          if (button.icon != null) ...[
                            LaSvg(
                              button.icon!,
                              width: 24,
                              height: 24,
                              color: button.enabled ? LaTheme.onSurface() : LaTheme.onSurface().withValues(alpha: 155),
                            ),
                            const SizedBox(width: 16),
                          ],
                          Expanded(
                            child: LaText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              button.drawerText ?? button.text,
                              style: _getButtonTextStyle(context: context).copyWith(
                                color:
                                    button.enabled ? LaTheme.onSurface() : LaTheme.onSurface().withValues(alpha: 155),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
    */
  }
}
