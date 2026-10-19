import 'package:ai_summarizer_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows summarizer home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AiSummarizerApp());

    expect(find.text('AI Text Summarizer'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Summarize'), findsOneWidget);
    expect(find.text('Your summary will appear here.'), findsOneWidget);
  });
}
