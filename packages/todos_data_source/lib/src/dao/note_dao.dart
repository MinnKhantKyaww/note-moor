import 'package:todos_data_source/src/entity/note_entity.dart';
import 'package:moor/moor.dart';
import 'package:todos_data_source/src/note_database.dart';
import 'package:todos_domain/todos_domain.dart';
import 'package:todos_data_source/src/extensions.dart';

part 'note_dao.g.dart';

@UseDao(tables: [Notes])
class NotesDao extends DatabaseAccessor<NoteDatabase> with _$NotesDaoMixin {
  final NoteDatabase noteDatabase;

  NotesDao(this.noteDatabase) : super(noteDatabase);

  Future<List<NoteDTO>> getAllNotes() {
    final query = select(notes);
    return query.map((n) => n.toData()).get();
  }

  Stream<List<NoteDTO>> watchAllNotes() {
    final query = select(notes);
    query..orderBy(([
          (note) =>
          OrderingTerm(expression: note.datetime, mode: OrderingMode.desc)
    ]));
    return query.map((n) => n.toData()).watch();
  }

  Stream<List<NoteDTO>> watchAllNotesDateTime(
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

    return selectQuery.map((n) => n.toData()).watch();
  }

  Stream<List<NoteDTO>> watchAllNotesByWord(
      {String word, DateTime dateTime, bool selected}) {
    var selectQuery = select(notes);

    if (selected) {
      selectQuery.where((tbl) => tbl.body.like("$word%"));
    } else {
      selectQuery.where((tbl) {
        return tbl.datetime.isBetweenValues(
            dateTime.toUtc().add(Duration(hours: 00 ,minutes: 00, seconds: 00, milliseconds: 59)).millisecondsSinceEpoch,
            dateTime.toUtc().add(Duration(hours: 23, minutes: 59, seconds: 59, milliseconds: 59)).millisecondsSinceEpoch);
      });
    }

    return selectQuery.map((n) => n.toData()).watch();
  }

  Stream<List<NoteDTO>> watchAllNotesByFavorite({bool sort = false}) {
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

    return selectWhereQuery.map((n) => n.toData()).watch();
  }

  Future insertNote(NotesCompanion note) => into(notes).insert(note);

  Future updateNote(NotesCompanion note) => update(notes).replace(note);

  Future deleteNote(NotesCompanion note) => delete(notes).delete(note);
}