import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../models/note_model.dart';

class SqfliteHelper {
  // Singleton pattern agar koneksi database hanya ada satu instance
  static final SqfliteHelper instance = SqfliteHelper._init();
  static Database? _database;

  SqfliteHelper._init();

  // Nama Database, Nama Tabel, dan Nama Kolom
  static const String dbName = 'notes_database.db';
  static const String tableName = 'notes';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colContent = 'content';
  static const String colCategory = 'category';
  static const String colCreatedAt = 'created_at';

  // Getter database dengan lazy initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(dbName);
    return _database!;
  }

  // Inisialisasi Database
  Future<Database> _initDB(String filePath) async {
    String path;

    if (kIsWeb) {
      // Inisialisasi untuk Web (Chrome / Edge)
      databaseFactory = databaseFactoryFfiWeb;
      path = filePath;
    } else {
      // Inisialisasi untuk Windows / Linux Desktop FFI
      if (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Pembuatan Skema Tabel SQLite
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableName (
        $colId $idType,
        $colTitle $textType,
        $colContent $textType,
        $colCategory $textType,
        $colCreatedAt $textType
      )
    ''');
  }

  // CREATE: Menyimpan data catatan baru ke database
  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(
      tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return note.copyWith(id: id);
  }

  // READ: Mengambil seluruh data catatan dari database
  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    const orderBy = '$colId DESC';
    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((json) => Note.fromMap(json)).toList();
  }

  // READ (Single): Mengambil satu catatan berdasarkan ID
  Future<Note?> getNoteById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // UPDATE: Memperbarui data catatan yang sudah ada
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      tableName,
      note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE: Menghapus data catatan berdasarkan ID
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL: Menghapus semua data
  Future<int> deleteAllNotes() async {
    final db = await instance.database;
    return await db.delete(tableName);
  }

  // Tutup koneksi database
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
