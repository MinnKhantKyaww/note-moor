import 'package:flutter/material.dart';

class Styles {
  ThemeData themeData(bool isDarkTheme, BuildContext context) {
    ThemeData _themeData;

    if (isDarkTheme) {
      _themeData = ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.grey.shade900,
          accentColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.grey,
          secondary: Colors.lightBlue,
          secondaryVariant: Colors.white,
          primaryVariant: Colors.white,
          onSecondary: Colors.grey.shade900,
          onBackground: Colors.white,
          onPrimary: Colors.black,
          background: Colors.white,
          brightness: Brightness.dark
        ),
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.dark(),
        ),
        cardTheme: CardTheme(
          color: Colors.black12,
        ),
        primaryIconTheme: IconThemeData(color: Colors.lightBlueAccent),
        iconTheme: IconThemeData(color: Colors.lightBlueAccent),
        cursorColor: Colors.white,
        focusColor: Colors.white,
        indicatorColor: Colors.lightBlueAccent,
        appBarTheme: AppBarTheme.of(context).copyWith(
            color: Colors.grey.shade900,
            elevation: 0.0,
            textTheme: TextTheme(
                headline6: TextStyle(color: Colors.white, fontSize: 18.0)),
          ),
      );
    } else {
      _themeData = ThemeData.light().copyWith(
        /*primaryColorLight: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          primaryColorBrightness: Brightness.light,
          accentColor: Colors.white,
          accentColorBrightness: Brightness.light,*/
        accentColor: Colors.grey,
        accentColorBrightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blue.shade500,
          secondaryVariant: Colors.blue,
          primaryVariant: Colors.blue,
          onSecondary: Colors.white,
          onBackground: Colors.blue,
          brightness: Brightness.light
        ),
        buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(),
        ),
        cardTheme: CardTheme(
          color: Colors.grey.shade100,
        ),
        iconTheme: IconThemeData(color: Colors.grey),
        primaryIconTheme: IconThemeData(color: Colors.grey),
        cursorColor: Colors.black,
        focusColor: Colors.black,
        appBarTheme: AppBarTheme.of(context).copyWith(
            elevation: 0.0,
            color: Colors.white,
            textTheme: TextTheme(
                headline6: TextStyle(color: Colors.black, fontSize: 18.0))),
      );
    }

    return _themeData;
  }
}
