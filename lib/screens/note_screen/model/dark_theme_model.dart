import 'package:flutter/material.dart';
import 'package:todos_moor/utils/todo_share_preference.dart';

class DarkThemeModel with ChangeNotifier {
  TodoSharePreference todoSharePreference = TodoSharePreference();
  bool _darkTheme = false;


  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    todoSharePreference.setTheme(value);
    notifyListeners();
  }
}
