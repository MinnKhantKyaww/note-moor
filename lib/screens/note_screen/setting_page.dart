import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_moor/screens/note_screen/model/dark_theme_model.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {


  void _selectFilterBottomSheet(
      {BuildContext context,
      String headerText,
      String chooseItem1,
      String chooseItem2,
      bool searchNote,
      bool themeNote}) {
    final _darkTheme = Provider.of<DarkThemeModel>(context);

    _darkTheme.selectedByWord = _darkTheme.darkTheme ? false : true;
    _darkTheme.selectedByDate = _darkTheme.darkTheme ? true : false;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
      ),
      builder: (context) {
        return Container(
          child: Wrap(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    '$headerText',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Consumer<DarkThemeModel>(
                builder: (context, model, child) {
                  return ListTile(
                    leading: model.selectedByWord
                        ? Text(
                      '$chooseItem1',
                      style: TextStyle(fontSize: 16.0, color: Colors.blue),
                    )
                        : Text(
                      '$chooseItem1',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () {
                      setState(() {
                        if (searchNote) {
                          model.selected = true;
                          model.selectedByWord = true;
                          model.selectedByDate = false;
                        }
                        if (themeNote) {
                          model.darkTheme = false;
                          if (model.darkTheme == false) {
                            model.selectedByDate = false;
                            model.selectedByWord = true;
                          }
                        }

                        Navigator.of(context).pop(true);
                      });
                    },
                  );
                },
              ),
              Consumer<DarkThemeModel>(
                builder: (context, model, child) {
                  return ListTile(
                    leading: model.selectedByDate
                        ? Text(
                      '$chooseItem2',
                      style: TextStyle(fontSize: 16.0, color: Colors.blue),
                    )
                        : Text(
                      '$chooseItem2',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    onTap: () {
                      setState(() {
                        if (searchNote) {
                          model.selected = false;
                          model.selectedByDate = true;
                          model.selectedByWord = false;
                        }
                        if (themeNote) {
                          model.darkTheme = true;
                          if (_darkTheme.darkTheme) {
                            model.selectedByWord = false;
                            model.selectedByDate = true;
                          }
                        }

                        Navigator.of(context).pop(true);
                      });
                    },
                  );
                },
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Setting',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'STYLE',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Select how you want to search your notes',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      selected ? 'By word' : 'By date',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey.shade400,
                    ),
                  )
                ],
              ),
              onTap: () {
                _selectFilterBottomSheet(context: context, headerText: 'Select how you want to search your notes',
                chooseItem1: 'By word', chooseItem2: 'By date', searchNote: true, themeNote: false);
              },
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Dark Theme',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Consumer<DarkThemeModel>(
                      builder: (context, dark, _) {
                        return Text(
                          dark.darkTheme ? 'On' : 'Off',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey.shade400,
                    ),
                  )
                ],
              ),
              onTap: () {
                _selectFilterBottomSheet(
                    context: context,
                    headerText: 'Select dark theme',
                    chooseItem1: 'Dark theme Off',
                    chooseItem2: 'Dark theme On',
                    searchNote: false,
                    themeNote: true);
              },
            ),
          )
        ],
      ),
    );
  }
}
