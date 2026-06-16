import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class InkSwitch extends StatelessWidget {
  const InkSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: CustomPaint(
        painter: _SwitchPainter(value: value, colors: colors),
        child: SizedBox(
          width: 68,
          height: 34,
          child: Align(
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 29,
              height: 29,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                color: value
                    ? Color.lerp(colors.sage, colors.paper, 0.6) ?? colors.sage
                    : colors.mist,
                shape: BoxShape.circle,
                border: Border.all(color: colors.inkSoft, width: 1.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchPainter extends CustomPainter {
  const _SwitchPainter({required this.value, required this.colors});

  final bool value;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.ink.withValues(alpha: value ? 0.72 : 0.36)
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(12, size.height / 2),
      Offset(size.width - 12, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SwitchPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.colors != colors;
  }
}
