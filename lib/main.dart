import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_moor/database/todos_database.dart';
import 'package:todos_moor/model/DarkTheme.dart';
import 'package:todos_moor/screen/home_page.dart';
import 'package:todos_moor/utils/styles.dart';

void main() {
  runApp(MaterialAppTheme());
}

class MaterialAppTheme extends StatefulWidget {
  @override
  _MaterialAppThemeState createState() => _MaterialAppThemeState();
}

class _MaterialAppThemeState extends State<MaterialAppTheme> {

  DarkTheme darkThemeNotifier = DarkTheme();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  void getCurrentAppTheme() async {
    darkThemeNotifier.darkTheme =
    await darkThemeNotifier.todoSharePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AppDatabase().notesDao,
        ),
        ChangeNotifierProvider<DarkTheme>(
          create: (_) => darkThemeNotifier,
        )

      ],
      child: Consumer<DarkTheme>(
        builder: (context, dark, _) {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles().themeData(darkThemeNotifier.darkTheme, context),
            home: HomePage(),
          );
        },
      ),
    );
  }
}


