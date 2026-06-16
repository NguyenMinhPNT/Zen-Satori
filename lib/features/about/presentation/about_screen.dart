import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/zen_app_scaffold.dart';
import '../../../core/widgets/zen_header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZenAppScaffold(
      drawer: const AppDrawer(currentSection: AppDrawerSection.about),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ZenHeader(
            title: 'About',
            showBack: false,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: Scaffold.of(context).openDrawer,
                  icon: const Icon(Icons.menu_rounded, size: 30),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              children: const [
                _AboutHeroCard(),
                SizedBox(height: 20),
                _AboutInfoCard(
                  title: 'Zen Satori',
                  body:
                      'Rooted in the science of chronobiology and behavioral psychology, Zen Satori acts as your silent Guru. We guide you toward your perfect peak performance through structured deep work and mindful rest.',
                ),
                SizedBox(height: 14),
                _AboutInfoCard(
                  title: 'What You Can Do',
                  body:
                      'Conquer your projects and build mental endurance through guided sessions. Honestly log your interruptions, and awaken the mythical guardian beasts within as you grow.',
                ),
                SizedBox(height: 14),
                _AboutInfoCard(
                  title: 'Design Direction',
                  body:
                      'We stripped away the noise of industrial design. Like a Haiku, Zen Satori has no unnecessary strokes. Natural earth tones and the resonance of a singing bowl help you enter a state of deep focus instantly.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutHeroCard extends StatelessWidget {
  const _AboutHeroCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(colors.paperWarm, colors.paper, 0.2) ?? colors.paperWarm,
            Color.lerp(colors.mist, colors.paperWarm, 0.55) ?? colors.mist,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.ink.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Icon(Icons.self_improvement_rounded, size: 56, color: colors.ink),
          const SizedBox(height: 14),
          Text(
            'Master your mind flow.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Zen Satori transforms demanding work into a mindful practice, sharpening your focus into a powerful tool.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.45, color: colors.inkSoft),
          ),
        ],
      ),
    );
  }
}

class _AboutInfoCard extends StatelessWidget {
  const _AboutInfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.paper.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.ink.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: colors.ink.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}
