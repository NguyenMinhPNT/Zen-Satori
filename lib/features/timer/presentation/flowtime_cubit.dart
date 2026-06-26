import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/session_metrics.dart';
import '../domain/session_models.dart';
import '../domain/session_repository.dart';

enum FlowtimePhase {
  idle,
  focusing,
  focusPaused,
  breakSuggested,
  breakRunning,
  breakPaused,
  finished,
}

class FlowtimeInterruption extends Equatable {
  const FlowtimeInterruption({
    required this.type,
    required this.label,
    this.note,
    required this.startedAt,
    this.endedAt,
  });

  final SessionInterruptionType type;
  final String label;
  final String? note;
  final DateTime startedAt;
  final DateTime? endedAt;

  bool get isActive => endedAt == null;
  bool get isDistraction => type == SessionInterruptionType.distraction;

  FlowtimeInterruption end(DateTime value) {
    return FlowtimeInterruption(
      type: type,
      label: label,
      note: note,
      startedAt: startedAt,
      endedAt: value,
    );
  }

  SessionInterruptionDraft toDraft() {
    return SessionInterruptionDraft(
      type: type,
      label: label,
      note: note,
      startedAt: startedAt,
      endedAt: endedAt ?? startedAt,
    );
  }

  @override
  List<Object?> get props => [type, label, note, startedAt, endedAt];
}

class FlowtimeCompletedBlock extends Equatable {
  const FlowtimeCompletedBlock({
    required this.startedAt,
    required this.endedAt,
    required this.workedMinutes,
    required this.suggestedBreakMinutes,
    required this.interruptions,
  });

  final DateTime startedAt;
  final DateTime endedAt;
  final int workedMinutes;
  final int suggestedBreakMinutes;
  final List<FlowtimeInterruption> interruptions;

  @override
  List<Object?> get props => [
    startedAt,
    endedAt,
    workedMinutes,
    suggestedBreakMinutes,
    interruptions,
  ];
}

class FlowtimeState extends Equatable {
  const FlowtimeState({
    required this.phase,
    required this.displayNow,
    this.projectId,
    this.focusStartedAt,
    this.focusElapsedBeforePause = Duration.zero,
    this.breakStartedAt,
    this.breakRemainingBeforePause = Duration.zero,
    this.suggestedBreakMinutes = 0,
    this.activeInterruption,
    this.currentBlockInterruptions = const [],
    this.completedBlocks = const [],
  });

  factory FlowtimeState.initial(DateTime now) {
    return FlowtimeState(phase: FlowtimePhase.idle, displayNow: now);
  }

  final FlowtimePhase phase;
  final DateTime displayNow;
  final int? projectId;
  final DateTime? focusStartedAt;
  final Duration focusElapsedBeforePause;
  final DateTime? breakStartedAt;
  final Duration breakRemainingBeforePause;
  final int suggestedBreakMinutes;
  final FlowtimeInterruption? activeInterruption;
  final List<FlowtimeInterruption> currentBlockInterruptions;
  final List<FlowtimeCompletedBlock> completedBlocks;

  bool get isFocusRunning => phase == FlowtimePhase.focusing;
  bool get isBreakRunning => phase == FlowtimePhase.breakRunning;
  bool get isBreakPhase =>
      phase == FlowtimePhase.breakSuggested ||
      phase == FlowtimePhase.breakRunning ||
      phase == FlowtimePhase.breakPaused;
  DateTime? get currentFocusBlockStartedAt {
    if (projectId == null) {
      return null;
    }
    final anchor = focusStartedAt ?? displayNow;
    return anchor.subtract(focusElapsedBeforePause);
  }

  Duration get focusElapsed {
    if (phase == FlowtimePhase.focusing && focusStartedAt != null) {
      return focusElapsedBeforePause + displayNow.difference(focusStartedAt!);
    }
    return focusElapsedBeforePause;
  }

  int get focusElapsedSeconds =>
      focusElapsed.inSeconds < 0 ? 0 : focusElapsed.inSeconds;

