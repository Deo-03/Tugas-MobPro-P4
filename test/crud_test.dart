import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_local_storage_crud/models/note_model.dart';

void main() {
  group('1. Pengujian Model Note', () {
    test('Note toMap dan fromMap harus konsisten', () {
      final note = Note(
        id: 1,
        title: 'Belajar SQFlite',
        content: 'Materi Local Storage Flutter di Lab Ilmu Komputer',
        category: 'Kuliah',
        createdAt: '2026-11-02 10:00',
      );

      final map = note.toMap();
      expect(map['title'], 'Belajar SQFlite');
      expect(map['content'], 'Materi Local Storage Flutter di Lab Ilmu Komputer');
      expect(map['category'], 'Kuliah');

      final reconstructed = Note.fromMap(map);
      expect(reconstructed.id, 1);
      expect(reconstructed.title, note.title);
      expect(reconstructed.content, note.content);
      expect(reconstructed.category, note.category);
    });
  });

  group('2. Pengujian CRUD SQFlite Database', () {
    late Database db;

    setUpAll(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      // Buka in-memory database untuk pengujian cepat & terisolasi
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE notes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              category TEXT NOT NULL,
              created_at TEXT NOT NULL
            )
          ''');
        },
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('SQFlite: CREATE & READ data catatan', () async {
      final id = await db.insert('notes', {
        'title': 'Tugas Mobile',
        'content': 'Kerjakan SQFlite CRUD',
        'category': 'Tugas',
        'created_at': '2026-11-02 11:00',
      });
      expect(id, isPositive);

      final result = await db.query('notes');
      expect(result.length, 1);
      expect(result.first['title'], 'Tugas Mobile');
    });

    test('SQFlite: UPDATE data catatan', () async {
      final id = await db.insert('notes', {
        'title': 'Tugas Lama',
        'content': 'Belum selesai',
        'category': 'Tugas',
        'created_at': '2026-11-02 11:00',
      });

      final rowsAffected = await db.update(
        'notes',
        {'title': 'Tugas Baru Selesai', 'content': 'Sudah selesai'},
        where: 'id = ?',
        whereArgs: [id],
      );
      expect(rowsAffected, 1);

      final updated = await db.query('notes', where: 'id = ?', whereArgs: [id]);
      expect(updated.first['title'], 'Tugas Baru Selesai');
    });

    test('SQFlite: DELETE data catatan', () async {
      final id = await db.insert('notes', {
        'title': 'Mau Dihapus',
        'content': 'Akan dihapus',
        'category': 'Pribadi',
        'created_at': '2026-11-02 11:00',
      });

      final rowsDeleted = await db.delete('notes', where: 'id = ?', whereArgs: [id]);
      expect(rowsDeleted, 1);

      final result = await db.query('notes');
      expect(result.isEmpty, true);
    });
  });

  group('3. Pengujian CRUD Hive (Storage Alternatif)', () {
    late Directory tempDir;
    late Box box;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test');
      Hive.init(tempDir.path);
      box = await Hive.openBox('test_notes_box');
    });

    tearDown(() async {
      await box.close();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('Hive: CREATE & READ data', () async {
      final key = await box.add({
        'title': 'Catatan Hive',
        'content': 'NoSQL Box Storage sangat cepat',
        'category': 'Kuliah',
        'created_at': '2026-11-02 11:30',
      });

      expect(key, isNotNull);
      final data = box.get(key) as Map;
      expect(data['title'], 'Catatan Hive');
      expect(box.length, 1);
    });

    test('Hive: UPDATE data', () async {
      final key = await box.add({
        'title': 'Draf Awal',
        'content': 'Masih kasar',
        'category': 'Proyek',
      });

      await box.put(key, {
        'title': 'Draf Final',
        'content': 'Sudah diperbaiki',
        'category': 'Proyek',
      });

      final updated = box.get(key) as Map;
      expect(updated['title'], 'Draf Final');
    });

    test('Hive: DELETE data', () async {
      final key = await box.add({
        'title': 'Segera Dihapus',
        'content': 'Testing',
        'category': 'Pribadi',
      });

      expect(box.containsKey(key), true);
      await box.delete(key);
      expect(box.containsKey(key), false);
      expect(box.length, 0);
    });
  });
}
