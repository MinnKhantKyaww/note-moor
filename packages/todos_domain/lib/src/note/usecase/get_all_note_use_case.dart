import 'package:todos_domain/todos_domain.dart';

abstract class GetAllNoteUseCase {

  Future<List<NoteDTO>> getAllNotes();

  Stream<List<NoteDTO>> watchAllNotes();

  Stream<List<NoteDTO>> watchAllNotesByFavorite({bool sort = false});

  Stream<List<NoteDTO>> watchAllNotesByWord({String word, DateTime dateTime, bool selected});

  Stream<List<NoteDTO>> watchAllNotesDateTime({bool sort = true, bool favorite = false});

}

class GetAllNoteUseCaseImpl implements GetAllNoteUseCase {

  final NoteRepo noteRepo;

  GetAllNoteUseCaseImpl(this.noteRepo);

  @override
  Future<List<NoteDTO>> getAllNotes() {
    return noteRepo.getAllNotes();
  }

  @override
  Stream<List<NoteDTO>> watchAllNotes() {
    return noteRepo.watchAllNotes();
  }

  @override
  Stream<List<NoteDTO>> watchAllNotesByFavorite({bool sort = false}) {
    return noteRepo.watchAllNotesByFavorite(sort: sort);
  }

  @override
  Stream<List<NoteDTO>> watchAllNotesByWord({String word, DateTime dateTime, bool selected}) {
    return noteRepo.watchAllNotesByWord(word: word, dateTime: dateTime, selected: selected);
  }

  @override
  Stream<List<NoteDTO>> watchAllNotesDateTime({bool sort = true, bool favorite = false}) {
    return noteRepo.watchAllNotesDateTime(sort: sort, favorite: favorite);
  }

}