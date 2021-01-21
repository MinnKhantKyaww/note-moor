import 'package:flutter/material.dart';
import 'package:todos_moor/utils/todo_share_preference.dart';

class DarkThemeModel with ChangeNotifier {
  TodoSharePreference todoSharePreference = TodoSharePreference();
  bool _darkTheme = false;
  bool _selected = true;
  bool _selectedByWord = true;
  bool _selectedByDate = false;


  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    todoSharePreference.setTheme(value);
    notifyListeners();
  }

  bool get selected => _selected;

  set selected(bool select) {
    _selected = select;
    notifyListeners();
  }

  bool get selectedByWord => _selectedByWord;

  set selectedByWord(bool selectedWord) {
    _selectedByWord = selectedWord;
    notifyListeners();
  }

  bool get selectedByDate => _selectedByDate;

  set selectedByDate(bool selectedByDate) {
    _selectedByDate = selectedByDate;
    notifyListeners();
  }

}
