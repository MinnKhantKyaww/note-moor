import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_moor/database/todos_database.dart';
import 'package:todos_moor/screen/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => AppDatabase().notesDao,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData().copyWith(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: HomePage(),
      ),
    );
  }
}

