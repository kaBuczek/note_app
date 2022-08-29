import 'package:flutter/material.dart';
import 'package:note_app/note.dart';
import 'package:intl/intl.dart';
import 'package:note_app/note_state.dart';
import 'package:note_app/db_helper.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen(
      {Key? key,
      required this.note,
      required this.dbHelper,
      required this.refresh})
      : super(key: key);

  final Note note;
  final DbHelper dbHelper;
  final Function refresh;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final GlobalKey<FormState> _noteFormKey = GlobalKey<FormState>();
  bool shouldPop = true;

  @override
  void initState() {
    super.initState();
  }

  updateNote(note) async {
    await widget.dbHelper.update(note);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: widget.note.title);
    TextEditingController contentController =
        TextEditingController(text: widget.note.content);
    return WillPopScope(
      onWillPop: () async {
        if (widget.note.state != NoteState.archived) {
          widget.note.updateNote(titleController.text, contentController.text);
          widget.dbHelper.update(widget.note);
        }
        widget.refresh();
        return shouldPop;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(widget.note.title),
        ),
        body: Form(
          key: _noteFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMd().add_jm().format(widget.note.date),
              ),
              Text(
                'Title:',
                style: TextStyle(fontSize: 25),
              ),
              TextFormField(
                style: TextStyle(fontSize: 25),
                autovalidateMode: AutovalidateMode.always,
                readOnly:
                    widget.note.state != NoteState.inProgress ? true : false,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  errorStyle: TextStyle(color: Colors.red),
                  border: UnderlineInputBorder(),
                  labelText: 'Enter title',
                ),
                minLines: 1,
                maxLines: 2,
              ),
              Text(
                'Content:',
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                style: TextStyle(fontSize: 20),
                readOnly:
                    widget.note.state != NoteState.inProgress ? true : false,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                controller: contentController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Content',
                ),
                minLines: 3,
                maxLines: 3,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 25),
                          primary: Colors.greenAccent.shade400,
                        ),
                        onPressed: widget.note.state == NoteState.inProgress
                            ? () {
                                if (_noteFormKey.currentState?.validate() ==
                                    true) {
                                  widget.note.updateNote(titleController.text,
                                      contentController.text);
                                  widget.note.confirm();
                                  updateNote(widget.note);
                                  widget.refresh();
                                  Navigator.pop(context);
                                }
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Confirm'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 25),
                            primary: Colors.redAccent.shade400,
                          ),
                          onPressed: widget.note.state == NoteState.archived
                              ? null
                              : () {
                                  if (_noteFormKey.currentState?.validate() ==
                                      true) {
                                    widget.note.updateNote(titleController.text,
                                        contentController.text);
                                    widget.note.toArchive();
                                    updateNote(widget.note);
                                    widget.refresh();
                                    Navigator.pop(context);
                                  }
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('To Archive'),
                            ],
                          ),
                        ))
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