  int get breakRemainingSeconds {
    if (phase == FlowtimePhase.breakRunning && breakStartedAt != null) {
      final remaining =
          breakRemainingBeforePause - displayNow.difference(breakStartedAt!);
      return remaining.inSeconds < 0 ? 0 : remaining.inSeconds;
    }
    return breakRemainingBeforePause.inSeconds < 0
        ? 0
        : breakRemainingBeforePause.inSeconds;
  }

  String get displayTime {
    final totalSeconds = isBreakPhase
        ? breakRemainingSeconds
        : focusElapsedSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String get phaseLabel {
    switch (phase) {
      case FlowtimePhase.idle:
        return 'Ready';
      case FlowtimePhase.focusing:
        return 'In Flow';
      case FlowtimePhase.focusPaused:
        return 'Focus Paused';
      case FlowtimePhase.breakSuggested:
        return 'Break Suggested';
      case FlowtimePhase.breakRunning:
        return 'Resting';
      case FlowtimePhase.breakPaused:
        return 'Break Paused';
      case FlowtimePhase.finished:
        return 'Session Closed';
    }
  }

  FlowtimeState copyWith({
    FlowtimePhase? phase,
    DateTime? displayNow,
    int? projectId,
    DateTime? focusStartedAt,
    Duration? focusElapsedBeforePause,
    DateTime? breakStartedAt,
    Duration? breakRemainingBeforePause,
    int? suggestedBreakMinutes,
    FlowtimeInterruption? activeInterruption,
    List<FlowtimeInterruption>? currentBlockInterruptions,
    List<FlowtimeCompletedBlock>? completedBlocks,
    bool clearFocusStartedAt = false,
    bool clearBreakStartedAt = false,
    bool clearActiveInterruption = false,
  }) {
    return FlowtimeState(
      phase: phase ?? this.phase,
      displayNow: displayNow ?? this.displayNow,
      projectId: projectId ?? this.projectId,
      focusStartedAt: clearFocusStartedAt
          ? null
          : focusStartedAt ?? this.focusStartedAt,
      focusElapsedBeforePause:
          focusElapsedBeforePause ?? this.focusElapsedBeforePause,
      breakStartedAt: clearBreakStartedAt
          ? null
          : breakStartedAt ?? this.breakStartedAt,
      breakRemainingBeforePause:
          breakRemainingBeforePause ?? this.breakRemainingBeforePause,
      suggestedBreakMinutes:
          suggestedBreakMinutes ?? this.suggestedBreakMinutes,
      activeInterruption: clearActiveInterruption
          ? null
          : activeInterruption ?? this.activeInterruption,
      currentBlockInterruptions:
          currentBlockInterruptions ?? this.currentBlockInterruptions,
      completedBlocks: completedBlocks ?? this.completedBlocks,
    );
  }

  @override
  List<Object?> get props => [
    phase,
    displayNow,
    projectId,
    focusStartedAt,
    focusElapsedBeforePause,
    breakStartedAt,
    breakRemainingBeforePause,
    suggestedBreakMinutes,
    activeInterruption,
    currentBlockInterruptions,
    completedBlocks,
  ];
}

class FlowtimeCubit extends Cubit<FlowtimeState> {
  FlowtimeCubit(this._sessionRepository, {DateTime Function()? now})
    : _now = now ?? DateTime.now,
      super(FlowtimeState.initial((now ?? DateTime.now)()));

  final SessionRepository _sessionRepository;
  final DateTime Function() _now;
  Timer? _displayTicker;
  bool _displayTickerActive = false;

  void setDisplayTickerActive(bool value) {
    _displayTickerActive = value;
    if (value) {
      _refreshDisplay();
    }
    _syncTicker();
  }

  void startFocus(int projectId, {bool preserveHistory = true}) {
    final now = _now();
    emit(
      FlowtimeState(
        phase: FlowtimePhase.focusing,
        displayNow: now,
        projectId: projectId,
        focusStartedAt: now,
        suggestedBreakMinutes: 0,
        currentBlockInterruptions: const [],
        completedBlocks: preserveHistory ? state.completedBlocks : const [],
      ),
    );
    _syncTicker();
  }

