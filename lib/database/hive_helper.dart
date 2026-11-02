import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';

class HiveHelper {
  static final HiveHelper instance = HiveHelper._init();
  static const String boxName = 'notes_hive_box';

  HiveHelper._init();

  // Inisialisasi Hive
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  // Mendapatkan referensi Box
  Box get _box => Hive.box(boxName);

  // 1. CREATE: Menambahkan catatan baru ke Box
  Future<Note> createNote(Note note) async {
    // box.add mengembalikan key integer auto-increment
    final int generatedKey = await _box.add({
      'title': note.title,
      'content': note.content,
      'category': note.category,
      'created_at': note.createdAt,
    });

    return note.copyWith(id: generatedKey);
  }

  // 2. READ: Mengambil semua catatan dari Box
  List<Note> getAllNotes() {
    final List<Note> notes = [];

    for (var key in _box.keys) {
      final rawData = _box.get(key);
      if (rawData != null && rawData is Map) {
        notes.add(Note(
          id: key is int ? key : int.tryParse(key.toString()),
          title: rawData['title'] as String? ?? '',
          content: rawData['content'] as String? ?? '',
          category: rawData['category'] as String? ?? 'General',
          createdAt: rawData['created_at'] as String? ?? '',
        ));
      }
    }

    // Urutkan dari yang terbaru (ID / Key terbesar lebih dulu)
    notes.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    return notes;
  }

  // 3. UPDATE: Memperbarui catatan berdasarkan Key
  Future<void> updateNote(int key, Note note) async {
    await _box.put(key, {
      'title': note.title,
      'content': note.content,
      'category': note.category,
      'created_at': note.createdAt,
    });
  }

  // 4. DELETE: Menghapus catatan berdasarkan Key
  Future<void> deleteNote(int key) async {
    await _box.delete(key);
  }

  // DELETE ALL: Menghapus seluruh data catatan di Hive
  Future<void> deleteAllNotes() async {
    await _box.clear();
  }
}
