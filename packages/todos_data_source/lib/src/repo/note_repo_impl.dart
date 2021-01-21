import 'package:todos_data_source/todos_data_source.dart';
import 'package:todos_domain/todos_domain.dart';
import 'package:todos_data_source/src/extensions.dart';

class NoteRepoImpl implements NoteRepo {

  final NotesDao notesDao;

  NoteRepoImpl(this.notesDao);

  @override
  Future deleteNote(NoteDTO dto) {
    return notesDao.deleteNote(dto.toEntry());
  }

  @override
  Future<List<NoteDTO>> getAllNotes() {
    return notesDao.getAllNotes();
  }

  @override
  Future insertNote(NoteDTO dto) {
    return notesDao.insertNote(dto.toEntry());
  }

  @override
  Future updateNote(NoteDTO dto) {
    return notesDao.updateNote(dto.toEntry());
  }

  @override
  Stream<List<NoteDTO>> watchAllNotes() {
    return notesDao.watchAllNotes();
  }

  @override
  Stream<List<NoteDTO>> watchAllNotesByFavorite({bool sort = false}) {
    return notesDao.watchAllNotesByFavorite(sort: sort);
  }

  @override
  Stream<List<NoteDTO>> watchAllNotesByWord({String word, DateTime dateTime, bool selected}) {
    return notesDao.watchAllNotesByWord(word: word, dateTime: dateTime, selected: selected);
  }

  @override
  Stream<List<NoteDTO>> watchAllNotesDateTime({bool sort = true, bool favorite = false}) {
    return notesDao.watchAllNotesDateTime(sort: sort, favorite: favorite);
  }

}