  void pause() {
    final now = _now();
    if (state.phase == FlowtimePhase.focusing) {
      emit(
        state.copyWith(
          phase: FlowtimePhase.focusPaused,
          displayNow: now,
          focusElapsedBeforePause: _focusElapsedAt(now),
          clearFocusStartedAt: true,
        ),
      );
    } else if (state.phase == FlowtimePhase.breakRunning) {
      emit(
        state.copyWith(
          phase: FlowtimePhase.breakPaused,
          displayNow: now,
          breakRemainingBeforePause: Duration(seconds: _breakRemainingAt(now)),
          clearBreakStartedAt: true,
        ),
      );
    }
    _syncTicker();
  }

  void resume() {
    final now = _now();
    if (state.phase == FlowtimePhase.focusPaused) {
      emit(
        state.copyWith(
          phase: FlowtimePhase.focusing,
          displayNow: now,
          focusStartedAt: now,
        ),
      );
    } else if (state.phase == FlowtimePhase.breakPaused) {
      emit(
        state.copyWith(
          phase: FlowtimePhase.breakRunning,
          displayNow: now,
          breakStartedAt: now,
        ),
      );
    }
    _syncTicker();
  }

  Future<void> stopFocusAndSuggestBreak() async {
    if (state.projectId == null ||
        (state.phase != FlowtimePhase.focusing &&
            state.phase != FlowtimePhase.focusPaused)) {
      return;
    }

    final endedAt = _now();
    final startedAt =
        state.focusStartedAt ?? endedAt.subtract(state.focusElapsedBeforePause);
    final interruptions = _resolvedInterruptions(endedAt);
    final workedMinutes = workedMinutesBetween(startedAt, endedAt);
    final breakMinutes = suggestBreakMinutes(workedMinutes);

    await _sessionRepository.createCompletedFocusBlock(
      projectId: state.projectId!,
      startedAt: startedAt,
      endedAt: endedAt,
      mode: FocusSessionMode.flowtime,
      relaxMinutes: breakMinutes,
      interruptions: [for (final item in interruptions) item.toDraft()],
    );

    emit(
      state.copyWith(
        phase: FlowtimePhase.breakSuggested,
        displayNow: endedAt,
        focusElapsedBeforePause: Duration.zero,
        breakRemainingBeforePause: Duration(minutes: breakMinutes),
        suggestedBreakMinutes: breakMinutes,
        currentBlockInterruptions: const [],
        completedBlocks: [
          ...state.completedBlocks,
          FlowtimeCompletedBlock(
            startedAt: startedAt,
            endedAt: endedAt,
            workedMinutes: workedMinutes,
            suggestedBreakMinutes: breakMinutes,
            interruptions: interruptions,
          ),
        ],
        clearFocusStartedAt: true,
        clearActiveInterruption: true,
      ),
    );
    _syncTicker();
  }

  void startBreak() {
    if (state.suggestedBreakMinutes <= 0 ||
        state.phase == FlowtimePhase.breakRunning) {
      return;
    }
    final now = _now();
    emit(
      state.copyWith(
        phase: FlowtimePhase.breakRunning,
        displayNow: now,
        breakStartedAt: now,
        breakRemainingBeforePause: state.breakRemainingBeforePause.inSeconds > 0
            ? state.breakRemainingBeforePause
            : Duration(minutes: state.suggestedBreakMinutes),
      ),
    );
    _syncTicker();
  }

  void startNextFocus() {
    final projectId = state.projectId;
    if (projectId == null) {
      return;
    }
    startFocus(projectId, preserveHistory: true);
  }

  void finishSession() {
    final now = _now();
    emit(
      state.copyWith(
        phase: FlowtimePhase.finished,
        displayNow: now,
        focusElapsedBeforePause: Duration.zero,
        breakRemainingBeforePause: Duration.zero,
        suggestedBreakMinutes: 0,
        currentBlockInterruptions: const [],
        clearFocusStartedAt: true,
        clearBreakStartedAt: true,
        clearActiveInterruption: true,
      ),
    );
    _syncTicker();
  }

