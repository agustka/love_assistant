import 'package:flutter/material.dart';
import 'package:la/presentation/core/theme/la_theme.dart';
import 'package:la/presentation/core/ui_components/atoms/import.dart';

class LaLinkPromptMolecule extends StatelessWidget {
  final String prompt;
  final String actionText;
  final Key? promptKey;
  final Key? actionKey;
  final VoidCallback onTap;

  const LaLinkPromptMolecule({
    super.key,
    required this.prompt,
    required this.actionText,
    this.promptKey,
    this.actionKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle promptStyle = LaTheme.font.body16;
    final TextStyle actionStyle = LaTheme.font.body16.copyWith(fontWeight: FontWeight.w700);
    final Color actionColor = actionStyle.color ?? LaTheme.onSurface();

    return LaCenterAtom(
      child: LaTapVisualAtom(
        onTap: onTap,
        child: LaConstrainedBoxAtom(
          constraints: const BoxConstraints(minHeight: 48),
          child: LaCenterAtom(
            child: LaWrapAtom(
              alignment: WrapAlignment.center,
              spacing: LaPadding.extraSmall,
              runSpacing: LaPadding.extraSmall,
              children: [
                Text(prompt, key: promptKey, style: promptStyle, textAlign: TextAlign.center),
                _LinkLabel(
                  key: actionKey,
                  text: actionText,
                  style: actionStyle,
                  underlineColor: actionColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkLabel extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color underlineColor;

  const _LinkLabel({
    super.key,
    required this.text,
    required this.style,
    required this.underlineColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: LaColumnAtom(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: style),
          const LaSizedBoxAtom(height: LaPadding.extraSmall),
          SizedBox(
            width: double.infinity,
            height: 1,
            child: CustomPaint(
              painter: _DashedUnderlinePainter(color: underlineColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedUnderlinePainter extends CustomPainter {
  final Color color;

  const _DashedUnderlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double x = 0;
    while (x < size.width) {
      final double endX = (x + 3).clamp(0, size.width).toDouble();
      canvas.drawLine(Offset(x, size.height / 2), Offset(endX, size.height / 2), paint);
      x += 5;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedUnderlinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
