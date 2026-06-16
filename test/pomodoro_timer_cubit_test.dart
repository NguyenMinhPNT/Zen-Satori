import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zen_satori/core/database/app_database.dart';
import 'package:zen_satori/core/quotes/quote_category.dart';
import 'package:zen_satori/core/quotes/quote_entry.dart';
import 'package:zen_satori/core/quotes/quote_repository.dart';
import 'package:zen_satori/features/projects/domain/project_repository.dart';
import 'package:zen_satori/features/timer/domain/session_repository.dart';
import 'package:zen_satori/features/timer/presentation/timer_cubit.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('Pomodoro startWork assigns a quote', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = SessionRepository(database);
    final projectId = await ProjectRepository(
      database,
    ).createProject(title: 'Practice', targetMinutes: 60);
    final cubit = PomodoroTimerCubit(
      repository,
      quoteRepository: _FakeQuoteRepository(_sampleQuote),
    );

    await cubit.startWork(projectId);

    expect(cubit.state.activeQuote, _sampleQuote);

    await cubit.close();
    await database.close();
  });

  test('Pomodoro preserves the selected quote through pause, resume, and relax', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = SessionRepository(database);
    final projectId = await ProjectRepository(
      database,
    ).createProject(title: 'Practice', targetMinutes: 60);
    final cubit = PomodoroTimerCubit(
      repository,
      quoteRepository: _FakeQuoteRepository(_sampleQuote),
    );

    await cubit.startWork(projectId);
    final selectedQuote = cubit.state.activeQuote;

    cubit.pause();
    expect(cubit.state.activeQuote, selectedQuote);

    cubit.resume();
    expect(cubit.state.activeQuote, selectedQuote);

    cubit.startRelax();
    expect(cubit.state.activeQuote, selectedQuote);

    await cubit.close();
    await database.close();
  });

  test('Pomodoro reset clears the selected quote', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = SessionRepository(database);
    final projectId = await ProjectRepository(
      database,
    ).createProject(title: 'Practice', targetMinutes: 60);
    final cubit = PomodoroTimerCubit(
      repository,
      quoteRepository: _FakeQuoteRepository(_sampleQuote),
    );

    await cubit.startWork(projectId);
    expect(cubit.state.activeQuote, isA<QuoteEntry>());

    cubit.reset();

    expect(cubit.state.activeQuote, equals(null));

    await cubit.close();
    await database.close();
  });
}

const _sampleQuote = QuoteEntry(
  id: 'focus-001',
  text: 'Stay with the work.',
  author: 'Anonymous',
  category: QuoteCategory.focus,
);

class _FakeQuoteRepository implements QuoteRepository {
  const _FakeQuoteRepository(this.quote);

  final QuoteEntry quote;

  @override
  Future<List<QuoteEntry>> getQuotes({QuoteCategory? category, Locale? locale}) {
    if (category != null && quote.category != category) {
      return Future.value(const <QuoteEntry>[]);
    }
    return Future.value(<QuoteEntry>[quote]);
  }

  @override
  Future<QuoteEntry?> pickRandom({
    QuoteCategory? category,
    Locale? locale,
    random,
  }) async {
    final quotes = await getQuotes(category: category, locale: locale);
    return quotes.isEmpty ? null : quotes.first;
  }
}
