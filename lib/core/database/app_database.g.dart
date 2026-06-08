// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMinutesMeta = const VerificationMeta(
    'targetMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMinutes = GeneratedColumn<int>(
    'target_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ongoing'),
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    targetMinutes,
    status,
    detail,
    startDate,
    deadline,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('target_minutes')) {
      context.handle(
        _targetMinutesMeta,
        targetMinutes.isAcceptableOrUnknown(
          data['target_minutes']!,
          _targetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      targetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_minutes'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String title;
  final int targetMinutes;
  final String status;
  final String? detail;
  final DateTime? startDate;
  final DateTime? deadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Project({
    required this.id,
    required this.title,
    required this.targetMinutes,
    required this.status,
    this.detail,
    this.startDate,
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['target_minutes'] = Variable<int>(targetMinutes);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || detail != null) {
      map['detail'] = Variable<String>(detail);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      title: Value(title),
      targetMinutes: Value(targetMinutes),
      status: Value(status),
      detail: detail == null && nullToAbsent
          ? const Value.absent()
          : Value(detail),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      targetMinutes: serializer.fromJson<int>(json['targetMinutes']),
      status: serializer.fromJson<String>(json['status']),
      detail: serializer.fromJson<String?>(json['detail']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'targetMinutes': serializer.toJson<int>(targetMinutes),
      'status': serializer.toJson<String>(status),
      'detail': serializer.toJson<String?>(detail),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Project copyWith({
    int? id,
    String? title,
    int? targetMinutes,
    String? status,
    Value<String?> detail = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> deadline = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Project(
    id: id ?? this.id,
    title: title ?? this.title,
    targetMinutes: targetMinutes ?? this.targetMinutes,
    status: status ?? this.status,
    detail: detail.present ? detail.value : this.detail,
    startDate: startDate.present ? startDate.value : this.startDate,
    deadline: deadline.present ? deadline.value : this.deadline,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      targetMinutes: data.targetMinutes.present
          ? data.targetMinutes.value
          : this.targetMinutes,
      status: data.status.present ? data.status.value : this.status,
      detail: data.detail.present ? data.detail.value : this.detail,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('status: $status, ')
          ..write('detail: $detail, ')
          ..write('startDate: $startDate, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    targetMinutes,
    status,
    detail,
    startDate,
    deadline,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.title == this.title &&
          other.targetMinutes == this.targetMinutes &&
          other.status == this.status &&
          other.detail == this.detail &&
          other.startDate == this.startDate &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> targetMinutes;
  final Value<String> status;
  final Value<String?> detail;
  final Value<DateTime?> startDate;
  final Value<DateTime?> deadline;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.targetMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.detail = const Value.absent(),
    this.startDate = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.targetMinutes = const Value.absent(),
    this.status = const Value.absent(),
    this.detail = const Value.absent(),
    this.startDate = const Value.absent(),
    this.deadline = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? targetMinutes,
    Expression<String>? status,
    Expression<String>? detail,
    Expression<DateTime>? startDate,
    Expression<DateTime>? deadline,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (targetMinutes != null) 'target_minutes': targetMinutes,
      if (status != null) 'status': status,
      if (detail != null) 'detail': detail,
      if (startDate != null) 'start_date': startDate,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? targetMinutes,
    Value<String>? status,
    Value<String?>? detail,
    Value<DateTime?>? startDate,
    Value<DateTime?>? deadline,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      status: status ?? this.status,
      detail: detail ?? this.detail,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetMinutes.present) {
      map['target_minutes'] = Variable<int>(targetMinutes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('targetMinutes: $targetMinutes, ')
          ..write('status: $status, ')
          ..write('detail: $detail, ')
          ..write('startDate: $startDate, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workMinutesMeta = const VerificationMeta(
    'workMinutes',
  );
  @override
  late final GeneratedColumn<int> workMinutes = GeneratedColumn<int>(
    'work_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relaxMinutesMeta = const VerificationMeta(
    'relaxMinutes',
  );
  @override
  late final GeneratedColumn<int> relaxMinutes = GeneratedColumn<int>(
    'relax_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    startedAt,
    endedAt,
    workMinutes,
    relaxMinutes,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('work_minutes')) {
      context.handle(
        _workMinutesMeta,
        workMinutes.isAcceptableOrUnknown(
          data['work_minutes']!,
          _workMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workMinutesMeta);
    }
    if (data.containsKey('relax_minutes')) {
      context.handle(
        _relaxMinutesMeta,
        relaxMinutes.isAcceptableOrUnknown(
          data['relax_minutes']!,
          _relaxMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relaxMinutesMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      workMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_minutes'],
      )!,
      relaxMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}relax_minutes'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final int id;
  final int projectId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int workMinutes;
  final int relaxMinutes;
  final bool completed;
  const FocusSession({
    required this.id,
    required this.projectId,
    required this.startedAt,
    required this.endedAt,
    required this.workMinutes,
    required this.relaxMinutes,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['work_minutes'] = Variable<int>(workMinutes);
    map['relax_minutes'] = Variable<int>(relaxMinutes);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      workMinutes: Value(workMinutes),
      relaxMinutes: Value(relaxMinutes),
      completed: Value(completed),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      workMinutes: serializer.fromJson<int>(json['workMinutes']),
      relaxMinutes: serializer.fromJson<int>(json['relaxMinutes']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'workMinutes': serializer.toJson<int>(workMinutes),
      'relaxMinutes': serializer.toJson<int>(relaxMinutes),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  FocusSession copyWith({
    int? id,
    int? projectId,
    DateTime? startedAt,
    DateTime? endedAt,
    int? workMinutes,
    int? relaxMinutes,
    bool? completed,
  }) => FocusSession(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    workMinutes: workMinutes ?? this.workMinutes,
    relaxMinutes: relaxMinutes ?? this.relaxMinutes,
    completed: completed ?? this.completed,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      workMinutes: data.workMinutes.present
          ? data.workMinutes.value
          : this.workMinutes,
      relaxMinutes: data.relaxMinutes.present
          ? data.relaxMinutes.value
          : this.relaxMinutes,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('relaxMinutes: $relaxMinutes, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    startedAt,
    endedAt,
    workMinutes,
    relaxMinutes,
    completed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.workMinutes == this.workMinutes &&
          other.relaxMinutes == this.relaxMinutes &&
          other.completed == this.completed);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> workMinutes;
  final Value<int> relaxMinutes;
  final Value<bool> completed;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.workMinutes = const Value.absent(),
    this.relaxMinutes = const Value.absent(),
    this.completed = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int workMinutes,
    required int relaxMinutes,
    required bool completed,
  }) : projectId = Value(projectId),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       workMinutes = Value(workMinutes),
       relaxMinutes = Value(relaxMinutes),
       completed = Value(completed);
  static Insertable<FocusSession> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? workMinutes,
    Expression<int>? relaxMinutes,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (workMinutes != null) 'work_minutes': workMinutes,
      if (relaxMinutes != null) 'relax_minutes': relaxMinutes,
      if (completed != null) 'completed': completed,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? workMinutes,
    Value<int>? relaxMinutes,
    Value<bool>? completed,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      workMinutes: workMinutes ?? this.workMinutes,
      relaxMinutes: relaxMinutes ?? this.relaxMinutes,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (workMinutes.present) {
      map['work_minutes'] = Variable<int>(workMinutes.value);
    }
    if (relaxMinutes.present) {
      map['relax_minutes'] = Variable<int>(relaxMinutes.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('relaxMinutes: $relaxMinutes, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, title, unlockedAt, progress];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final int id;
  final String code;
  final String title;
  final DateTime? unlockedAt;
  final int progress;
  const Achievement({
    required this.id,
    required this.code,
    required this.title,
    this.unlockedAt,
    required this.progress,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    map['progress'] = Variable<int>(progress);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      code: Value(code),
      title: Value(title),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      progress: Value(progress),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      title: serializer.fromJson<String>(json['title']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
      progress: serializer.fromJson<int>(json['progress']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'title': serializer.toJson<String>(title),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
      'progress': serializer.toJson<int>(progress),
    };
  }

  Achievement copyWith({
    int? id,
    String? code,
    String? title,
    Value<DateTime?> unlockedAt = const Value.absent(),
    int? progress,
  }) => Achievement(
    id: id ?? this.id,
    code: code ?? this.code,
    title: title ?? this.title,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
    progress: progress ?? this.progress,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      title: data.title.present ? data.title.value : this.title,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
      progress: data.progress.present ? data.progress.value : this.progress,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('progress: $progress')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, title, unlockedAt, progress);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.code == this.code &&
          other.title == this.title &&
          other.unlockedAt == this.unlockedAt &&
          other.progress == this.progress);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> title;
  final Value<DateTime?> unlockedAt;
  final Value<int> progress;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.title = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.progress = const Value.absent(),
  });
  AchievementsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String title,
    this.unlockedAt = const Value.absent(),
    this.progress = const Value.absent(),
  }) : code = Value(code),
       title = Value(title);
  static Insertable<Achievement> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? title,
    Expression<DateTime>? unlockedAt,
    Expression<int>? progress,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (progress != null) 'progress': progress,
    });
  }

  AchievementsCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? title,
    Value<DateTime?>? unlockedAt,
    Value<int>? progress,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('progress: $progress')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    focusSessions,
    achievements,
  ];
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required String title,
      Value<int> targetMinutes,
      Value<String> status,
      Value<String?> detail,
      Value<DateTime?> startDate,
      Value<DateTime?> deadline,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> targetMinutes,
      Value<String> status,
      Value<String?> detail,
      Value<DateTime?> startDate,
      Value<DateTime?> deadline,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: $_aliasNameGenerator(db.projects.id, db.focusSessions.projectId),
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get targetMinutes => $composableBuilder(
    column: $table.targetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool focusSessionsRefs})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> targetMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> detail = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                title: title,
                targetMinutes: targetMinutes,
                status: status,
                detail: detail,
                startDate: startDate,
                deadline: deadline,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<int> targetMinutes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> detail = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ProjectsCompanion.insert(
                id: id,
                title: title,
                targetMinutes: targetMinutes,
                status: status,
                detail: detail,
                startDate: startDate,
                deadline: deadline,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({focusSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (focusSessionsRefs) db.focusSessions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (focusSessionsRefs)
                    await $_getPrefetchedData<
                      Project,
                      $ProjectsTable,
                      FocusSession
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._focusSessionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProjectsTableReferences(
                        db,
                        table,
                        p0,
                      ).focusSessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool focusSessionsRefs})
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      required int projectId,
      required DateTime startedAt,
      required DateTime endedAt,
      required int workMinutes,
      required int relaxMinutes,
      required bool completed,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> workMinutes,
      Value<int> relaxMinutes,
      Value<bool> completed,
    });

final class $$FocusSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession> {
  $$FocusSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.focusSessions.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get relaxMinutes => $composableBuilder(
    column: $table.relaxMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get relaxMinutes => $composableBuilder(
    column: $table.relaxMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get relaxMinutes => $composableBuilder(
    column: $table.relaxMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSession, $$FocusSessionsTableReferences),
          FocusSession,
          PrefetchHooks Function({bool projectId})
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> workMinutes = const Value.absent(),
                Value<int> relaxMinutes = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                projectId: projectId,
                startedAt: startedAt,
                endedAt: endedAt,
                workMinutes: workMinutes,
                relaxMinutes: relaxMinutes,
                completed: completed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required DateTime startedAt,
                required DateTime endedAt,
                required int workMinutes,
                required int relaxMinutes,
                required bool completed,
              }) => FocusSessionsCompanion.insert(
                id: id,
                projectId: projectId,
                startedAt: startedAt,
                endedAt: endedAt,
                workMinutes: workMinutes,
                relaxMinutes: relaxMinutes,
                completed: completed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FocusSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$FocusSessionsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$FocusSessionsTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSession, $$FocusSessionsTableReferences),
      FocusSession,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      required String code,
      required String title,
      Value<DateTime?> unlockedAt,
      Value<int> progress,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> title,
      Value<DateTime?> unlockedAt,
      Value<int> progress,
    });

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (
            Achievement,
            BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
          ),
          Achievement,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<int> progress = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                code: code,
                title: title,
                unlockedAt: unlockedAt,
                progress: progress,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String title,
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<int> progress = const Value.absent(),
              }) => AchievementsCompanion.insert(
                id: id,
                code: code,
                title: title,
                unlockedAt: unlockedAt,
                progress: progress,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (
        Achievement,
        BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
      ),
      Achievement,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
}
