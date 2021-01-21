import 'package:todos_domain/todos_domain.dart';

abstract class SaveNoteUseCase {
  Future insertNote(NoteDTO dto);
}

class SaveNoteUseCaseImpl implements SaveNoteUseCase {

  final NoteRepo noteRepo;

  SaveNoteUseCaseImpl(this.noteRepo);

  @override
  Future insertNote(NoteDTO dto) {
    if((dto.id ?? 0) > 0) {
      return noteRepo.updateNote(dto);
    }
    return noteRepo.insertNote(dto);
  }
}