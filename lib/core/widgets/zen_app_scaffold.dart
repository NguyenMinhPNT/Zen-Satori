import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class ZenAppScaffold extends StatelessWidget {
  const ZenAppScaffold({
    super.key,
    required this.child,
    this.currentIndex = 0,
    this.showBottomNav = true,
  });

  final Widget child;
  final int currentIndex;
  final bool showBottomNav;

  static const _routes = [
    '/home',
    '/projects',
    '/stats',
    '/achievements',
    '/settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.paper, Color(0xFFF7F5EE)],
          ),
        ),
        child: SafeArea(child: child),
      ),
      bottomNavigationBar: showBottomNav
          ? _InkBottomNav(
              currentIndex: currentIndex,
              onTap: (index) => context.go(_routes[index]),
            )
          : null,
    );
  }
}

class _InkBottomNav extends StatelessWidget {
  const _InkBottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.work_outline, Icons.work, 'Work'),
      (Icons.folder_outlined, Icons.folder, 'Projects'),
      (Icons.bar_chart_outlined, Icons.bar_chart, 'Stats'),
      (Icons.emoji_events_outlined, Icons.emoji_events, 'Achievements'),
      (Icons.settings_outlined, Icons.settings, 'Settings'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomPaint(
          painter: _InkBarPainter(),
          child: Container(
            height: 76,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                for (var index = 0; index < items.length; index += 1)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? AppTheme.paper.withValues(alpha: 0.10)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: index == currentIndex
                            ? Border.all(
                                color: AppTheme.sage.withValues(alpha: 0.35),
                                width: 1,
                              )
                            : null,
                      ),
                      child: InkWell(
                        onTap: () => onTap(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              index == currentIndex
                                  ? items[index].$2
                                  : items[index].$1,
                              color: index == currentIndex
                                  ? AppTheme.paper
                                  : AppTheme.mist,
                              size: index == currentIndex ? 27 : 24,
                            ),
                            const SizedBox(height: 3),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                items[index].$3,
                                style: TextStyle(
                                  color: index == currentIndex
                                      ? AppTheme.paper
                                      : AppTheme.mist,
                                  fontSize: 11,
                                  fontWeight: index == currentIndex
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InkBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.ink.withValues(alpha: 0.84)
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(0, 8, size.width, size.height - 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
