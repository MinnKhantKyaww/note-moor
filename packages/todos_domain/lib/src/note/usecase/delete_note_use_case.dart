import 'package:todos_domain/todos_domain.dart';

abstract class DeleteNoteUseCase {
  Future deleteNote(NoteDTO dto);
}

class DeleteNoteUseCaseImpl implements DeleteNoteUseCase {

  final NoteRepo noteRepo;

  DeleteNoteUseCaseImpl(this.noteRepo);

  @override
  Future deleteNote(NoteDTO dto) {
    return noteRepo.deleteNote(dto);
  }
}