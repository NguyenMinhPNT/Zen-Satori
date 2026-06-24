import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get activityType =>
      text().withDefault(const Constant('project'))();
  IntColumn get targetMinutes => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('ongoing'))();
  TextColumn get detail => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  IntColumn get frequencyCount => integer().nullable()();
  TextColumn get frequencyPeriod => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get workMinutes => integer()();
  IntColumn get relaxMinutes => integer()();
  TextColumn get mode => text().withDefault(const Constant('pomodoro'))();
  BoolColumn get completed => boolean()();
}

class SessionInterruptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get focusSessionId => integer().references(FocusSessions, #id)();
  TextColumn get type => text()();
  TextColumn get label => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
}

class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get title => text()();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
}

@DriftDatabase(
  tables: [Projects, FocusSessions, SessionInterruptions, Achievements],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.addColumn(projects, projects.detail);
          await m.addColumn(projects, projects.startDate);
          await m.addColumn(projects, projects.deadline);
        }
        if (from < 3) {
          final projectColumns = await customSelect(
            'PRAGMA table_info(projects)',
          ).get();
          final columnNames = projectColumns
              .map((row) => row.data['name'] as String?)
              .whereType<String>()
              .toSet();

          if (!columnNames.contains('target_minutes')) {
            await m.addColumn(projects, projects.targetMinutes);
          }
          if (!columnNames.contains('status')) {
            await m.addColumn(projects, projects.status);
          }
        }
        if (from < 4) {
          final focusSessionColumns = await customSelect(
            'PRAGMA table_info(focus_sessions)',
          ).get();
          final focusSessionColumnNames = focusSessionColumns
              .map((row) => row.data['name'] as String?)
              .whereType<String>()
              .toSet();

          if (!focusSessionColumnNames.contains('mode')) {
            await m.addColumn(focusSessions, focusSessions.mode);
          }
          await m.createTable(sessionInterruptions);
        }
        if (from < 5) {
          final projectColumns = await customSelect(
            'PRAGMA table_info(projects)',
          ).get();
          final columnNames = projectColumns
              .map((row) => row.data['name'] as String?)
              .whereType<String>()
              .toSet();

          if (!columnNames.contains('activity_type')) {
            await m.addColumn(projects, projects.activityType);
          }
          if (!columnNames.contains('frequency_count')) {
            await m.addColumn(projects, projects.frequencyCount);
          }
          if (!columnNames.contains('frequency_period')) {
            await m.addColumn(projects, projects.frequencyPeriod);
          }

          await customStatement('''
            UPDATE projects
            SET activity_type = 'project'
            WHERE activity_type IS NULL OR TRIM(activity_type) = ''
          ''');
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final documents = await getApplicationDocumentsDirectory();
    final file = File(p.join(documents.path, 'zen_satori.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
