import 'package:flutter/material.dart';

/// Defines the different summarization personas and styles available in the application.
enum SummaryMode {
  /// Fast, punchy summary highlighting only the bottom line.
  executive,

  /// In-depth, formal, academic tone retaining technical accuracy.
  academic,

  /// Structured bullet points extracting key takeaways.
  keyTakeaways,
}

/// Extension providing UI metadata and prompt parameters for each [SummaryMode].
extension SummaryModeX on SummaryMode {
  String get label {
    switch (this) {
      case SummaryMode.executive:
        return 'Executive';
      case SummaryMode.academic:
        return 'Academic';
      case SummaryMode.keyTakeaways:
        return 'Key Takeaways';
    }
  }

  String get description {
    switch (this) {
      case SummaryMode.executive:
        return 'Concise, high-level summary focused on core impact.';
      case SummaryMode.academic:
        return 'Formal, comprehensive summary preserving nuance and methodology.';
      case SummaryMode.keyTakeaways:
        return 'Bullet-point breakdown of essential insights and conclusions.';
    }
  }

  IconData get icon {
    switch (this) {
      case SummaryMode.executive:
        return Icons.flash_on_rounded;
      case SummaryMode.academic:
        return Icons.school_rounded;
      case SummaryMode.keyTakeaways:
        return Icons.format_list_bulleted_rounded;
    }
  }

  /// Recommended sampling temperature for this mode.
  /// Lower values yield more deterministic, factual summaries.
  double get temperature {
    switch (this) {
      case SummaryMode.executive:
        return 0.2;
      case SummaryMode.academic:
        return 0.3;
      case SummaryMode.keyTakeaways:
        return 0.25;
    }
  }
}
