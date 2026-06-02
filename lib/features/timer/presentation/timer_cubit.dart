import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/session_repository.dart';

enum TimerPhase {
  idle,
  workRunning,
  workPaused,
  workCompleteAwaitingRelax,
  relaxRunning,
  relaxPaused,
  sessionFinished,
}

class TimerState extends Equatable {
  const TimerState({
    this.phase = TimerPhase.idle,
    this.remainingSeconds = TimerCubit.workSeconds,
    this.projectId,
    this.workStartedAt,
    this.workPersisted = false,
  });

  final TimerPhase phase;
  final int remainingSeconds;
  final int? projectId;
  final DateTime? workStartedAt;
  final bool workPersisted;

  bool get isRunning {
    return phase == TimerPhase.workRunning || phase == TimerPhase.relaxRunning;
  }

  String get displayTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  TimerState copyWith({
    TimerPhase? phase,
    int? remainingSeconds,
    int? projectId,
    DateTime? workStartedAt,
    bool? workPersisted,
    bool clearProject = false,
  }) {
    return TimerState(
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

class TimerCubit extends Cubit<TimerState> {
  TimerCubit(this._sessionRepository) : super(const TimerState());

  static const workSeconds = 25 * 60;
  static const relaxSeconds = 5 * 60;

  final SessionRepository _sessionRepository;
  Timer? _ticker;

  void startWork(int projectId) {
    _ticker?.cancel();
    emit(
      TimerState(
        phase: TimerPhase.workRunning,
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
        phase: state.phase == TimerPhase.workRunning
            ? TimerPhase.workPaused
            : TimerPhase.relaxPaused,
      ),
    );
  }

  void resume() {
    if (state.phase == TimerPhase.workPaused) {
      emit(state.copyWith(phase: TimerPhase.workRunning));
      _startTicker();
    } else if (state.phase == TimerPhase.relaxPaused) {
      emit(state.copyWith(phase: TimerPhase.relaxRunning));
      _startTicker();
    }
  }

  void startRelax() {
    _ticker?.cancel();
    emit(
      state.copyWith(
        phase: TimerPhase.relaxRunning,
        remainingSeconds: relaxSeconds,
      ),
    );
    _startTicker();
  }

  void reset() {
    _ticker?.cancel();
    emit(const TimerState());
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
    if (state.phase == TimerPhase.workRunning) {
      await _completeWork();
      return;
    }
    _ticker?.cancel();
    emit(
      state.copyWith(phase: TimerPhase.sessionFinished, remainingSeconds: 0),
    );
  }

  Future<void> _completeWork() async {
    _ticker?.cancel();
    if (!state.workPersisted && state.projectId != null) {
      await _sessionRepository.createCompletedWorkSession(
        projectId: state.projectId!,
        startedAt: state.workStartedAt ?? DateTime.now(),
        endedAt: DateTime.now(),
      );
    }
    emit(
      state.copyWith(
        phase: TimerPhase.workCompleteAwaitingRelax,
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
