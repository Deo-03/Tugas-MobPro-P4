import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../database/sqflite_helper.dart';

class SqfliteNotesScreen extends StatefulWidget {
  const SqfliteNotesScreen({super.key});

  @override
  State<SqfliteNotesScreen> createState() => _SqfliteNotesScreenState();
}

class _SqfliteNotesScreenState extends State<SqfliteNotesScreen> {
  final SqfliteHelper _dbHelper = SqfliteHelper.instance;
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // READ: Mengambil seluruh data catatan dari SQFlite
  Future<void> _fetchNotes() async {
    setState(() => _isLoading = true);
    final notes = await _dbHelper.getAllNotes();
    if (!mounted) return;
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  // CREATE / UPDATE Dialog
  void _showNoteDialog({Note? existingNote}) {
    final titleController = TextEditingController(text: existingNote?.title ?? '');
    final contentController = TextEditingController(text: existingNote?.content ?? '');
    String selectedCategory = existingNote?.category ?? 'Kuliah';
    final categories = ['Kuliah', 'Tugas', 'Pribadi', 'Proyek'];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isEdit = existingNote != null;
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    isEdit ? Icons.edit_note : Icons.note_add,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 8),
                  Text(isEdit ? 'Ubah Catatan (SQLite)' : 'Tambah Catatan (SQLite)'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Catatan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Isi Catatan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedCategory = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final content = contentController.text.trim();

                    if (title.isEmpty || content.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Judul dan isi tidak boleh kosong!')),
                      );
                      return;
                    }

                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(dialogContext);

                    if (isEdit) {
                      // UPDATE
                      final updatedNote = existingNote.copyWith(
                        title: title,
                        content: content,
                        category: selectedCategory,
                      );
                      await _dbHelper.updateNote(updatedNote);
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Catatan berhasil diperbarui di SQLite!')),
                      );
                    } else {
                      // CREATE
                      final newNote = Note(
                        title: title,
                        content: content,
                        category: selectedCategory,
                        createdAt: DateTime.now().toString().substring(0, 16),
                      );
                      await _dbHelper.createNote(newNote);
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Catatan berhasil disimpan ke SQLite!')),
                      );
                    }

                    navigator.pop();
                    _fetchNotes();
                  },
                  child: Text(isEdit ? 'Perbarui' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // DELETE: Menghapus catatan
  Future<void> _deleteNote(int id) async {
    final messenger = ScaffoldMessenger.of(context);
    await _dbHelper.deleteNote(id);
    messenger.showSnackBar(
      const SnackBar(content: Text('Catatan berhasil dihapus dari SQLite!')),
    );
    _fetchNotes();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Kuliah':
        return Colors.indigo;
      case 'Tugas':
        return Colors.deepOrange;
      case 'Pribadi':
        return Colors.teal;
      case 'Proyek':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storage, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      'Tabel: notes | Database: SQLite',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
                Chip(
                  backgroundColor: Colors.blue.shade100,
                  label: Text(
                    '${_notes.length} Catatan',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'Belum ada catatan di SQLite.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => _showNoteDialog(),
                              icon: const Icon(Icons.add),
                              label: const Text('Buat Catatan Pertama'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _fetchNotes,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            final categoryColor = _getCategoryColor(note.category);

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: categoryColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: categoryColor),
                                      ),
                                      child: Text(
                                        note.category,
                                        style: TextStyle(
                                          color: categoryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      note.content,
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'ID: ${note.id} • ${note.createdAt}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                      tooltip: 'Ubah (Update)',
                                      onPressed: () => _showNoteDialog(existingNote: note),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                      tooltip: 'Hapus (Delete)',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (dialogCtx) => AlertDialog(
                                            title: const Text('Konfirmasi Hapus'),
                                            content: Text(
                                              'Yakin ingin menghapus catatan "${note.title}"?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(dialogCtx),
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(dialogCtx);
                                                  if (note.id != null) {
                                                    _deleteNote(note.id!);
                                                  }
                                                },
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteDialog(),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Catatan'),
      ),
    );
  }
}
