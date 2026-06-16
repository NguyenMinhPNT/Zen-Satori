import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/domain/app_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _titleColor = Color(0xFFC62828);

  bool _isNavigating = false;

  Future<void> _begin() async {
    if (_isNavigating) return;

    final preferences = context.read<AppPreferences>();

    setState(() {
      _isNavigating = true;
    });

    await HapticFeedback.lightImpact();
    await preferences.setHasBegun(true);

    if (!mounted) return;
    context.go('/home?tab=flowtime');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      backgroundColor: colors.paper,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final titleSize = (width * 0.17).clamp(40.0, 62.0);
          final subtitleSize = (width * 0.096).clamp(24.0, 36.0);
          final titleSpacing = (height * 0.008).clamp(2.0, 8.0);
          final topInset = (height * 0.12).clamp(72.0, 120.0);
          final artworkWidth = (width * 1.02).clamp(320.0, 520.0);
          final artworkBottom = (height * 0.085).clamp(54.0, 100.0);
          final buttonFontSize = (width * 0.088).clamp(28.0, 38.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: colors.paper),
              Positioned(
                left: (width - artworkWidth) / 2,
                right: (width - artworkWidth) / 2,
                bottom: artworkBottom,
                child: IgnorePointer(
                  child: Image.asset(
                    AppAssets.splashArtwork,
                    width: artworkWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: topInset),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Zen Satori',
                          style: kaushan(size: titleSize, color: _titleColor),
                        ),
                        SizedBox(height: titleSpacing),
                        Text(
                          'Deep Work Tracker',
                          style: kaushan(size: subtitleSize),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _isNavigating ? null : _begin,
                      style: TextButton.styleFrom(
                        foregroundColor: colors.ink,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        'Tap here to Begin',
                        style: kaushan(
                          size: buttonFontSize,
                          color: const Color.fromARGB(255, 221, 14, 14),
                        ),
                      ),
                    ),
                    SizedBox(height: (height * 0.06).clamp(30.0, 60.0)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
