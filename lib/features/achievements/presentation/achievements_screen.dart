import 'package:flutter/material.dart';

import '../../../core/assets/app_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/zen_app_scaffold.dart';
import '../../../core/widgets/zen_header.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const badges = [
      ('First Breath', true),
      ('Focused Path', true),
      ('Persistent Lotus', true),
      ('Dawn Work', false),
      ('Quiet Week', false),
      ('Satori', false),
      ('Deep Streak', false),
      ('Bell Keeper', false),
      ('Zen Master', false),
    ];

    return ZenAppScaffold(
      currentIndex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ZenHeader(title: 'Achievements', showBack: false),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 6, 22, 110),
              children: [
                const Text(
                  'Path to Satori',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 23),
                ),
                const SizedBox(height: 22),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: badges.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.92,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 18,
                  ),
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    return _Badge(title: badge.$1, unlocked: badge.$2);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.title, required this.unlocked});

  final String title;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _BadgeRingPainter(unlocked: unlocked),
            child: Center(
              child: unlocked
                  ? Image.asset(AppAssets.lotus, width: 54)
                  : const Icon(Icons.lock, size: 34, color: AppTheme.paper),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          unlocked ? '$title\n(Unlocked)' : title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: unlocked ? AppTheme.ink : AppTheme.inkSoft,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _BadgeRingPainter extends CustomPainter {
  const _BadgeRingPainter({required this.unlocked});

  final bool unlocked;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = unlocked
          ? AppTheme.ink.withValues(alpha: 0.78)
          : AppTheme.inkSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.shortestSide - 12,
      height: size.shortestSide - 12,
    );
    canvas.drawArc(rect, 0.35, 5.1, false, paint);
    if (!unlocked) {
      final fill = Paint()..color = AppTheme.ink.withValues(alpha: 0.45);
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.shortestSide / 3,
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BadgeRingPainter oldDelegate) {
    return oldDelegate.unlocked != unlocked;
  }
}
