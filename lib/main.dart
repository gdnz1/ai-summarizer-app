import 'package:flutter/material.dart';

import 'screens/summarizer_screen.dart';

void main() {
  runApp(const AiSummarizerApp());
}

class AiSummarizerApp extends StatelessWidget {
  const AiSummarizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Text Summarizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          brightness: Brightness.dark,
        ),
      ),
      home: const SummarizerScreen(),
    );
  }
}
