import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tumbang/widgets/app_date_picker.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('AppDatePickerDialog steps navigation (Year -> Month -> Day)', (WidgetTester tester) async {
    DateTime? selectedDate;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  selectedDate = await showAppDatePicker(
                    context: context,
                    initialDate: DateTime(2023, 5, 10),
                    firstDate: DateTime(2000, 1, 1),
                    lastDate: DateTime(2030, 12, 31),
                    initialDatePickerMode: DatePickerMode.year,
                  );
                },
                child: const Text('Open Picker'),
              );
            },
          ),
        ),
      ),
    );

    // Open DatePicker Dialog
    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    // Step 1: Year selection should be visible
    expect(find.text('Langkah 1 dari 3: Pilih Tahun Lahir / Periksa'), findsOneWidget);
    expect(find.text('2021'), findsOneWidget);

    // Tap Year 2021
    await tester.tap(find.text('2021'));
    await tester.pumpAndSettle();

    // Step 2: Auto advanced to Month selection
    expect(find.text('Langkah 2 dari 3: Pilih Bulan (2021)'), findsOneWidget);
    expect(find.text('Agustus'), findsOneWidget);

    // Tap Month Agustus
    await tester.tap(find.text('Agustus'));
    await tester.pumpAndSettle();

    // Step 3: Auto advanced to Day selection
    expect(find.text('Langkah 3 dari 3: Pilih Tanggal (Agustus 2021)'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);

    // Tap Day 15
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    // Tap Submit "Pilih"
    await tester.tap(find.text('Pilih'));
    await tester.pumpAndSettle();

    expect(selectedDate, equals(DateTime(2021, 8, 15)));
  });
}
