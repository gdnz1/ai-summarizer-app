import 'package:ai_summarizer_app/models/summary_mode.dart';
import 'package:ai_summarizer_app/services/prompt_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PromptEngine & SummaryMode Tests', () {
    test('buildMessages generates valid chat completion structure', () {
      const sampleText = 'Quantum computing is a rapidly-emerging technology.';
      final messages = PromptEngine.buildMessages(
        text: sampleText,
        mode: SummaryMode.executive,
      );

      expect(messages.length, 2);
      expect(messages[0]['role'], 'system');
      expect(messages[0]['content'], contains('executive briefing analyst'));
      expect(messages[0]['content'], contains('CRITICAL INSTRUCTIONS'));

      expect(messages[1]['role'], 'user');
      expect(messages[1]['content'], sampleText);
    });

    test('Academic mode applies scholarly persona and constraints', () {
      final messages = PromptEngine.buildMessages(
        text: 'Some technical text',
        mode: SummaryMode.academic,
      );

      expect(messages[0]['content'], contains('academic research scholar'));
    });

    test('Key Takeaways mode requests structured bullet points', () {
      final messages = PromptEngine.buildMessages(
        text: 'Some article content',
        mode: SummaryMode.keyTakeaways,
      );

      expect(messages[0]['content'], contains('bullet points'));
    });

    test('SummaryMode temperature properties match stability expectations', () {
      expect(SummaryMode.executive.temperature, lessThanOrEqualTo(0.2));
      expect(SummaryMode.academic.temperature, lessThanOrEqualTo(0.3));
    });
  });
}
