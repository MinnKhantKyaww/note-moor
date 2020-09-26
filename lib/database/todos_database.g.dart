// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Note extends DataClass implements Insertable<Note> {
  final int id;
  final int datetime;
  final String body;
  final bool favourite;
  Note(
      {@required this.id,
      @required this.datetime,
      @required this.body,
      @required this.favourite});
  factory Note.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Note(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      datetime:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}datetime']),
      body: stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
      favourite:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}favourite']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || datetime != null) {
      map['datetime'] = Variable<int>(datetime);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || favourite != null) {
      map['favourite'] = Variable<bool>(favourite);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      datetime: datetime == null && nullToAbsent
          ? const Value.absent()
          : Value(datetime),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      favourite: favourite == null && nullToAbsent
          ? const Value.absent()
          : Value(favourite),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      datetime: serializer.fromJson<int>(json['datetime']),
      body: serializer.fromJson<String>(json['body']),
      favourite: serializer.fromJson<bool>(json['favourite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'datetime': serializer.toJson<int>(datetime),
      'body': serializer.toJson<String>(body),
      'favourite': serializer.toJson<bool>(favourite),
    };
  }

  Note copyWith({int id, int datetime, String body, bool favourite}) => Note(
        id: id ?? this.id,
        datetime: datetime ?? this.datetime,
        body: body ?? this.body,
        favourite: favourite ?? this.favourite,
      );
  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('datetime: $datetime, ')
          ..write('body: $body, ')
          ..write('favourite: $favourite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(datetime.hashCode, $mrjc(body.hashCode, favourite.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.datetime == this.datetime &&
          other.body == this.body &&
          other.favourite == this.favourite);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<int> datetime;
  final Value<String> body;
  final Value<bool> favourite;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.datetime = const Value.absent(),
    this.body = const Value.absent(),
    this.favourite = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    @required int datetime,
    @required String body,
    this.favourite = const Value.absent(),
  })  : datetime = Value(datetime),
        body = Value(body);
  static Insertable<Note> custom({
    Expression<int> id,
    Expression<int> datetime,
    Expression<String> body,
    Expression<bool> favourite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (datetime != null) 'datetime': datetime,
      if (body != null) 'body': body,
      if (favourite != null) 'favourite': favourite,
    });
  }

  NotesCompanion copyWith(
      {Value<int> id,
      Value<int> datetime,
      Value<String> body,
      Value<bool> favourite}) {
    return NotesCompanion(
      id: id ?? this.id,
      datetime: datetime ?? this.datetime,
      body: body ?? this.body,
      favourite: favourite ?? this.favourite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (datetime.present) {
      map['datetime'] = Variable<int>(datetime.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (favourite.present) {
      map['favourite'] = Variable<bool>(favourite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('datetime: $datetime, ')
          ..write('body: $body, ')
          ..write('favourite: $favourite')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _datetimeMeta = const VerificationMeta('datetime');
  GeneratedIntColumn _datetime;
  @override
  GeneratedIntColumn get datetime => _datetime ??= _constructDatetime();
  GeneratedIntColumn _constructDatetime() {
    return GeneratedIntColumn(
      'datetime',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bodyMeta = const VerificationMeta('body');
  GeneratedTextColumn _body;
  @override
  GeneratedTextColumn get body => _body ??= _constructBody();
  GeneratedTextColumn _constructBody() {
    return GeneratedTextColumn(
      'body',
      $tableName,
      false,
    );
  }

  final VerificationMeta _favouriteMeta = const VerificationMeta('favourite');
  GeneratedBoolColumn _favourite;
  @override
  GeneratedBoolColumn get favourite => _favourite ??= _constructFavourite();
  GeneratedBoolColumn _constructFavourite() {
    return GeneratedBoolColumn('favourite', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, datetime, body, favourite];
  @override
  $NotesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notes';
  @override
  final String actualTableName = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['datetime'], _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body'], _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('favourite')) {
      context.handle(_favouriteMeta,
          favourite.isAcceptableOrUnknown(data['favourite'], _favouriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Note.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  NotesDao _notesDao;
  NotesDao get notesDao => _notesDao ??= NotesDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [notes];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$NotesDaoMixin on DatabaseAccessor<AppDatabase> {
  $NotesTable get notes => attachedDatabase.notes;
}
