import 'package:moor/moor.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get datetime => integer()();

  TextColumn get body => text()();

  BoolColumn get favourite => boolean().withDefault(Constant(false))();
}