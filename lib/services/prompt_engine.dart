import '../models/summary_mode.dart';

/// Service responsible for constructing optimized LLM prompts based on
/// the selected summarization mode, system persona, and language constraints.
class PromptEngine {
  /// Builds the messages payload for OpenAI/Groq Chat Completions API.
  static List<Map<String, String>> buildMessages({
    required String text,
    required SummaryMode mode,
  }) {
    return [
      {
        'role': 'system',
        'content': _getSystemPrompt(mode),
      },
      {
        'role': 'user',
        'content': text,
      },
    ];
  }

  /// Returns a tailored system prompt enforcing tone, length, and anti-hallucination constraints.
  static String _getSystemPrompt(SummaryMode mode) {
    final baseRules =
        'CRITICAL INSTRUCTIONS:\n'
        '1. Respond in the exact same language as the input text (e.g., Turkish for Turkish text, English for English text).\n'
        '2. Base your summary strictly on the provided content. Never hallucinate, invent data, or extrapolate beyond the source.\n'
        '3. Do not add introductory fluff like "Here is the summary:" or "In summary,". Start directly with the summarized content.';

    switch (mode) {
      case SummaryMode.executive:
        return 'You are an executive briefing analyst. '
            'Your goal is to provide a high-impact, punchy summary in 2 to 3 concise sentences. '
            'Focus purely on the core message, bottom line, and primary outcomes.\n\n$baseRules';

      case SummaryMode.academic:
        return 'You are an academic research scholar. '
            'Your goal is to provide a structured, in-depth academic summary preserving technical accuracy, '
            'context, hypotheses, arguments, and conclusions. Maintain an objective, scholarly tone.\n\n$baseRules';

      case SummaryMode.keyTakeaways:
        return 'You are a strategic synthesis expert. '
            'Your goal is to extract the most critical insights into 4 to 6 clean, structured bullet points. '
            'Start each bullet point with a bolded 2-3 word concept followed by a concise explanation.\n\n$baseRules';
    }
  }
}
