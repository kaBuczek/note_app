import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:note_app/note_state.dart';
import 'package:flutter/material.dart';
import 'package:note_app/main.dart';
import 'package:note_app/db_helper.dart';

class Note {
  late String title;
  late String content;
  late NoteState state;
  late DateTime date;
  late int id;

  Note(this.id,
      {this.title = '', this.content = '', this.state = NoteState.inProgress}) {
    date = DateTime.now();
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    content = map['content'];
    date = DateTime.parse(map['date']);
    state = intToState(map['state']);
  }

  Map<String, dynamic> toMap() {
    return {
      DbHelper.columnId: id,
      DbHelper.columnTitle: title,
      DbHelper.columnDate: date.toString(),
      DbHelper.columnState: stateToInt(),
      DbHelper.columnContent: content
    };
  }

  void toArchive() {
    state = NoteState.archived;
  }

  void confirm() {
    state = NoteState.confirmed;
  }

  Color getColor() {
    switch (state) {
      case NoteState.archived:
        return Colors.red.shade600;
      case NoteState.inProgress:
        return Colors.blue.shade300;
      case NoteState.confirmed:
        return Colors.greenAccent.shade400;
      default:
        return Colors.blue.shade300;
    }
  }

  String dateToString() {
    return date.toString();
  }

  int stateToInt() {
    return (state == NoteState.confirmed)
        ? 1
        : (state == NoteState.archived)
            ? 2
            : 0;
  }

  NoteState intToState(int i) {
    if (i == 0) return NoteState.inProgress;
    if (i == 1)
      return NoteState.confirmed;
    else
      return NoteState.archived;
  }

  void updateNote(String newTitle, String newContent) {
    title = newTitle;
    content = newContent;
  }
}
