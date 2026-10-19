import 'package:ai_summarizer_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders all core UI elements and summary modes', (WidgetTester tester) async {
    await tester.pumpWidget(const AiSummarizerApp());

    // Verify AppBar & Title
    expect(find.text('AI Summarizer'), findsOneWidget);

    // Verify Summary Mode Chips
    expect(find.text('Executive'), findsOneWidget);
    expect(find.text('Academic'), findsOneWidget);
    expect(find.text('Key Takeaways'), findsOneWidget);

    // Verify Input TextField and Initial State
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('0 words | 0 chars'), findsOneWidget);
    expect(find.text('Paste'), findsOneWidget);

    // Verify Action Button
    expect(find.text('Summarize (Executive)'), findsOneWidget);

    // Verify Empty State Result Card
    expect(find.text('Your synthesized AI summary will appear here.'), findsOneWidget);
  });
}
