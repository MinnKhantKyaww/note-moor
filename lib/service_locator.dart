import 'package:todos_data_source/todos_data_source.dart';
import 'package:todos_domain/todos_domain.dart';
import 'package:todos_moor/screens/note_screen/model/dark_theme_model.dart';
import 'package:todos_moor/screens/note_screen/model/note_edit_model.dart';
import 'package:todos_moor/screens/note_screen/model/note_list_model.dart';

abstract class ServiceLocator {
  NoteListModel get noteListModel;

  NoteEditModel get noteEditModel;

  DarkThemeModel get darkThemeModel;

  void close();
}

class DefaultServiceLocator extends ServiceLocator {
  final NoteDatabase _noteDatabase;

  DefaultServiceLocator(this._noteDatabase);

  @override
  NoteListModel get noteListModel {
    final noteRepo = NoteRepoImpl(_noteDatabase.notesDao);
    return NoteListModel(
      GetAllNoteUseCaseImpl(noteRepo),
      DeleteNoteUseCaseImpl(noteRepo),
      SaveNoteUseCaseImpl(noteRepo),
    );
  }

  @override
  NoteEditModel get noteEditModel {
    final noteRepo = NoteRepoImpl(_noteDatabase.notesDao);
    return NoteEditModel(DeleteNoteUseCaseImpl(noteRepo), SaveNoteUseCaseImpl(noteRepo));
  }

  @override
  DarkThemeModel get darkThemeModel => DarkThemeModel();

  @override
  void close() {
    _noteDatabase.close();
  }

}
