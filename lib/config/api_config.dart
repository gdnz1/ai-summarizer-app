/// Global API configuration for Groq Cloud LLM engine.
///
/// Supports runtime injection via `--dart-define=GROQ_API_KEY=your_key`
/// or by replacing the fallback constant during development.
class ApiConfig {
  /// Groq Cloud API Key.
  /// Get your free API key at: https://console.groq.com/keys
  static const String groqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: 'YOUR_GROQ_API_KEY_HERE',
  );

  /// Groq Chat Completions endpoint (100% OpenAI spec compatible).
  static const String groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  /// Primary high-reasoning model: Meta Llama 3.3 70B Versatile
  static const String primaryModel = 'llama-3.3-70b-versatile';

  /// High-speed fallback model: Meta Llama 3.1 8B Instant
  static const String fastModel = 'llama-3.1-8b-instant';

  /// Active default model
  static const String model = primaryModel;

  /// Helper to check if a valid Groq API key is present
  static bool get isConfigured {
    return groqApiKey.isNotEmpty &&
        groqApiKey != 'YOUR_GROQ_API_KEY_HERE' &&
        groqApiKey.startsWith('gsk_');
  }
}
