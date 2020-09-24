import 'package:shared_preferences/shared_preferences.dart';

class TodoSharePreference {
  static const DARK_THEME = 'DARKTHEMESTATUS';

  Future<bool> getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(DARK_THEME) ?? false;
  }

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(DARK_THEME, value);
  }

}