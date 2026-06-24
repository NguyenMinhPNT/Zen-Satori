import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/quotes/quote_entry.dart';
import '../../../core/quotes/quote_repository.dart';
import '../domain/session_repository.dart';
import '../domain/session_models.dart';

enum PomodoroTimerPhase {
  idle,
  workRunning,
  workPaused,
  workCompleteAwaitingRelax,
  relaxRunning,
  relaxPaused,
  sessionFinished,
}

class PomodoroTimerState extends Equatable {
  const PomodoroTimerState({
    this.phase = PomodoroTimerPhase.idle,
    this.remainingSeconds = PomodoroTimerCubit.workSeconds,
    this.projectId,
    this.workStartedAt,
    this.workPersisted = false,
    this.activeQuote,
  });

  final PomodoroTimerPhase phase;
  final int remainingSeconds;
  final int? projectId;
  final DateTime? workStartedAt;
  final bool workPersisted;
  final QuoteEntry? activeQuote;

  bool get isRunning {
    return phase == PomodoroTimerPhase.workRunning ||
        phase == PomodoroTimerPhase.relaxRunning;
  }

  String get displayTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  PomodoroTimerState copyWith({
    PomodoroTimerPhase? phase,
    int? remainingSeconds,
    int? projectId,
    DateTime? workStartedAt,
    bool? workPersisted,
    QuoteEntry? activeQuote,
    bool clearProject = false,
    bool clearQuote = false,
  }) {
    return PomodoroTimerState(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      projectId: clearProject ? null : projectId ?? this.projectId,
      workStartedAt: workStartedAt ?? this.workStartedAt,
      workPersisted: workPersisted ?? this.workPersisted,
      activeQuote: clearQuote ? null : activeQuote ?? this.activeQuote,
    );
  }

  @override
  List<Object?> get props {
    return [
      phase,
      remainingSeconds,
      projectId,
      workStartedAt,
      workPersisted,
      activeQuote,
    ];
  }
}

class PomodoroTimerCubit extends Cubit<PomodoroTimerState> {
  PomodoroTimerCubit(
    this._sessionRepository, {
    required QuoteRepository quoteRepository,
  }) : _quoteRepository = quoteRepository,
       super(const PomodoroTimerState());

  static const workSeconds = 25 * 60;
  static const relaxSeconds = 5 * 60;

  final SessionRepository _sessionRepository;
  final QuoteRepository _quoteRepository;
  Timer? _ticker;
  int _startRequestId = 0;

  Future<void> startWork(int projectId, {Locale? locale}) async {
    _ticker?.cancel();
    final requestId = ++_startRequestId;
    emit(
      PomodoroTimerState(
        phase: PomodoroTimerPhase.workRunning,
        remainingSeconds: workSeconds,
        projectId: projectId,
        workStartedAt: DateTime.now(),
      ),
    );
    _startTicker();
    try {
      final activeQuote = await _quoteRepository.pickRandom(locale: locale);
      if (requestId != _startRequestId || isClosed) {
        return;
      }
      emit(state.copyWith(activeQuote: activeQuote));
    } catch (error, stackTrace) {
      debugPrint('Failed to load Pomodoro quote: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void pause() {
    if (!state.isRunning) {
      return;
    }
    _ticker?.cancel();
    emit(
      state.copyWith(
        phase: state.phase == PomodoroTimerPhase.workRunning
            ? PomodoroTimerPhase.workPaused
            : PomodoroTimerPhase.relaxPaused,
      ),
    );
  }

  void resume() {
    if (state.phase == PomodoroTimerPhase.workPaused) {
      emit(state.copyWith(phase: PomodoroTimerPhase.workRunning));
      _startTicker();
    } else if (state.phase == PomodoroTimerPhase.relaxPaused) {
      emit(state.copyWith(phase: PomodoroTimerPhase.relaxRunning));
      _startTicker();
    }
  }

  void startRelax() {
    _ticker?.cancel();
    emit(
      state.copyWith(
        phase: PomodoroTimerPhase.relaxRunning,
        remainingSeconds: relaxSeconds,
      ),
    );
    _startTicker();
  }

  void reset() {
    _ticker?.cancel();
    _startRequestId += 1;
    emit(const PomodoroTimerState());
  }

  Future<void> elapseSeconds(int seconds) async {
    for (var index = 0; index < seconds; index += 1) {
      await _tick();
      if (!state.isRunning) {
        break;
      }
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  Future<void> _tick() async {
    if (!state.isRunning) {
      return;
    }
    final next = state.remainingSeconds - 1;
    if (next > 0) {
      emit(state.copyWith(remainingSeconds: next));
      return;
    }
    if (state.phase == PomodoroTimerPhase.workRunning) {
      await _completeWork();
      return;
    }
    _ticker?.cancel();
    emit(
      state.copyWith(
        phase: PomodoroTimerPhase.sessionFinished,
        remainingSeconds: 0,
      ),
    );
  }

  Future<void> _completeWork() async {
    _ticker?.cancel();
    if (!state.workPersisted && state.projectId != null) {
      await _sessionRepository.createCompletedFocusBlock(
        projectId: state.projectId!,
        startedAt: state.workStartedAt ?? DateTime.now(),
        endedAt: DateTime.now(),
        mode: FocusSessionMode.pomodoro,
      );
    }
    emit(
      state.copyWith(
        phase: PomodoroTimerPhase.workCompleteAwaitingRelax,
        remainingSeconds: 0,
        workPersisted: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
