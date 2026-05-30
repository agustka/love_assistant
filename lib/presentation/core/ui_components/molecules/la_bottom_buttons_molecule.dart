import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart' hide LaPaddingAtom;
import 'package:la/presentation/core/ui_components/atoms/la_padding_atom.dart';
import 'package:la/presentation/core/ui_components/import.dart';
import 'package:la/presentation/core/ui_components/molecules/import.dart';
import 'package:la/presentation/core/ui_components/templates/import.dart';

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
  final Widget? belowButtonsWidget;
  final bool addBottomPadding;
  final bool exit;
  final bool shouldPushOnKeyboard;
  final Color? background;
  final double bottomPadding;

  const BottomButtonsDefinition({
    this.buttons = const [],
    this.aboveButtonsWidget,
    this.belowButtonsWidget,
    this.addBottomPadding = true,
    this.showDropShadow = true,
    this.type = BottomButtonsStyle.sideBySide,
    this.drawerHeading = "",
    this.background,
    this.loading = false,
    this.exit = false,
    this.shouldPushOnKeyboard = true,
    this.bottomPadding = 0,
  });

  BottomButtonsDefinition copyWith({
    String? drawerHeading,
    BottomButtonsStyle? type,
    bool? loading,
    bool? showDropShadow,
    List<BottomButtonDefinition>? buttons,
    Widget? aboveButtonsWidget,
    Widget? belowButtonsWidget,
    bool? addBottomPadding,
    bool? exit,
    bool? shouldPushOnKeyboard,
    Color? background,
    double? bottomPadding,
  }) {
    return BottomButtonsDefinition(
      drawerHeading: drawerHeading ?? this.drawerHeading,
      type: type ?? this.type,
      loading: loading ?? this.loading,
      showDropShadow: showDropShadow ?? this.showDropShadow,
      buttons: buttons ?? this.buttons,
      aboveButtonsWidget: aboveButtonsWidget ?? this.aboveButtonsWidget,
      belowButtonsWidget: belowButtonsWidget ?? this.belowButtonsWidget,
      addBottomPadding: addBottomPadding ?? this.addBottomPadding,
      exit: exit ?? this.exit,
      shouldPushOnKeyboard: shouldPushOnKeyboard ?? this.shouldPushOnKeyboard,
      background: background ?? this.background,
      bottomPadding: bottomPadding ?? this.bottomPadding,
    );
  }

  @override
  List<Object?> get props => [
    drawerHeading,
    type,
    loading,
    buttons,
    aboveButtonsWidget,
    belowButtonsWidget,
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
  final IconData? icon;
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
  List<Object?> get props => [key, text, drawerText, icon, enabled, busy, onTap, onDisabledTap];
}

class LaBottomButtonsMolecule extends StatefulWidget {
  static const Key bottomButtonsMoreButtonKey = Key("bottomButtonsMoreButtonKey");
  static double bottomPadding = LaPadding.medium;

  final BottomButtonsDefinition buttons;
  final bool shouldPushOnKeyboard;

  static double getBottomButtonsHeight({BottomButtonsStyle style = BottomButtonsStyle.sideBySide}) {
    return switch (style) {
      BottomButtonsStyle.sideBySide => LaButtonAtom.buttonHeight + LaPadding.bottomPadding + bottomPadding,
      BottomButtonsStyle.sandwich => (LaButtonAtom.buttonHeight * 2) + (LaPadding.bottomPadding * 3) + bottomPadding,
    };
  }

  const LaBottomButtonsMolecule({super.key, required this.buttons, this.shouldPushOnKeyboard = true});

  @override
  State<StatefulWidget> createState() {
    return _LaBottomButtonsMoleculeState();
  }
}

class _LaBottomButtonsMoleculeState extends State<LaBottomButtonsMolecule> with WidgetsBindingObserver, TickerProviderStateMixin {
  BottomButtonsDefinition get _buttons => widget.buttons;

