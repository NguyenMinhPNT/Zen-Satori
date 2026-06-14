import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

class ZenHeader extends StatelessWidget {
  const ZenHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.leading,
    this.trailing,
  });

  final String title;
  final bool showBack;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child:
                leading ??
                (showBack
                    ? IconButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home?tab=flowtime');
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                      )
                    : null),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: kaushan(size: 34),
            ),
          ),
          SizedBox(width: 48, child: trailing),
        ],
      ),
    );
  }
}
