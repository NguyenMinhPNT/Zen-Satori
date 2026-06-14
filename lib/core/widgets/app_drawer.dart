import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_tab.dart';
import '../theme/app_theme.dart';

enum AppDrawerSection { home, achievements, stats, settings }

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.currentSection});

  final AppDrawerSection currentSection;
  static const _titleColor = Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.paper,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Zen Satori',
                      style: kaushan(size: 25, color: _titleColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _DrawerTile(
                icon: Icons.home_outlined,
                title: 'Home',
                selected: currentSection == AppDrawerSection.home,
                onTap: () => _go(context, HomeTab.flowtime.location),
              ),
              _DrawerTile(
                icon: Icons.emoji_events_outlined,
                title: 'Achievements',
                selected: currentSection == AppDrawerSection.achievements,
                onTap: () => _go(context, '/achievements'),
              ),
              _DrawerTile(
                icon: Icons.bar_chart_outlined,
                title: 'Stats',
                selected: currentSection == AppDrawerSection.stats,
                onTap: () => _go(context, '/stats'),
              ),
              _DrawerTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                selected: currentSection == AppDrawerSection.settings,
                onTap: () => _go(context, '/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String location) {
    Navigator.of(context).pop();
    if (GoRouterState.of(context).uri.toString() != location) {
      context.go(location);
    }
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: selected
            ? AppTheme.mist.withValues(alpha: 0.65)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppTheme.ink),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
