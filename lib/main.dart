import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_data_source/todos_data_source.dart';
import 'package:todos_moor/screens/note_screen/model/dark_theme_model.dart';
import 'package:todos_moor/screens/note_screen/home_page.dart';
import 'package:todos_moor/service_locator.dart';
import 'package:todos_moor/utils/styles.dart';

void main() {
  runApp(Provider<ServiceLocator>(
    create: (context) => DefaultServiceLocator(NoteDatabase()),
      dispose: (context, s) => s.close(),
      child: ChangeNotifierProvider(
        create: (context) => Provider.of<ServiceLocator>(context, listen: false).darkThemeModel,
          child: MaterialAppTheme())
  ));
}

class MaterialAppTheme extends StatefulWidget {
  @override
  _MaterialAppThemeState createState() => _MaterialAppThemeState();
}

class _MaterialAppThemeState extends State<MaterialAppTheme> {

  @override
  void initState() {
    getCurrentAppTheme(context);
    super.initState();
  }

  getCurrentAppTheme(BuildContext context) async {
    final serviceLocator = Provider.of<ServiceLocator>(context, listen: false);
    await serviceLocator.darkThemeModel.todoSharePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    final serviceLocator = Provider.of<ServiceLocator>(context, listen: false);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => serviceLocator.noteListModel,
        ),
        ChangeNotifierProvider<DarkThemeModel>(
          create: (_) => serviceLocator.darkThemeModel,
        )

      ],
      child: Consumer<DarkThemeModel>(
        builder: (context, model, child) {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles().themeData(model.darkTheme, context),
            home: HomePage(),
          );
        },
      ),
    );
  }
}


