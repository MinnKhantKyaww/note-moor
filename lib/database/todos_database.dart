import 'package:moor_flutter/moor_flutter.dart';

part 'todos_database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get datetime => integer()();

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

  NotesDao(this.appDatabase) : super(appDatabase);

  Future<List<Note>> getAllNotes() => select(notes).get();

  Stream<List<Note>> watchAllNotes() => (select(notes)
        ..orderBy(([
          (note) =>
              OrderingTerm(expression: note.datetime, mode: OrderingMode.desc)
        ])))
      .watch();

  Stream<List<Note>> watchAllNotesDateTime(
      {bool sort = true, bool favorite = false}) {
    var selectQuery = select(notes);
    /*if(favorite && sort == true) {
      return (selectQuery
        ..orderBy(([
              (note) =>
              OrderingTerm(expression: note.datetime, mode: OrderingMode.desc)
        ]))
          ..where((tbl) => tbl.favourite.equals(true))).watch();
    }*/

    if (sort) {
      selectQuery
        ..orderBy(([
          (note) =>
              OrderingTerm(expression: note.datetime, mode: OrderingMode.asc)
        ]));
    } else {
      selectQuery
        ..orderBy(([
          (note) =>
              OrderingTerm(expression: note.datetime, mode: OrderingMode.desc)
        ]));
    }

    return selectQuery.watch();
  }

  Stream<List<Note>> watchAllNotesByWord(
      {String word, DateTime dateTime, bool selected}) {
    var selectQuery = select(notes);

    if (selected) {
      selectQuery.where((tbl) => tbl.body.like("$word%"));
    } else {
      print(dateTime.toUtc().add(Duration(hours: 00 ,minutes: 00, seconds: 00, milliseconds: 59)));
      print(dateTime.toUtc().add(Duration(hours: 23, minutes: 59)));
      selectQuery.where((tbl) {
        print(dateTime.toUtc().add(Duration(hours: 00 ,minutes: 00, seconds: 00)));
        return tbl.datetime.isBetweenValues(
            dateTime.toUtc().add(Duration(hours: 00 ,minutes: 00, seconds: 00, milliseconds: 59)).millisecondsSinceEpoch,
            dateTime.toUtc().add(Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 59)).millisecondsSinceEpoch);
      });
    }

    return selectQuery.watch();
  }

  Stream<List<Note>> watchAllNotesByFavorite({bool sort = false}) {
    var selectWhereQuery = select(notes)
      ..where((tbl) => tbl.favourite.equals(true));

    if (sort) {
      selectWhereQuery
        ..orderBy(([
          (note) =>
              OrderingTerm(expression: note.datetime, mode: OrderingMode.asc)
        ]));
    } else {
      selectWhereQuery
        ..orderBy(([
          (note) =>
              OrderingTerm(expression: note.datetime, mode: OrderingMode.desc)
        ]));
    }

    return selectWhereQuery.watch();
  }

  Future insertNote(Insertable<Note> note) => into(notes).insert(note);

  Future updateNote(Insertable<Note> note) => update(notes).replace(note);

  Future deleteNote(Insertable<Note> note) => delete(notes).delete(note);
}
