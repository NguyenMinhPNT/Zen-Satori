import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:zen_satori/core/database/app_database.dart';
import 'package:zen_satori/features/projects/domain/activity_type.dart';
import 'package:zen_satori/features/projects/domain/project_repository.dart';
import 'package:zen_satori/features/projects/domain/project_status.dart';

void main() {
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test(
    'Schema v5 migration preserves rows and backfills activity type',
    () async {
      final tempDir = await Directory.systemTemp.createTemp(
        'zen_satori_migration',
      );
      final file = File('${tempDir.path}/zen_satori.sqlite');
      final legacyDb = sqlite.sqlite3.open(file.path);

      legacyDb.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        target_minutes INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'ongoing',
        detail TEXT NULL,
        start_date INTEGER NULL,
        deadline INTEGER NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      );
    ''');
      legacyDb.execute('''
      CREATE TABLE focus_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        project_id INTEGER NOT NULL REFERENCES projects(id),
        started_at INTEGER NOT NULL,
        ended_at INTEGER NOT NULL,
        work_minutes INTEGER NOT NULL,
        relax_minutes INTEGER NOT NULL,
        mode TEXT NOT NULL DEFAULT 'pomodoro',
        completed INTEGER NOT NULL
      );
    ''');
      legacyDb.execute('''
      CREATE TABLE session_interruptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        focus_session_id INTEGER NOT NULL REFERENCES focus_sessions(id),
        type TEXT NOT NULL,
        label TEXT NOT NULL,
        note TEXT NULL,
        started_at INTEGER NOT NULL,
        ended_at INTEGER NOT NULL
      );
    ''');
      legacyDb.execute('''
      CREATE TABLE achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL,
        unlocked_at INTEGER NULL,
        progress INTEGER NOT NULL DEFAULT 0
      );
    ''');
      legacyDb.execute('''
      INSERT INTO projects (
        title,
        target_minutes,
        status,
        detail,
        start_date,
        deadline,
        created_at,
        updated_at
      ) VALUES (
        'Legacy Project',
        120,
        'Ongoing',
        'Old detail',
        1781049600000,
        1781470800000,
        1781049600000,
        1781136000000
      );
    ''');
      legacyDb.execute('PRAGMA user_version = 4;');
      legacyDb.dispose();

      final database = AppDatabase(NativeDatabase(file));
      final projects = await database.select(database.projects).get();

      expect(projects, hasLength(1));
      expect(projects.single.title, 'Legacy Project');
      expect(projects.single.activityType, ActivityType.project.storageValue);
      expect(projects.single.targetMinutes, 120);
      expect(projects.single.frequencyCount, null);
      expect(projects.single.frequencyPeriod, null);
      expect(projects.single.detail, 'Old detail');
      expect(projects.single.deadline, isNotNull);

      await database.close();
      await tempDir.delete(recursive: true);
    },
  );

  test(
    'Repository clears incompatible fields when activity type changes',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final repository = ProjectRepository(database);
      final routineId = await repository.createProject(
        title: 'Stretch',
        type: ActivityType.routine,
        deadline: DateTime(2026, 7, 10),
        targetMinutes: 180,
        frequencyCount: 3,
        frequencyPeriod: ActivityFrequencyPeriod.week,
      );

      final routine = await (database.select(
        database.projects,
      )..where((tbl) => tbl.id.equals(routineId))).getSingle();

      expect(routine.activityType, ActivityType.routine.storageValue);
      expect(routine.deadline, null);
      expect(routine.targetMinutes, 0);
      expect(routine.frequencyCount, 3);
      expect(
        routine.frequencyPeriod,
        ActivityFrequencyPeriod.week.storageValue,
      );

      await repository.updateProject(
        id: routineId,
        title: 'Stretch',
        type: ActivityType.project,
        status: ProjectStatus.ongoing,
        deadline: DateTime(2026, 7, 12),
        targetMinutes: 120,
        frequencyCount: 5,
        frequencyPeriod: ActivityFrequencyPeriod.day,
      );

      final project = await (database.select(
        database.projects,
      )..where((tbl) => tbl.id.equals(routineId))).getSingle();

      expect(project.activityType, ActivityType.project.storageValue);
      expect(project.deadline, DateTime(2026, 7, 12));
      expect(project.targetMinutes, 120);
      expect(project.frequencyCount, null);
      expect(project.frequencyPeriod, null);

      await database.close();
    },
  );
}
