import 'package:ai_summarizer_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders all core UI elements in default Turkish localization',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AiSummarizerApp());

    // Verify AppBar & Title (Default Turkish)
    expect(find.text('Yapay Zeka Özetleyici'), findsOneWidget);

    // Verify Language Flag Button
    expect(find.text('TR'), findsOneWidget);

    // Verify Localized Mode Chips
    expect(find.text('Yönetici'), findsOneWidget);
    expect(find.text('Akademik'), findsOneWidget);
    expect(find.text('Maddeler Halinde'), findsOneWidget);

    // Verify Input TextField and Initial State
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('0 kelime | 0 karakter'), findsOneWidget);
    expect(find.text('Tara'), findsOneWidget);
    expect(find.text('Yapıştır'), findsOneWidget);

    // Verify Action Button
    expect(find.text('Özetle (Yönetici)'), findsOneWidget);

    // Verify Empty State Result Card
    expect(find.text('Yapay zeka tarafından üretilen özetiniz burada görünecek.'),
        findsOneWidget);
  });
}
