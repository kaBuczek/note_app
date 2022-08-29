import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:integration_test/integration_test.dart';

import 'package:note_app/main.dart' as app;
import 'package:note_app/note_block.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add new note', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    final Finder addNewNoteBtn = find.byTooltip('AddNote');

    await tester.tap(addNewNoteBtn);

    await tester.pumpAndSettle();

    final Finder titleTextField = find.byType(TextFormField).first;
    final Finder contentTextField = find.byType(TextFormField).last;
    final Finder confirmBtn = find.byType(ElevatedButton).first;

    await tester.enterText(titleTextField, 'Test Title');
    await tester.enterText(contentTextField, 'TestField');

    await tester.pumpAndSettle();

    await tester.tap(confirmBtn);

    await tester.pumpAndSettle();

    expect(find.text('Test Title'), findsOneWidget);
  });
}