  void reset() {
    emit(FlowtimeState.initial(_now()));
    _syncTicker();
  }

  void startInterruption({
    required SessionInterruptionType type,
    required String label,
    String? note,
  }) {
    if ((state.phase != FlowtimePhase.focusing &&
            state.phase != FlowtimePhase.focusPaused) ||
        state.activeInterruption != null) {
      return;
    }
    final now = _now();
    emit(
      state.copyWith(
        displayNow: now,
        activeInterruption: FlowtimeInterruption(
          type: type,
          label: label,
          note: note,
          startedAt: now,
        ),
      ),
    );
  }

  void logDistraction() {
    if (state.phase != FlowtimePhase.focusing) {
      return;
    }
    final now = _now();
    emit(
      state.copyWith(
        displayNow: now,
        currentBlockInterruptions: [
          ...state.currentBlockInterruptions,
          FlowtimeInterruption(
            type: SessionInterruptionType.distraction,
            label: SessionInterruptionType.distraction.label,
            startedAt: now,
            endedAt: now,
          ),
        ],
      ),
    );
  }

  void endActiveInterruption() {
    final active = state.activeInterruption;
    if (active == null) {
      return;
    }
    final now = _now();
    final ended = active.end(now);
    emit(
      state.copyWith(
        displayNow: now,
        currentBlockInterruptions: [...state.currentBlockInterruptions, ended],
        clearActiveInterruption: true,
      ),
    );
  }

  List<FlowtimeInterruption> _resolvedInterruptions(DateTime endTime) {
    final interruptions = <FlowtimeInterruption>[
      ...state.currentBlockInterruptions,
    ];
    if (state.activeInterruption case final active?) {
      interruptions.add(active.end(endTime));
    }
    return interruptions;
  }

  void _refreshDisplay() {
    final now = _now();
    if (state.phase == FlowtimePhase.breakRunning &&
        state.breakRemainingBeforePause.inSeconds > 0 &&
        _breakRemainingAt(now) <= 0) {
      emit(
        state.copyWith(
          phase: FlowtimePhase.finished,
          displayNow: now,
          breakRemainingBeforePause: Duration.zero,
          clearBreakStartedAt: true,
        ),
      );
      _syncTicker();
      return;
    }
    emit(state.copyWith(displayNow: now));
  }

  Duration _focusElapsedAt(DateTime reference) {
    if (state.phase == FlowtimePhase.focusing && state.focusStartedAt != null) {
      return state.focusElapsedBeforePause +
          reference.difference(state.focusStartedAt!);
    }
    return state.focusElapsedBeforePause;
  }

  int _breakRemainingAt(DateTime reference) {
    if (state.phase == FlowtimePhase.breakRunning &&
        state.breakStartedAt != null) {
      final remaining =
          state.breakRemainingBeforePause -
          reference.difference(state.breakStartedAt!);
      return remaining.inSeconds < 0 ? 0 : remaining.inSeconds;
    }
    return state.breakRemainingBeforePause.inSeconds < 0
        ? 0
        : state.breakRemainingBeforePause.inSeconds;
  }

  void _syncTicker() {
    _displayTicker?.cancel();
    if (!_displayTickerActive) {
      return;
    }
    if (state.phase == FlowtimePhase.focusing ||
        state.phase == FlowtimePhase.breakRunning) {
      _displayTicker = Timer.periodic(const Duration(seconds: 1), (_) {
        _refreshDisplay();
      });
    }
  }

  @override
  Future<void> close() {
    _displayTicker?.cancel();
    return super.close();
  }
}

int suggestBreakMinutes(int workedMinutes) {
  if (workedMinutes <= 25) {
    return 5;
  }
  if (workedMinutes <= 50) {
    return 8;
  }
  if (workedMinutes <= 90) {
    return 10;
  }
  return 15;
}
