import 'package:moor/moor.dart';
import 'package:todos_data_source/src/note_database.dart';
import 'package:todos_domain/todos_domain.dart';

extension NoteEntityExtenison on Note {
  NoteDTO toData() {
    return NoteDTO(
      id: id,
      dateTime: datetime,
      body: body,
      favourite: favourite,
    );
  }
}

extension NoteExtension on NoteDTO {
  NotesCompanion toEntry() {
    return NotesCompanion(
      id: id != null ? Value(id) : Value.absent(),
      datetime: Value(dateTime),
      body: Value(body),
      favourite: Value(favourite),
    );
  }
}
