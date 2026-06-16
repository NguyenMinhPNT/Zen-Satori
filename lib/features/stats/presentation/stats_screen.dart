import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/zen_app_scaffold.dart';
import '../../../core/widgets/zen_header.dart';
import '../../timer/domain/session_metrics.dart';
import '../../timer/domain/session_repository.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZenAppScaffold(
      drawer: const AppDrawer(currentSection: AppDrawerSection.stats),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ZenHeader(
            title: 'Stats',
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
            child: StreamBuilder<List<FocusSession>>(
              stream: context.read<SessionRepository>().watchSessions(),
              builder: (context, snapshot) {
                final sessions = snapshot.data ?? const <FocusSession>[];
                final daily = _lastSevenDays(sessions);
                final colors = AppTheme.of(context);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Insights', style: TextStyle(fontSize: 25)),
                        Text('Last 7 Days', style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 250,
                      child: _StatsChart(minutes: daily, colors: colors),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 150,
                      child: _HeatMap(sessions: sessions, colors: colors),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<int> _lastSevenDays(List<FocusSession> sessions) {
    final today = DateTime.now();
    return List.generate(7, (offset) {
      final day = today.subtract(Duration(days: 6 - offset));
      return sessions
          .where((session) => _sameDay(session.startedAt, day))
          .fold<int>(0, (total, session) {
            return total + workedMinutesForSession(session);
          });
    });
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _StatsChart extends StatelessWidget {
  const _StatsChart({required this.minutes, required this.colors});

  final List<int> minutes;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StatsChartPainter(minutes, colors),
      child: const SizedBox.expand(),
    );
  }
}

class _StatsChartPainter extends CustomPainter {
  const _StatsChartPainter(this.minutes, this.colors);

  final List<int> minutes;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = colors.ink.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    for (var index = 0; index < 5; index += 1) {
      final y = 18 + (size.height - 48) * index / 4;
      canvas.drawLine(Offset(36, y), Offset(size.width - 8, y), axis);
    }

    final maxValue = (minutes.fold<int>(
      0,
      (a, b) => a > b ? a : b,
    )).clamp(60, 240);
    final barPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors.ink.withValues(alpha: 0.92),
          colors.mist.withValues(alpha: 0.9),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final linePaint = Paint()
      ..color = colors.sage
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path();

    for (var index = 0; index < minutes.length; index += 1) {
      final x = 48 + index * ((size.width - 72) / 6);
      final barHeight = (size.height - 64) * minutes[index] / maxValue;
      final top = size.height - 38 - barHeight;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 8, top, 16, barHeight),
          const Radius.circular(4),
        ),
        barPaint,
      );
      final point = Offset(x, top + 10);
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(path, linePaint);

    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var index = 0; index < labels.length; index += 1) {
      final x = 48 + index * ((size.width - 72) / 6);
      textPainter.text = TextSpan(
        text: labels[index],
        style: TextStyle(color: colors.ink, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 22),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StatsChartPainter oldDelegate) {
    return oldDelegate.minutes != minutes || oldDelegate.colors != colors;
  }
}

class _HeatMap extends StatelessWidget {
  const _HeatMap({required this.sessions, required this.colors});

  final List<FocusSession> sessions;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeatMapPainter(sessions, colors),
      child: const SizedBox.expand(),
    );
  }
}

class _HeatMapPainter extends CustomPainter {
  const _HeatMapPainter(this.sessions, this.colors);

  final List<FocusSession> sessions;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    const rows = 4;
    const columns = 16;
    final cell = (size.width - 42) / columns;
    for (var row = 0; row < rows; row += 1) {
      for (var column = 0; column < columns; column += 1) {
        final strength = ((row + column + sessions.length) % 5) / 4;
        final paint = Paint()
          ..color = Color.lerp(colors.mist, colors.ink, strength * 0.8)!;
        canvas.drawRect(
          Rect.fromLTWH(
            36 + column * cell,
            18 + row * (cell + 3),
            cell - 3,
            cell - 3,
          ),
          paint,
        );
      }
    }
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    const labels = ['00:00', '05:00', '12:00', '15:00'];
    for (var index = 0; index < labels.length; index += 1) {
      textPainter.text = TextSpan(
        text: labels[index],
        style: TextStyle(color: colors.ink, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, 14 + index * (cell + 3)));
    }
  }

  @override
  bool shouldRepaint(covariant _HeatMapPainter oldDelegate) {
    return oldDelegate.sessions.length != sessions.length ||
        oldDelegate.colors != colors;
  }
}
