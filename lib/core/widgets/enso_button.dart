import 'package:flutter/material.dart';

import '../assets/app_assets.dart';

class EnsoButton extends StatefulWidget {
  const EnsoButton({
    super.key,
    required this.onPressed,
    this.size = 220,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final double size;
  final bool enabled;

  @override
  State<EnsoButton> createState() => _EnsoButtonState();
}

class _EnsoButtonState extends State<EnsoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final splashColor = theme.colorScheme.primary.withValues(alpha: 0.12);
    final highlightColor = theme.colorScheme.primary.withValues(alpha: 0.06);

    return Opacity(
      opacity: widget.enabled ? 1 : 0.42,
      child: SizedBox.square(
        dimension: widget.size,
        child: Material(
          type: MaterialType.transparency,
          child: AnimatedScale(
            scale: _isPressed ? 0.965 : 1,
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            child: InkWell(
              onTap: widget.enabled ? widget.onPressed : null,
              onHighlightChanged: (value) {
                if (_isPressed != value) {
                  setState(() => _isPressed = value);
                }
              },
              customBorder: const CircleBorder(),
              splashColor: splashColor,
              highlightColor: highlightColor,
              child: Ink.image(
                image: const AssetImage(AppAssets.startSessionButton),
                fit: BoxFit.contain,
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
