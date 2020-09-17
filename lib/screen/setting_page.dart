import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_moor/database/todos_database.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool selected = true;
  bool selectedByWord = true;
  bool selectedByDate = false;

  bool getSelected() {
    return selected;
  }

  void _selectFilterBottomSheet(BuildContext context) {
    final notesDao = Provider.of<NotesDao>(context);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0)),
      ),
      builder: (context) {
        return Container(
          child: Wrap(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    'Select how you want to search your notes',
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListTile(
                leading: selectedByWord
                    ? Text(
                        'By word',
                        style: TextStyle(fontSize: 16.0, color: Colors.blue),
                      )
                    : Text(
                        'By word',
                        style: TextStyle(fontSize: 16.0),
                      ),
                onTap: () {
                  setState(() {
                    selected = true;
                    selectedByWord = true;
                    selectedByDate = false;

                    Navigator.of(context).pop(true);
                  });
                },
              ),
              ListTile(
                leading: selectedByDate
                    ? Text(
                        'By date',
                        style: TextStyle(fontSize: 16.0, color: Colors.blue),
                      )
                    : Text(
                        'By date',
                        style: TextStyle(fontSize: 16.0),
                      ),
                onTap: () {
                  setState(() {
                    selected = false;
                    selectedByDate = true;
                    selectedByWord = false;

                    Navigator.of(context).pop(true);
                  });
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
                      color: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey.shade800),
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
        iconTheme: IconThemeData(color: Colors.lightBlue),
        title: Text(
          'Setting',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
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
                _selectFilterBottomSheet(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
