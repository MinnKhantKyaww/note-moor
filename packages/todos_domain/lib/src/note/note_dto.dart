class NoteDTO {
  final int id;
  int dateTime;
  String body;
  bool favourite;

  NoteDTO({
    this.id,
    this.dateTime,
    this.body,
    this.favourite = false,}
  );
}
