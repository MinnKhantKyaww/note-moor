import 'package:flutter/material.dart';
import 'package:todos_domain/todos_domain.dart';

class NoteEditModel extends ChangeNotifier {
  final DeleteNoteUseCase _deleteNoteUseCase;
  final SaveNoteUseCase _saveNoteUseCase;

  NoteEditModel(this._deleteNoteUseCase, this._saveNoteUseCase);

  Future insertNote(NoteDTO dto) {
    return _saveNoteUseCase.insertNote(dto);
  }

  Future deleteNote(NoteDTO dto) {
    return _deleteNoteUseCase.deleteNote(dto);
  }

}