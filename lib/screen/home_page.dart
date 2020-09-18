import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todos_moor/database/todos_database.dart';
import 'package:todos_moor/screen/edit_page.dart';
import 'package:todos_moor/screen/setting_page.dart';

final _dateFormat = DateFormat.yMMMd().add_jm();
final _hourFormat = DateFormat.jm();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool changeListView = false;

  bool changeBySort = false;

  bool changeFavorite = false;

  bool changeSearch = false;

  bool changeDateSearch = false;

  bool refreshAll = false;

  DateTime searchDateTime = DateTime.now();

  TextEditingController _searchController;
  SettingPage _settingPage = SettingPage();

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<Note>> dataCollectors(NotesDao notesDao) {
    Stream<List<Note>> streamNotes;

    streamNotes = notesDao.watchAllNotes();

    streamNotes = changeBySort
        ? notesDao.watchAllNotesDateTime(sort: true, favorite: changeFavorite)
        : notesDao.watchAllNotesDateTime(sort: false);

    if (changeFavorite) {
      streamNotes = notesDao.watchAllNotesByFavorite(sort: false);
    }

    if (changeSearch) {
      streamNotes = notesDao.watchAllNotesByWord(
          word: _searchController.text, selected: true);
    }

    if (changeDateSearch) {
      streamNotes = notesDao.watchAllNotesByWord(
          dateTime: searchDateTime, selected: false);
    }

    return streamNotes;
  }

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

  Widget _buildSearchTextField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      decoration: ShapeDecoration(
          color: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          )),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                changeSearch = true;
              });
            },
            child: Icon(
                Icons.search,
                color: Colors.grey,
              ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              cursorColor: Colors.black,
              autofocus: false,
              decoration: InputDecoration.collapsed(
                  hintText: "Search notes",
                  filled: true,
                  fillColor: Colors.transparent),
              onChanged: (value) {
                setState(() {
                  value.isEmpty ? changeSearch = false : changeSearch = true;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar(NotesDao notesDao) {
    return AppBar(
      title: Text(
        'TODO NOTE',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        /*IconButton(
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
        ),*/
        IconButton(
          icon: changeFavorite
              ? Icon(
                  Icons.bookmark,
                  color: Colors.lightBlue,
                )
              : Icon(
                  Icons.bookmark_border,
                  color: Colors.lightBlue,
                ),
          onPressed: () {
            setState(() {
              if (changeFavorite) {
                changeFavorite = false;
              } else {
                changeFavorite = true;
              }
            });
          },
        ),
        PopupMenuButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          icon: Icon(
            Icons.more_vert,
            color: Colors.lightBlue,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 3,
              child: Text('Setting'),
            ),
            PopupMenuItem(
              value: 4,
              child: changeListView ? Text('List view') : Text('Grid view'),
            ),
            PopupMenuItem(
              value: changeBySort ? 2 : 1,
              child: changeBySort ? Text('Date by desc') : Text('Date by asc'),
            )
          ],
          onSelected: (value) {
            setState(() {
              if (value == 1) {
                changeBySort = true;
              } else if (value == 2) {
                changeBySort = false;
              } else if (value == 3) {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SettingPage()));
              } else if (value == 4) {
                setState(() {
                  if (changeListView) {
                    changeListView = false;
                  } else {
                    changeListView = true;
                  }
                });
              }
            });
          },
        )
      ],
      elevation: 0,
    );
  }

  Widget _buildListView(NotesDao notesDao) {
    return StreamBuilder(
      stream: dataCollectors(notesDao),
      builder: (BuildContext context, AsyncSnapshot snapShot) {
        final notes = snapShot.data ?? List();
        if (changeListView) {
          return StaggeredGridView.countBuilder(
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
          );
        } else {
          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return _buildListItem(note, notesDao);
              });
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
          title: Text(
            note.body,
            overflow: TextOverflow.ellipsis,
          ),
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
              updateFav ? Icons.bookmark : Icons.bookmark_border,
              color: updateFav ? Colors.blue : null,
            ),
          ),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return EditPage(note: note);
            })).then((value) => notesDao.watchAllNotes());
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
      appBar: _buildAppBar(notesDao),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 7,
                child: _buildSearchTextField(context),
              ),
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: searchDateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2500));

                    setState(() {
                      if (selectedDate != null) {
                        changeDateSearch = true;
                        searchDateTime = selectedDate;
                      }
                    });
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: _buildListView(notesDao),
          )
        ],
      ),
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
