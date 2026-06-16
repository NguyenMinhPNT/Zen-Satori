import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ZenAppScaffold extends StatelessWidget {
  const ZenAppScaffold({
    super.key,
    required this.child,
    this.drawer,
    this.bottomNavigationBar,
    this.useSafeArea = true,
  });

  final Widget child;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      drawer: drawer,
      extendBody: bottomNavigationBar != null,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.paper,
              Color.lerp(colors.paper, colors.paperWarm, 0.7) ?? colors.paper,
            ],
          ),
        ),
        child: useSafeArea ? SafeArea(child: child) : child,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
