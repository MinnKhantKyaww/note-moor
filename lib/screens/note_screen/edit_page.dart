import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todos_domain/todos_domain.dart';
import 'package:todos_moor/screens/note_screen/model/note_edit_model.dart';

final _dateFormat = DateFormat.yMMMMd().add_jm();

class EditPage extends StatefulWidget {
  final NoteDTO note;

  const EditPage({this.note});

  @override
  _EditPageState createState() => _EditPageState();
}

Widget _buildTextField(TextEditingController contentController,
    String createdDateTime, NoteDTO dto) {
  return ListView(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
        child: Text(createdDateTime),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: TextField(
          controller: contentController,
          autofocus: dto.id == null ? true : false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration:
              InputDecoration.collapsed(hintText: "", border: InputBorder.none),
        ),
      )
    ],
  );
}

class _EditPageState extends State<EditPage> {
  TextEditingController _contentController;
  int _createdDateTime;

  @override
  void initState() {
    _contentController = TextEditingController(text: widget.note.body);
    _createdDateTime = widget.note.dateTime == null
        ? DateTime.now().toUtc().millisecondsSinceEpoch
        : widget.note.dateTime;
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  AppBar _buildAppbar(NoteEditModel model) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Visibility(
          visible: widget.note.id != null ? true : false,
          child: IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 30,
            ),
            onPressed: () {
              model
                  .deleteNote(widget.note)
                  .whenComplete(() => Navigator.of(context).pop(true));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.check,
              size: 30,
            ),
            onPressed: () {
              if (_contentController != null &&
                  _contentController.text.isNotEmpty) {
                if (widget.note.id == null) {
                  model
                      .insertNote(NoteDTO(
                          dateTime: _createdDateTime,
                          body: _contentController.text))
                      .then((value) => Navigator.pop(context));
                } else {
                  if (_contentController.text.length >
                          widget.note.body.length ||
                      _contentController.text.length <
                          widget.note.body.length) {
                    /*_createdDateTime =
                        DateTime.now().toUtc().millisecondsSinceEpoch;*/
                    model.insertNote(NoteDTO(
                        id: widget.note.id,
                        dateTime: _createdDateTime,
                        body: _contentController.text,
                    favourite: widget.note.favourite))
                    .then((value) => Navigator.pop(context));
                  }
                }
              }
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NoteEditModel>(context, listen: false);

    String createdDateTime;
    if (_createdDateTime != null) {
      createdDateTime = _dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(_createdDateTime));
    }

    return Scaffold(
      appBar: _buildAppbar(model),
      body: _buildTextField(_contentController, createdDateTime, widget.note),
    );
  }
}
