import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  });

  final PomodoroTimerPhase phase;
  final int remainingSeconds;
  final int? projectId;
  final DateTime? workStartedAt;
  final bool workPersisted;

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
    bool clearProject = false,
  }) {
    return PomodoroTimerState(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      projectId: clearProject ? null : projectId ?? this.projectId,
      workStartedAt: workStartedAt ?? this.workStartedAt,
      workPersisted: workPersisted ?? this.workPersisted,
    );
  }

  @override
  List<Object?> get props {
    return [phase, remainingSeconds, projectId, workStartedAt, workPersisted];
  }
}

class PomodoroTimerCubit extends Cubit<PomodoroTimerState> {
  PomodoroTimerCubit(this._sessionRepository)
    : super(const PomodoroTimerState());

  static const workSeconds = 25 * 60;
  static const relaxSeconds = 5 * 60;

  final SessionRepository _sessionRepository;
  Timer? _ticker;

  void startWork(int projectId) {
    _ticker?.cancel();
    emit(
      PomodoroTimerState(
        phase: PomodoroTimerPhase.workRunning,
        remainingSeconds: workSeconds,
        projectId: projectId,
        workStartedAt: DateTime.now(),
      ),
    );
    _startTicker();
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
