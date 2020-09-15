import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todos_moor/database/todos_database.dart';
import 'package:todos_moor/screen/edit_page.dart';

final _dateFormat = DateFormat.yMMMd().add_jm();
final _hourFormat = DateFormat.jm();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool changeListView = false;

  String getDateTimeRepresentation(Note note, NotesDao notesDao) {
    DateTime localDateTime = note.datetime.toLocal();
    DateTime now = DateTime.now();

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return _hourFormat.format(note.datetime);
    }

    DateTime yesterday = now.subtract(Duration(days: 1));
    if (localDateTime.day == yesterday.day &&
        localDateTime.month == yesterday.month &&
        localDateTime.year == yesterday.year) {
      return "Yesterday ${_hourFormat.format(note.datetime)}";
    }

    return _dateFormat.format(note.datetime);
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'TODO NOTE',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: changeListView
                ? Icon(
                    Icons.grid_on,
                    size: 25,
                    color: Colors.lightBlue,
                  )
                : Icon(
                    Icons.view_list,
                    size: 25,
                    color: Colors.lightBlue,
                  ),
            onPressed: () {
              setState(() {
                if (changeListView) {
                  changeListView = false;
                } else {
                  changeListView = true;
                }
              });
            },
          ),
        )
      ],
      elevation: 0,
    );
  }

  Widget _buildListView(NotesDao notesDao) {
    return StreamBuilder(
      stream: notesDao.watchALlNotes(),
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        final notes = snapShot.data ?? List();
        if (changeListView) {
          return AnimatedOpacity(
            opacity: changeListView ? 1.0 : 0.0,
            duration: Duration(milliseconds: 6000),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return _buildListItem(note, notesDao);
              },
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          );
        } else {
          return AnimatedOpacity(
            opacity: changeListView ? 0.0 : 1.0,
            duration: Duration(milliseconds: 6000),
            child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return _buildListItem(note, notesDao);
                }),
          );
        }
      },
    );
  }

  Widget _buildListItem(Note note, NotesDao notesDao) {
    bool updateFav = note.favourite;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.grey.shade100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(note.body),
          subtitle: Text(getDateTimeRepresentation(note, notesDao)),
          trailing: GestureDetector(
            onTap: () {
              if (updateFav) {
                notesDao.updateNote(note.copyWith(favourite: false));
                updateFav = false;
              } else {
                notesDao.updateNote(note.copyWith(favourite: true));
                updateFav = true;
              }
            },
            child: Icon(
              updateFav ? Icons.favorite : Icons.favorite_border,
              color: updateFav ? Colors.blue : null,
            ),
          ),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return EditPage(note: note);
            })).then((value) => notesDao.watchALlNotes());
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Are u sure want to delete?"),
                    actions: [
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        onPressed: () {
                          notesDao
                              .deleteNote(note)
                              .then((value) => Navigator.of(context).pop(true));
                        },
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var notesDao = Provider.of<NotesDao>(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildListView(notesDao),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return EditPage(
              note: Note(),
            );
          }));
        },
      ),
    );
  }
}
