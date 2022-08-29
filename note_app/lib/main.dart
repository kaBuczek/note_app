import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/filter_state.dart';
import 'package:note_app/note.dart';
import 'package:note_app/note_block.dart';
import 'package:note_app/note_state.dart';
import 'package:note_app/search_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:note_app/db_helper.dart';
import 'package:note_app/note_screen.dart';
import 'package:note_app/alert_dialogs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotesApp',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'NotesApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DbHelper.instance;

  List<Note> notesList = [];
  List<Note> filteredNotesList = [];
  FilterState filterState = FilterState();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _queryAll();
    searchController.addListener(() {
      if (searchController.text.length > 2) {
        filterState.searchedPhrase = searchController.text;
      } else {
        filterState.searchedPhrase = '';
      }
      filterList();
    });
  }

  int createNewId() {
    return notesList.length;
  }

  refresh() {
    setState(() {
      filterList();
    });
  }

  void filterList() {
    setState(() {
      filteredNotesList = [];
      notesList.forEach((element) {
        if ((element.state == NoteState.inProgress &&
                    filterState.inProgress == true ||
                element.state == NoteState.confirmed &&
                    filterState.confirmed == true ||
                element.state == NoteState.archived &&
                    filterState.archived == true) &&
            (filterState.byDate == false ||
                filterState.byDate == true &&
                    isSameDay(element.date, _selectedDay)) &&
            (filterState.searchedPhrase == '' ||
                element.title
                    .toLowerCase()
                    .contains(filterState.searchedPhrase.toLowerCase()) ||
                element.content
                    .toLowerCase()
                    .contains(filterState.searchedPhrase.toLowerCase()))) {
          filteredNotesList.insert(0, element);
        }
      });
    });
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    notesList.clear();
    allRows.forEach((row) => notesList.add(Note.fromMap(row)));
    refresh();
  }

  void _insert(Note note) async {
    await dbHelper.insert(note);
  }

  void _insertAll(List<Note> list) {
    list.forEach((element) {
      dbHelper.insert(element);
    });
  }

  void addNewNote() {
    notesList.add(Note(notesList.length + 1));
    dbHelper.insert(notesList.last);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteScreen(
                  note: notesList.last,
                  dbHelper: dbHelper,
                  refresh: refresh,
                )));
  }

  updateNote(note) async {
    await dbHelper.update(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  iconSize: 40,
                  tooltip: 'AddNote',
                  icon: const Icon(Icons.note_add_outlined),
                  onPressed: addNewNote,
                ),
                IconButton(
                  iconSize: 40,
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: SearchBar(
                              context: context,
                              refresh: refresh,
                              filterState: filterState,
                              searchController: searchController,
                            ),
                          );
                        });
                  },
                ),
                IconButton(
                  iconSize: 40,
                  tooltip: 'Filter',
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        bool inProgressSwitchValue = filterState.inProgress;
                        bool confirmedSwitchValue = filterState.confirmed;
                        bool archivedSwitchValue = filterState.archived;
                        bool byDateSwitchValue = filterState.byDate;
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                            ),
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: Center(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size.fromHeight(50)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: FittedBox(
                                            fit: BoxFit.fill,
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                            ))),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('In progress'),
                                        CupertinoSwitch(
                                            value: inProgressSwitchValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                inProgressSwitchValue =
                                                    newValue;
                                                filterState.inProgress =
                                                    newValue;
                                              });
                                              refresh();
                                            })
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Confirmed'),
                                        CupertinoSwitch(
                                            value: confirmedSwitchValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                confirmedSwitchValue = newValue;
                                                filterState.confirmed =
                                                    newValue;
                                              });
                                              refresh();
                                            })
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Archived'),
                                        CupertinoSwitch(
                                            value: archivedSwitchValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                archivedSwitchValue = newValue;
                                                filterState.archived = newValue;
                                              });
                                              refresh();
                                            })
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Filter by Date'),
                                        CupertinoSwitch(
                                            value: byDateSwitchValue,
                                            onChanged: (newValue) {
                                              setState(() {
                                                byDateSwitchValue = newValue;
                                                filterState.byDate = newValue;
                                              });
                                              refresh();
                                            })
                                      ],
                                    ),
                                    TableCalendar(
                                      headerStyle: HeaderStyle(
                                          formatButtonVisible: false),
                                      firstDay: DateTime.utc(2010, 10, 16),
                                      lastDay: DateTime.utc(2030, 3, 14),
                                      focusedDay: _selectedDay,
                                      startingDayOfWeek:
                                          StartingDayOfWeek.monday,
                                      calendarFormat: CalendarFormat.week,
                                      calendarStyle: CalendarStyle(
                                          selectedDecoration: BoxDecoration(
                                        color: Colors.greenAccent.shade400,
                                        shape: BoxShape.circle,
                                      )),
                                      selectedDayPredicate: (day) {
                                        return isSameDay(_selectedDay, day);
                                      },
                                      onDaySelected: (selectedDay, focusedDay) {
                                        setState(() {
                                          _selectedDay = selectedDay;
                                          _focusedDay = focusedDay;
                                        });
                                        refresh();
                                      },
                                    ),
                                  ]),
                            ),
                          );
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(
              child: ListView.builder(
            itemCount: filteredNotesList.length,
            itemBuilder: (BuildContext context, int index) {
              return NoteBlock(
                  note: filteredNotesList[index],
                  dbHelper: dbHelper,
                  refresh: refresh,
                  toArchiveTap: () {
                    showArchiveAlertDialog(
                        context, filteredNotesList[index], updateNote, refresh);
                  });
            },
          )),
        ]));
  }
}
