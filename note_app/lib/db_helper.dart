import 'package:note_app/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static final _dbName = "notesdb";
  static final _dbVersion = 1;

  static final table = 'notes_table';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDate = 'date';
  static final columnContent = 'content';
  static final columnState = 'state';

  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnContent TEXT NOT NULL,
            $columnState INTEGER NOT NULL)''');
  }

  Future<int> insert(Note note) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'title': note.title,
      'date': note.dateToString(),
      'content': note.content,
      'state': note.stateToInt()
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Note note) async {
    Database db = await instance.database;
    int id = note.toMap()['id'];
    return await db
        .update(table, note.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }
}
