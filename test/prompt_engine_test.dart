import 'package:ai_summarizer_app/models/app_language.dart';
import 'package:ai_summarizer_app/models/summary_mode.dart';
import 'package:ai_summarizer_app/services/prompt_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PromptEngine & SummaryMode Tests', () {
    test('buildMessages generates valid chat completion structure in Turkish', () {
      const sampleText = 'Kuantum hesaplama hızla gelişen bir teknolojidir.';
      final messages = PromptEngine.buildMessages(
        text: sampleText,
        mode: SummaryMode.executive,
        language: AppLanguage.tr,
      );

      expect(messages.length, 2);
      expect(messages[0]['role'], 'system');
      expect(messages[0]['content'], contains('MANDATORY TARGET LANGUAGE: Turkish'));
      expect(messages[0]['content'], contains('executive briefing analyst'));

      expect(messages[1]['role'], 'user');
      expect(messages[1]['content'], sampleText);
    });

    test('buildMessages generates valid chat completion structure in English', () {
      const sampleText = 'Quantum computing is a rapidly-emerging technology.';
      final messages = PromptEngine.buildMessages(
        text: sampleText,
        mode: SummaryMode.academic,
        language: AppLanguage.en,
      );

      expect(messages[0]['content'], contains('MANDATORY TARGET LANGUAGE: English'));
      expect(messages[0]['content'], contains('academic research scholar'));
    });

    test('Key Takeaways mode requests structured bullet points', () {
      final messages = PromptEngine.buildMessages(
        text: 'Some article content',
        mode: SummaryMode.keyTakeaways,
        language: AppLanguage.tr,
      );

      expect(messages[0]['content'], contains('bullet points'));
    });

    test('SummaryMode temperature properties match stability expectations', () {
      expect(SummaryMode.executive.temperature, lessThanOrEqualTo(0.2));
      expect(SummaryMode.academic.temperature, lessThanOrEqualTo(0.3));
    });
  });
}
