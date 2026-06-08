import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get targetMinutes => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('ongoing'))();
  TextColumn get detail => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
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
  BoolColumn get completed => boolean()();
}

class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get title => text()();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Projects, FocusSessions, Achievements])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

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
