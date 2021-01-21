import 'package:todos_data_source/src/dao/note_dao.dart';
import 'package:todos_data_source/src/entity/note_entity.dart';
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'note_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'note-database.db'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Notes], daos: [NotesDao])
class NoteDatabase extends _$NoteDatabase {
  NoteDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}