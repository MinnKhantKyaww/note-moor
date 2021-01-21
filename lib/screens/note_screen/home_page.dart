import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todos_domain/todos_domain.dart';
import 'package:todos_moor/screens/note_screen/edit_page.dart';
import 'package:todos_moor/screens/note_screen/model/note_list_model.dart';
import 'package:todos_moor/screens/note_screen/setting_page.dart';
import 'package:todos_moor/service_locator.dart';

final _dateFormat = DateFormat.yMMMd().add_jm();
final _hourFormat = DateFormat.jm();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _searchController;
  FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _searchController = TextEditingController();
    _focusNode.unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String getDateTimeRepresentation(NoteDTO note) {
    DateTime localDateTime = DateTime.fromMillisecondsSinceEpoch(note.dateTime).toLocal();
    DateTime now = DateTime.now();

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return "Today ${_hourFormat.format(DateTime.fromMillisecondsSinceEpoch(note.dateTime))}";
    }

    DateTime yesterday = now.subtract(Duration(days: 1));
    if (localDateTime.day == yesterday.day &&
        localDateTime.month == yesterday.month &&
        localDateTime.year == yesterday.year) {
      return "Yesterday ${_hourFormat.format(DateTime.fromMillisecondsSinceEpoch(note.dateTime))}";
    }

    return _dateFormat.format(DateTime.fromMillisecondsSinceEpoch(note.dateTime));
  }

  Widget _buildSearchTextField(BuildContext context) {
    final listModel = Provider.of<ServiceLocator>(context, listen: false).noteListModel;
    return Card(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                listModel.changeSearch = true;

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
              child: Consumer<NoteListModel>(
                builder: (context, model, child) {
                  return TextField(
                    controller: _searchController,
                    autofocus: false,
                    focusNode: _focusNode,
                    decoration: InputDecoration.collapsed(
                        hintText: "Search notes",
                        filled: true,
                        fillColor: Colors.transparent),
                    onChanged: (value) {
                      model.searchTextValue = value;
                      if(value.isEmpty && !model.changeSearch) {
                        model.changeSearch = false;
                      } else {
                        model.changeSearch = true;
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'TODO NOTE',
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
              if (changeListView) {
                changeListView = false;
              } else {
                changeListView = true;
              }
          },
        ),*/
        Consumer<NoteListModel>(
          builder: (context, model, child) {
            return IconButton(
              icon: model.changeFavorite
                  ? Icon(
                Icons.bookmark,
              )
                  : Icon(
                Icons.bookmark_border,
              ),
              onPressed: () {
                if (model.changeFavorite) {
                  model.changeFavorite = false;
                } else {
                  model.changeFavorite = true;
                }
              },
            );
          },
        ),
        Consumer<NoteListModel>(
          builder: (context, model, child) {
            return PopupMenuButton(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 3,
                  child: Text('Setting'),
                ),
                PopupMenuItem(
                  value: 4,
                  child: model.changeListView ? Text('List view') : Text('Grid view'),
                ),
                PopupMenuItem(
                  value: model.changeBySort ? 2 : 1,
                  child: model.changeBySort ? Text('Date by desc') : Text('Date by asc'),
                )
              ],
              onSelected: (value) {
                if (value == 1) {
                  model.changeBySort = true;
                } else if (value == 2) {
                  model.changeBySort = false;
                } else if (value == 3) {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => SettingPage()));
                } else if (value == 4) {
                  if (model.changeListView) {
                    model.changeListView = false;
                  } else {
                    model.changeListView = true;
                  }
                }
              },
            );
          },
        )
      ],
      elevation: 0,
    );
  }

  Widget _buildListView() {
    return Consumer<NoteListModel>(
      builder: (context, model, child) {
        return StreamBuilder(
          stream: model.dataCollectors(),
          builder: (BuildContext context, AsyncSnapshot snapShot) {
            final notes = snapShot.data ?? List();
            if (model.changeListView) {
              return StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return _buildListItem(note, model);
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
                    return _buildListItem(note, model);
                  });
            }
          },
        );
      },
    );
  }

  Widget _buildListItem(NoteDTO note, NoteListModel model) {
    bool updateFav = note.favourite;
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(
            note.body,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(getDateTimeRepresentation(note)),
          trailing: GestureDetector(
            onTap: () {
              if (note.favourite) {
                note.favourite = false;
                model.insertNote(note);
                updateFav = false;
              } else {
                note.favourite = true;
                model.insertNote(note);
                updateFav = true;
              }
            },
            child: Icon(
              updateFav ? Icons.bookmark : Icons.bookmark_border,
            ),
          ),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return ChangeNotifierProvider(
                create: (_) => Provider.of<ServiceLocator>(context, listen: false).noteEditModel,
                  child: EditPage(note: note));
            })).then((value) => model.watchAllNotes());
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
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
                          model.deleteNote(note)
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

    final serviceLocator = Provider.of<ServiceLocator>(context, listen: false);

    return Scaffold(
      appBar: _buildAppBar(),
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
                child: Consumer<NoteListModel>(
                  builder: (context, model, child) {
                    return IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                      ),
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: model.searchDateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2500));

                        if (selectedDate != null && !model.changeDataSearch) {
                          model.changeDataSearch = true;
                          model.searchDateTime = selectedDate;
                        } else {
                          model.changeDataSearch = false;
                        }
                      },
                    );
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: _buildListView(),
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
            return ChangeNotifierProvider(
              create: (_) => serviceLocator.noteEditModel,
              child: EditPage(
                note: NoteDTO(),
              ),
            );
          }));
        },
      ),
    );
  }
}
