import 'package:flutter/material.dart';
import 'database/hive_helper.dart';
import 'screens/sqflite_notes_screen.dart';
import 'screens/hive_notes_screen.dart';
import 'screens/summary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive Box untuk storage alternatif
  await HiveHelper.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Storage Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Eksplorasi Local Storage Flutter',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'SQFlite (Relasional) vs Hive (NoSQL)',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          bottom: const TabBar(
            indicatorWeight: 3,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(Icons.storage),
                text: '1-3. SQFlite',
              ),
              Tab(
                icon: Icon(Icons.inventory_2),
                text: '4. Hive NoSQL',
              ),
              Tab(
                icon: Icon(Icons.description),
                text: '5. Ringkasan & Dok',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SqfliteNotesScreen(),
            HiveNotesScreen(),
            SummaryScreen(),
          ],
        ),
      ),
    );
  }
}
