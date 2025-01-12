import 'package:flutter_sql_database/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// 1- Database Initialization: The NotesDatabase class initializes the database and creates the notes table if it doesn't exist.
// 2- CRUD Operations: The class provides methods to create, read, update, and delete notes.
class NotesDatabase {
  // create private Constructor and  initialize the object
  // create instance of the class
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // initialize database
    _database = await _initDatabase('notes.db');

    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbFilePath = await getDatabasesPath();

    final path = join(dbFilePath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes (
${NoteFields.id} $idType, 
${NoteFields.isImportant} $boolType, 
${NoteFields.number} $intType, 
${NoteFields.title} $textType,
${NoteFields.description} $textType, 
${NoteFields.createdat} $textType) 
      ''');
  }

  Future dbColse() async {
    final db = await instance.database;

    db.close();
  }


// methods to create, read, update, and delete notes.
// Create Note
  Future<NoteModel> createNote(NoteModel note) async {
    // first get reference to our database
    final db = await instance.database;
// insert data and convert it to a map
    final id = await db.insert(tableNotes, note.toJson());

    return note.copyNote(id: id);
  }


//read Note
  Future<NoteModel> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return NoteModel.fromJson(maps.first);
    } else {
      throw Exception('ID not found');
    }
  }

// Read All Notes
  Future<List<NoteModel>> readAllNotes() async {
    final db = await  instance.database;
    const orderByTime = '${NoteFields.createdat} ASC';
    final result = await db.query(tableNotes, orderBy: orderByTime);

    return result.map((json) => NoteModel.fromJson(json)).toList();
  }

//Update Note
  Future<int> updateNote(NoteModel note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

// delete Note
  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }
}
