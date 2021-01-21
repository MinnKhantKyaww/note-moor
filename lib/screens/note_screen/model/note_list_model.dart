import 'package:flutter/material.dart';
import 'package:todos_domain/todos_domain.dart';

class NoteListModel extends ChangeNotifier {
  final GetAllNoteUseCase _getAllNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;
  final SaveNoteUseCase _saveNoteUseCase;

  NoteListModel(this._getAllNoteUseCase, this._deleteNoteUseCase, this._saveNoteUseCase);

  bool _changeListView = false;
  bool _changeBySort = false;
  bool _changeDataSearch = false;
  DateTime _searchDateTime = DateTime.now();
  bool _changeSearch = false;
  bool _changeFavorite = false;
  String _searchTextValue;

  get changeListView => _changeListView;

  set changeListView(bool changeListView) {
    _changeListView = changeListView;
    notifyListeners();
  }

  get changeBySort => _changeBySort;

  set changeBySort(bool changeSort) {
    _changeBySort = changeBySort;
    notifyListeners();
  }

  get changeDataSearch => _changeDataSearch;

  set changeDataSearch(bool changeSearch) {
    _changeDataSearch = changeSearch;
    notifyListeners();
  }

  get searchDateTime => _searchDateTime;

  set searchDateTime(DateTime searchDateTime) {
    _searchDateTime = searchDateTime;
    notifyListeners();
  }

  get changeSearch => _changeSearch;

  set changeSearch(bool changeSearch) {
    _changeSearch = changeSearch;
    notifyListeners();
  }

  get changeFavorite => _changeFavorite;

  set changeFavorite(bool changeFav) {
    _changeFavorite = changeFav;
    notifyListeners();
  }

  get searchTextValue => _searchTextValue;

  set searchTextValue(String value) {
    _searchTextValue = value;
    notifyListeners();
  }

  Stream<List<NoteDTO>> dataCollectors() {
    Stream<List<NoteDTO>> streamNotes;

    streamNotes = _getAllNoteUseCase.watchAllNotes();

    streamNotes = _changeBySort
        ? _getAllNoteUseCase.watchAllNotesDateTime(sort: true, favorite: changeFavorite)
        : _getAllNoteUseCase.watchAllNotesDateTime(sort: false);

    if (_changeDataSearch) {
      streamNotes = _getAllNoteUseCase.watchAllNotesByWord(
          dateTime: searchDateTime, selected: false);
    }

    if (_changeFavorite) {
      streamNotes = _getAllNoteUseCase.watchAllNotesByFavorite(sort: false);
    }

    if (_changeSearch) {
      streamNotes = _getAllNoteUseCase.watchAllNotesByWord(
          word: _searchTextValue, selected: true);
    }

    return streamNotes;
  }

  Stream<List<NoteDTO>> watchAllNotes() {
    return _getAllNoteUseCase.watchAllNotes();
  }

  Future insertNote(NoteDTO dto) {
    return _saveNoteUseCase.insertNote(dto);
  }

  Future deleteNote(NoteDTO dto) {
    return _deleteNoteUseCase.deleteNote(dto);
  }

}