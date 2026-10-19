/// Global API configuration for Groq Cloud LLM engine.
///
/// Supports runtime injection via `--dart-define=GROQ_API_KEY=your_key`
/// or by reading from a local `.env` file.
class ApiConfig {
  /// Groq Cloud API Key.
  /// Get your free API key at: https://console.groq.com/keys
  static const String groqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: 'YOUR_GROQ_API_KEY_HERE',
  );

  /// Groq Chat Completions endpoint (100% OpenAI spec compatible).
  static const String groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  /// Primary high-speed reasoning model: OpenAI GPT OSS 20B
  static const String fastModel = 'openai/gpt-oss-20b';

  /// High-capacity deep analysis model: OpenAI GPT OSS 120B
  static const String deepModel = 'openai/gpt-oss-120b';

  /// Active default model (can be overridden via --dart-define=GROQ_MODEL=...)
  static const String model = String.fromEnvironment(
    'GROQ_MODEL',
    defaultValue: fastModel,
  );

  /// Helper to check if a valid Groq API key is present
  static bool get isConfigured {
    return groqApiKey.isNotEmpty &&
        groqApiKey != 'YOUR_GROQ_API_KEY_HERE' &&
        groqApiKey.startsWith('gsk_');
  }
}
