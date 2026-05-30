part of '../sign_up_page.dart';

class _IosKeyboardAccessoryBar extends StatelessWidget {
  final bool isEmailFocused;
  final void Function() onNext;
  final void Function() onDone;

  const _IosKeyboardAccessoryBar({
    required this.isEmailFocused,
    required this.onNext,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final String label = isEmailFocused ? S.of(context).wizard_next : S.of(context).global_done;
    final void Function() action = isEmailFocused ? onNext : onDone;

    return LaMaterialAtom(
      color: LaTheme.background(),
      child: LaRow(
        children: [
          const LaExpandedAtom(child: LaSizedBoxAtom.shrink()),
          LaCupertinoButtonAtom(
            padding: const EdgeInsets.symmetric(
              horizontal: LaPadding.medium,
              vertical: LaPadding.small,
            ),
            onPressed: action,
            child: LaTextAtom(
              label,
              style: LaTextAtomStyle.body16.primary,
            ),
          ),
        ],
      ),
    );
  }
}
