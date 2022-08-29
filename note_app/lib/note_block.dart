import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/db_helper.dart';
import 'package:note_app/note.dart';
import 'package:intl/intl.dart';
import 'package:note_app/note_screen.dart';
import 'package:note_app/note_state.dart';

class NoteBlock extends StatelessWidget {
  final GestureTapCallback toArchiveTap;
  final Note note;
  final DbHelper dbHelper;
  final Function refresh;

  NoteBlock(
      {required this.toArchiveTap,
      required this.note,
      required this.dbHelper,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onDoubleTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteScreen(
                        note: note,
                        dbHelper: dbHelper,
                        refresh: refresh,
                      )));
        },
        child: Container(
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          height: 60.0,
          decoration: BoxDecoration(
              color: note.getColor(), borderRadius: BorderRadius.circular(5)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 70),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        note.title,
                        style: TextStyle(fontSize: 30, color: Colors.grey[100]),
                      ),
                    ),
                  ),
                  Text(
                    DateFormat.yMd().add_jm().format(note.date),
                    style: TextStyle(fontSize: 15, color: Colors.grey[100]),
                  ),
                ],
              ),
              note.state != NoteState.archived
                  ? IconButton(
                      onPressed: toArchiveTap,
                      icon: Icon(
                        CupertinoIcons.archivebox,
                        color: Colors.grey[100],
                        size: 25.0,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ));
  }
}
