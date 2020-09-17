import 'package:intl/intl.dart';
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

  NotesDao(this.appDatabase) : super(appDatabase);

  Future<List<Note>> getAllNotes() => select(notes).get();

  Stream<List<Note>> watchAllNotes() => select(notes).watch();

  Stream<List<Note>> watchAllNotesDateTime(
      {bool sort = false, bool favorite = false}) {
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
              OrderingTerm(expression: note.datetime, mode: OrderingMode.desc)
        ]));
    } else {
      selectQuery
        ..orderBy(([
          (note) =>
              OrderingTerm(expression: note.datetime, mode: OrderingMode.asc)
        ]));
    }

    return selectQuery.watch();
  }

  Stream<List<Note>> watchAllNotesByWord({String word, DateTime dateTime, bool selected}) {
    var selectQuery = select(notes);

    if (selected) {
      selectQuery.where((tbl) => tbl.body.like("$word%"));
    } else {
      selectQuery.where((tbl) {
        print(tbl.datetime.day);
        return tbl.datetime.day.equals(dateTime.day) & tbl.datetime.month.equals(dateTime.month) & tbl.datetime.year.equals(dateTime.year);
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
              OrderingTerm(expression: note.datetime, mode: OrderingMode.desc)
        ]));
    } else {
      selectWhereQuery
        ..orderBy(([
          (note) =>
              OrderingTerm(expression: note.datetime, mode: OrderingMode.asc)
        ]));
    }

    return selectWhereQuery.watch();
  }

  Future insertNote(Insertable<Note> note) => into(notes).insert(note);

  Future updateNote(Insertable<Note> note) => update(notes).replace(note);

  Future deleteNote(Insertable<Note> note) => delete(notes).delete(note);
}
