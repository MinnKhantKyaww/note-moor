import 'package:moor_flutter/moor_flutter.dart';

part 'todos_database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get datetime => dateTime().nullable()();

  TextColumn get body => text()();

  BoolColumn get favourite => boolean().withDefault(Constant(false))();
}

@UseMoor(tables: [Notes], daos: [NotesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sql', logStatements: true));

  @override
  int get schemaVersion => 1;

}

@UseDao(tables: [Notes])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  final AppDatabase appDatabase;
  NotesDao(this.appDatabase) :super(appDatabase);

  Future<List<Note>> getAllNotes() => select(notes).get();

  Stream<List<Note>> watchALlNotes() => select(notes).watch();

  Stream<List<Note>> watchALlNotesDateTime() {
    return select(notes).watch();
  }

  Future insertNote(Insertable<Note> note) => into(notes).insert(note);

  Future updateNote(Insertable<Note> note) => update(notes).replace(note);

  Future deleteNote(Insertable<Note> note) => delete(notes).delete(note);

}