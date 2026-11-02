import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              color: Colors.blueGrey.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: Colors.amberAccent, size: 28),
                        SizedBox(width: 10),
                        Text(
                          'Ringkasan & Evaluasi Komparatif',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Perbandingan mendalam antara SQFlite (SQLite Relasional) dan Hive (NoSQL Key-Value Box) untuk Local Storage di Flutter.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section 1: Tabel Perbandingan
            const Text(
              '1. Matriks Perbandingan Fitur',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                  columns: const [
                    DataColumn(label: Text('Parameter', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('SQFlite (SQLite)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                    DataColumn(label: Text('Hive (NoSQL)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber))),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('Paradigma Data')),
                      DataCell(Text('Relasional (Tabel, Kolom, Baris)')),
                      DataCell(Text('NoSQL (Key-Value / Box)')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Query Language')),
                      DataCell(Text('SQL (SELECT, WHERE, JOIN)')),
                      DataCell(Text('Key lookup / Direct Dart Object')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Bahasa Core Engine')),
                      DataCell(Text('C (Native SQLite via C-Bindings)')),
                      DataCell(Text('Pure Dart (100% tanpa C-Native)')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Performa Read/Write')),
                      DataCell(Text('Cepat (tergantung I/O disk SQL)')),
                      DataCell(Text('Sangat Cepat (In-Memory Box Cache)')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Hubungan Antar Data')),
                      DataCell(Text('Sangat Kuat (Foreign Key, JOIN)')),
                      DataCell(Text('Manual (Perlu relasi via ID/Key)')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Migrasi Skema')),
                      DataCell(Text('Perlu onUpgrade SQL Script')),
                      DataCell(Text('Lebih fleksibel (Hive TypeAdapter)')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Platform Support')),
                      DataCell(Text('Android, iOS, macOS, Windows (FFI)')),
                      DataCell(Text('Semua Platform (termasuk Web & Desktop)')),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section 2: Analisis Kelebihan & Kekurangan
            const Text(
              '2. Analisis Kelebihan & Kekurangan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SQFlite Card
                Expanded(
                  child: Card(
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.storage, color: Colors.blueAccent),
                              SizedBox(width: 6),
                              Text('SQFlite (SQLite)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          Divider(),
                          Text('Kelebihan:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          Text('• Mendukung query kompleks (JOIN, GROUP BY, agregasi).'),
                          Text('• Standar industri database relasional (ACID compliant).'),
                          Text('• Sangat stabil untuk relasi data terstruktur yang rumit.'),
                          SizedBox(height: 8),
                          Text('Kekurangan:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          Text('• Butuh boilerplate penulisan SQL dan mapping toMap/fromMap manual.'),
                          Text('• Kurang fleksibel jika struktur data sering berubah-ubah.'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Hive Card
                Expanded(
                  child: Card(
                    color: Colors.amber.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.inventory_2, color: Colors.amber),
                              SizedBox(width: 6),
                              Text('Hive (NoSQL)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          Divider(),
                          Text('Kelebihan:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          Text('• Sangat cepat karena implementasi pure Dart dan in-memory caching.'),
                          Text('• Setup sangat mudah tanpa SQL syntax.'),
                          Text('• Dukungan enkripsi bawaan (AES-256).'),
                          SizedBox(height: 8),
                          Text('Kekurangan:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          Text('• Tidak mendukung filter/query relasional kompleks (JOIN).'),
                          Text('• Seluruh data box dibaca ke memory, waspada jika dataset raksasa.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 3: Rekomendasi Penggunaan
            const Text(
              '3. Rekomendasi Kasus Penggunaan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                      title: Text('Kapan Menggunakan SQFlite?'),
                      subtitle: Text(
                        'Pilih SQFlite jika aplikasi Anda memiliki data dengan relasi relasional yang ketat (seperti sistem kasir / POS, data akademik dengan relasi Mahasiswa-Dosen-MataKuliah), membutuhkan transaksi ACID, dan pencarian berbasis SQL yang kompleks.',
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.flash_on, color: Colors.white),
                      ),
                      title: Text('Kapan Menggunakan Hive?'),
                      subtitle: Text(
                        'Pilih Hive jika Anda butuh kecepatan baca/tulis super cepat, kemudahan koding tanpa SQL, penyimpanan token autentikasi, offline cache API, data settings/preferensi, atau aplikasi catatan/todo sederhana tanpa relasi data rumit.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
