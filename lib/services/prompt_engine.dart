import '../models/app_language.dart';
import '../models/summary_mode.dart';

/// Service responsible for constructing optimized LLM prompts based on
/// the selected summarization mode, system persona, and target output language.
class PromptEngine {
  /// Builds the messages payload for Groq / OpenAI Chat Completions API.
  static List<Map<String, String>> buildMessages({
    required String text,
    required SummaryMode mode,
    required AppLanguage language,
  }) {
    return [
      {
        'role': 'system',
        'content': _getSystemPrompt(mode, language),
      },
      {
        'role': 'user',
        'content': text,
      },
    ];
  }

  /// Returns a tailored system prompt enforcing persona, length, and strict target language.
  static String _getSystemPrompt(SummaryMode mode, AppLanguage language) {
    final languageDirective = language.promptDirective;

    final baseRules =
        'CRITICAL INSTRUCTIONS:\n'
        '1. $languageDirective\n'
        '2. Base your summary strictly on the provided content. Never hallucinate, invent facts, or extrapolate beyond the text.\n'
        '3. Do not add conversational fluff (e.g., "Here is your summary:", "İşte özet:"). Start directly with the synthesized content.\n'
        '4. Even if the input text is in a different language, translate and synthesize the key information directly into the target language.';

    switch (mode) {
      case SummaryMode.executive:
        return 'You are an executive briefing analyst. '
            'Your goal is to provide a high-impact, punchy summary in 2 to 3 concise sentences. '
            'Focus purely on the core message, bottom line, and primary outcomes.\n\n$baseRules';

      case SummaryMode.academic:
        return 'You are an academic research scholar. '
            'Your goal is to provide a structured, in-depth academic summary preserving technical accuracy, '
            'context, hypotheses, arguments, and conclusions. Maintain an objective, scholarly tone. '
            'Use clean Markdown formatting with subheadings (###) and bold emphasis where appropriate.\n\n$baseRules';

      case SummaryMode.keyTakeaways:
        return 'You are a strategic synthesis expert. '
            'Your goal is to extract the most critical insights into 4 to 6 clean, structured bullet points. '
            'Format each point as a Markdown list item starting with "- ", '
            'followed by a bolded concept title, an en-dash or colon, and a concise explanation. '
            'Always separate each bullet item with an empty blank line for optimal readability.\n\n'
            'Example:\n'
            '- **Core Concept** – Explanation of this critical aspect.\n\n'
            '- **Key Factor** – Explanation of the secondary element.\n\n$baseRules';
    }
  }
}
