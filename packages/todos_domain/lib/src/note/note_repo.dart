import 'package:todos_domain/src/note/note_dto.dart';

abstract class NoteRepo {

  Future<List<NoteDTO>> getAllNotes();

  Stream<List<NoteDTO>> watchAllNotes();

  Stream<List<NoteDTO>> watchAllNotesDateTime({bool sort = true, bool favorite = false});

  Stream<List<NoteDTO>> watchAllNotesByWord({String word, DateTime dateTime, bool selected});

  Stream<List<NoteDTO>> watchAllNotesByFavorite({bool sort = false});

  Future insertNote(NoteDTO dto);

  Future updateNote(NoteDTO dto);

  Future deleteNote(NoteDTO dto);

}