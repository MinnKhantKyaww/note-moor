import 'package:flutter/material.dart';

class Styles {

  ThemeData themeData(bool isDarkTheme, BuildContext context) {
    ThemeData _themeData;

    if (isDarkTheme) {
      _themeData = ThemeData.dark().copyWith(
          primaryColorDark: Colors.grey.shade900,
          scaffoldBackgroundColor: Colors.grey.shade900,
          indicatorColor: Colors.lightBlueAccent,
          accentColor: Colors.black,
          primaryColorBrightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.dark(),
          ),
          cardTheme: CardTheme(
            color: Colors.black12,
          ),
          primaryIconTheme: IconThemeData(
              color: Colors.lightBlueAccent
          ),
          iconTheme: IconThemeData(
              color: Colors.lightBlueAccent
          ),
          cursorColor: Colors.white,
          focusColor: Colors.white,
          appBarTheme: AppBarTheme.of(context).copyWith(
              color: Colors.grey.shade900,
              elevation: 0.0,
              textTheme: TextTheme(
                  title: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                  )
              ),
              actionsIconTheme: IconThemeData(
                  color: Colors.lightBlueAccent
              )
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.lightBlueAccent
          )
      );
    } else {
      _themeData = ThemeData.light().copyWith(
          primaryColorLight: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          primaryColorBrightness: Brightness.light,
          accentColor: Colors.white,
          accentColorBrightness: Brightness.light,
          buttonTheme: ButtonThemeData(
            colorScheme: ColorScheme.light(),
          ),
          cardTheme: CardTheme(
            color: Colors.grey.shade100,
          ),
          iconTheme: IconThemeData(
              color: Colors.grey
          ),
          primaryIconTheme: IconThemeData(
              color: Colors.grey
          ),
          cursorColor: Colors.black,
          focusColor: Colors.black,
          appBarTheme: AppBarTheme.of(context).copyWith(
              elevation: 0.0,
              color: Colors.white,
              textTheme: TextTheme(
                  title: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0
                  )
              ),
              actionsIconTheme: IconThemeData(
                  color: Colors.grey
              )
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.blue
          )
      );
    }

    return _themeData;
  }
}