  @override
  Widget build(BuildContext context) {
    if (widget.buttons.buttons.isEmpty &&
        widget.buttons.aboveButtonsWidget == null &&
        widget.buttons.belowButtonsWidget == null) {
      return const LaSizedBoxAtom.shrink();
    }

    if (widget.buttons.bottomPadding < LaPadding.extraLarge) {
      LaBottomButtonsMolecule.bottomPadding = widget.buttons.bottomPadding + LaPadding.medium;
    } else {
      LaBottomButtonsMolecule.bottomPadding = widget.buttons.bottomPadding + LaPadding.extraSmall;
    }

    return LaMaterialAtom(
      color: widget.buttons.background ?? LaTheme.background(),
      child: LaColumnAtom(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.buttons.aboveButtonsWidget == null) const LaSizedBoxAtom(height: LaPadding.small),

          widget.buttons.aboveButtonsWidget ?? const LaSizedBoxAtom.shrink(),

          if (widget.buttons.buttons.isNotEmpty)
            LaPaddingAtom(
              padding: const EdgeInsets.only(left: LaPadding.medium, right: LaPadding.medium),
              child: LaSizedBoxAtom(width: double.infinity, child: _getMainButtonEntries(context)),
            ),

          widget.buttons.belowButtonsWidget ?? const LaSizedBoxAtom.shrink(),

          LaSizedBoxAtom(height: LaBottomButtonsMolecule.bottomPadding),

          // Pushes buttons up for keyboard
          if (widget.shouldPushOnKeyboard) LaSizedBoxAtom(height: max(0, MediaQuery.of(context).viewInsets.bottom)),
        ],
      ),
    );
  }

  Widget _getMainButtonEntries(BuildContext context) {
    switch (widget.buttons.type) {
      case BottomButtonsStyle.sideBySide:
        return LaIntrinsicHeightAtom(
          child: LaRow(crossAxisAlignment: CrossAxisAlignment.stretch, children: _getSideBySideButtons(context)),
        );
      case BottomButtonsStyle.sandwich:
        return LaSeparatedColumnMolecule(
          separatorBuilder: (BuildContext context, int index) {
            return const LaSizedBoxAtom(height: LaPadding.small);
          },
          mainAxisSize: MainAxisSize.min,
          children: [..._getSandwichButtons(context)],
        );
    }
  }

  List<Widget> _getSandwichButtons(BuildContext context) {
    final double buttonHeight = max(
      LaButtonAtom.buttonHeight,
      MediaQuery.textScalerOf(context).scale(LaButtonAtom.buttonHeight),
    );
    return _buttons.buttons.map((BottomButtonDefinition button) {
      final int index = _buttons.buttons.indexOf(button);
      return LaSizedBoxAtom(
        height: buttonHeight,
        child: _loadingIndicator(
          child: LaButtonAtom(
            key: button.key,
            buttonStyle: index == 0 ? LaButtonStyle.primary : LaButtonStyle.secondary,
            text: button.text,
            maxLines: 1,
            onTap: button.onTap,
            enabled: button.enabled,
            busy: button.busy,
            onDisabledTap: button.onDisabledTap,
          ),
        ),
      );
    }).toList();
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
        entries.add(const LaSizedBoxAtom(width: LaPadding.small));
      }
      cnt++;
      entries.add(
        LaFlexibleAtom(
          flex: flex,
          child: _loadingIndicator(
            child: LaButtonAtom(
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
      entries.add(const LaSizedBoxAtom(width: LaPadding.small));
      entries.add(
        LaFlexibleAtom(
          flex: overflowFlex,
          child: _loadingIndicator(
            child: LaButtonAtom(
              key: LaBottomButtonsMolecule.bottomButtonsMoreButtonKey,
              onTap: () => _showOverflowOptions(context),
              buttonStyle: LaButtonStyle.secondary,
              icon: LaIcons.more,
            ),
          ),
        ),
      );
    }

    return entries.reversed.toList();
  }

  Widget _loadingIndicator({required Widget child}) {
    if (widget.buttons.loading) {
      return LaIgnorePointerAtom(
        child: LaLoadingBoxAtom(child: LaPaddingAtom.all(value: 1, child: child)),
      );
    }
    return child;
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

    LaBottomDrawerTemplate.show(
      context: context,
      config: BottomDrawerConfig(
        heading: S.of(context).global_more,
        entries: overflowing
            .map((BottomButtonDefinition e) => BottomDrawerEntry(text: e.text, onTap: e.onTap, icon: e.icon))
            .toList(),
      ),
    );
  }
}
