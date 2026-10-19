import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class OpenAiService {
  Future<String> summarizeText(String text) async {
    if (ApiConfig.openAiApiKey == 'YOUR_OPENAI_API_KEY') {
      throw Exception(
        'Please add your OpenAI API key in lib/config/api_config.dart.',
      );
    }

    final response = await http.post(
      Uri.parse(ApiConfig.openAiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiConfig.openAiApiKey}',
      },
      body: jsonEncode({
        'model': ApiConfig.model,
        'messages': [
          {
            'role': 'system',
            'content': "Summarize the user's text in a short and clear way.",
          },
          {
            'role': 'user',
            'content': text,
          },
        ],
        'temperature': 0.3,
      }),
    );

    if (response.statusCode != 200) {
      String message = 'API request failed. Please try again.';

      try {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        final error = errorBody['error'] as Map<String, dynamic>?;
        message = error?['message']?.toString() ?? message;
      } catch (_) {
        // Keep the friendly fallback message if the error body is not JSON.
      }

      throw Exception(message);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;

    if (choices == null || choices.isEmpty) {
      throw Exception('No summary was returned by the API.');
    }

    final message = choices.first['message'] as Map<String, dynamic>?;
    final content = message?['content']?.toString().trim();

    if (content == null || content.isEmpty) {
      throw Exception('The summary response was empty.');
    }

    return content;
  }
}
