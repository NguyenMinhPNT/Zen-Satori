import 'package:flutter/material.dart';

import '../assets/app_assets.dart';

class EnsoButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.42,
      child: SizedBox.square(
        dimension: size,
        child: InkResponse(
          onTap: enabled ? onPressed : null,
          radius: size / 2,
          child: Image.asset(AppAssets.startSessionButton, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
