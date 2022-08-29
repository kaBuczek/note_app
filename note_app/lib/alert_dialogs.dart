import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/note.dart';

showArchiveAlertDialog(
    BuildContext context, Note note, Function updateNote, Function refresh) {
  Widget cancelButton = TextButton(
    child: Text("NO"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("YES"),
    onPressed: () {
      note.toArchive();
      updateNote(note);
      refresh();
      Navigator.of(context).pop();
    },
  ); // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Move to archive?"),
    content: Text(
        "Are you sure you'd like to move this note to archive? This cannot be undone"),
    actions: [
      cancelButton,
      continueButton,
    ],
  ); // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
