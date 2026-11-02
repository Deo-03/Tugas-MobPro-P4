import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_storage_crud/screens/summary_screen.dart';

void main() {
  testWidgets('Widget Test: SummaryScreen berhasil dirender', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SummaryScreen(),
      ),
    );

    expect(find.text('Ringkasan & Evaluasi Komparatif'), findsOneWidget);
    expect(find.text('1. Matriks Perbandingan Fitur'), findsOneWidget);
    expect(find.text('2. Analisis Kelebihan & Kekurangan'), findsOneWidget);
    expect(find.text('3. Rekomendasi Kasus Penggunaan'), findsOneWidget);
  });
}
