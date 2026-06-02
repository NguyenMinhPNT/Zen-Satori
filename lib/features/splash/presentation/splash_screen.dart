import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/domain/app_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isPressed = false;
  bool _isNavigating = false;

  Future<void> _begin() async {
    if (_isNavigating) return;

    final preferences = context.read<AppPreferences>();

    setState(() {
      _isPressed = false;
      _isNavigating = true;
    });

    await HapticFeedback.lightImpact();
    await preferences.setHasBegun(true);

    if (!mounted) return;
    context.go('/home');
  }

  void _setPressed(bool value) {
    if (_isPressed == value || _isNavigating) return;

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final titleSize = (width * 0.145).clamp(36.0, 50.0);
          final subtitleSize = (width * 0.078).clamp(21.0, 30.0);
          final titleSpacing = (height * 0.012).clamp(4.0, 10.0);
          final topInset = (height * 0.095).clamp(42.0, 84.0);
          final buttonWidth = (width * 0.44).clamp(170.0, 220.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppAssets.splashBackground, fit: BoxFit.cover),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: topInset),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Zen Satori', style: kaushan(size: titleSize)),
                        SizedBox(height: titleSpacing),
                        Text(
                          'Deep Work Tracker',
                          style: kaushan(size: subtitleSize),
                        ),
                      ],
                    ),
                    const Spacer(flex: 3),
                    Semantics(
                      button: true,
                      label: 'Tap to Begin',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (_) => _setPressed(true),
                        onTapUp: (_) => _begin(),
                        onTapCancel: () => _setPressed(false),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 90),
                          opacity: _isPressed ? 0.72 : 1.0,
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 90),
                            scale: _isPressed ? 0.96 : 1.0,
                            curve: Curves.easeOut,
                            child: SizedBox(
                              width: buttonWidth,
                              child: Image.asset(
                                AppAssets.tapToBeginButton,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: (height * 0.045).clamp(20.0, 40.0)),
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
