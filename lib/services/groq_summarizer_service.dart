import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/summary_mode.dart';
import 'prompt_engine.dart';

/// Service responsible for executing inference requests against Groq Cloud API.
class GroqSummarizerService {
  final http.Client _client;

  GroqSummarizerService({http.Client? client}) : _client = client ?? http.Client();

  /// Summarizes the provided [text] according to the selected [mode].
  Future<String> summarizeText({
    required String text,
    SummaryMode mode = SummaryMode.executive,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const FormatException('Input text cannot be empty.');
    }

    if (!ApiConfig.isConfigured) {
      throw Exception(
        'Groq API key is missing or invalid. '
        'Please set your API key in lib/config/api_config.dart or pass via --dart-define=GROQ_API_KEY=gsk_...',
      );
    }

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${ApiConfig.groqApiKey}',
    };

    final body = jsonEncode({
      'model': ApiConfig.model,
      'messages': PromptEngine.buildMessages(text: trimmed, mode: mode),
      'temperature': mode.temperature,
      'max_tokens': 2048,
      'stream': false,
    });

    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.groqApiUrl),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw _handleHttpError(response.statusCode, response.body);
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;

      if (choices == null || choices.isEmpty) {
        throw Exception('The AI model returned no completion choices.');
      }

      final firstChoice = choices.first as Map<String, dynamic>;
      final message = firstChoice['message'] as Map<String, dynamic>?;
      final content = message?['content']?.toString().trim();

      if (content == null || content.isEmpty) {
        throw Exception('The AI summary response was empty.');
      }

      return content;
    } on TimeoutException {
      throw Exception('Request timed out. Please check your internet connection.');
    } on SocketException {
      throw Exception('Network unreachable. Please check your internet connection.');
    } on FormatException catch (e) {
      throw Exception('Data format error: ${e.message}');
    }
  }

  /// Maps HTTP error codes into clear, user-friendly exceptions.
  Exception _handleHttpError(int statusCode, String responseBody) {
    String detail = 'Request failed with status code $statusCode.';

    try {
      final json = jsonDecode(responseBody) as Map<String, dynamic>;
      final error = json['error'] as Map<String, dynamic>?;
      final msg = error?['message']?.toString();
      if (msg != null && msg.isNotEmpty) {
        detail = msg;
      }
    } catch (_) {
      // Keep default message if response body is not JSON
    }

    switch (statusCode) {
      case 401:
        return Exception('Authentication failed (401): Invalid Groq API key.');
      case 429:
        return Exception('Rate limit exceeded (429): Groq API quota reached. Please wait a moment.');
      case 500:
      case 503:
        return Exception('Groq AI service is currently unavailable ($statusCode). Please try again later.');
      default:
        return Exception('API Error ($statusCode): $detail');
    }
  }
}
