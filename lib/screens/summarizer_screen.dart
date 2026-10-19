import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/summary_mode.dart';
import '../services/groq_summarizer_service.dart';
import '../widgets/mode_selector_bar.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  final TextEditingController _textController = TextEditingController();
  final GroqSummarizerService _summarizerService = GroqSummarizerService();

  SummaryMode _selectedMode = SummaryMode.executive;
  bool _isLoading = false;
  String _summary = '';
  SummaryMode? _lastSummarizedMode;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  int get _wordCount {
    final text = _textController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  int get _charCount => _textController.text.length;

  Future<void> _summarizeText() async {
    final inputText = _textController.text.trim();

    if (inputText.isEmpty) {
      _showMessage('Please enter or paste text to summarize.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _summary = '';
      _lastSummarizedMode = null;
    });

    try {
      final summary = await _summarizerService.summarizeText(
        text: inputText,
        mode: _selectedMode,
      );

      if (!mounted) return;

      setState(() {
        _summary = summary;
        _lastSummarizedMode = _selectedMode;
      });
    } catch (error) {
      if (!mounted) return;
      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearInput() {
    _textController.clear();
    setState(() {
      _summary = '';
      _lastSummarizedMode = null;
    });
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _textController.text = data.text!;
      _showMessage('Text pasted from clipboard.');
    }
  }

  void _copySummary() {
    if (_summary.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _summary));
    _showMessage('Summary copied to clipboard!');
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF0284C7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF38BDF8),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'AI Summarizer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'High-speed intelligent summarization powered by Groq & Llama 3.3',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.70),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ModeSelectorBar(
                      selectedMode: _selectedMode,
                      onModeChanged: (mode) {
                        setState(() => _selectedMode = mode);
                      },
                    ),
                    const SizedBox(height: 20),
                    _InputCard(
                      controller: _textController,
                      wordCount: _wordCount,
                      charCount: _charCount,
                      onClear: _clearInput,
                      onPaste: _pasteFromClipboard,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _summarizeText,
                        icon: _isLoading
                            ? const SizedBox.shrink()
                            : const Icon(Icons.bolt_rounded, size: 22),
                        label: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Summarize (${_selectedMode.label})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          foregroundColor: const Color(0xFF082F49),
                          disabledBackgroundColor: const Color(0xFF334155),
                          disabledForegroundColor: Colors.white70,
                          elevation: 6,
                          shadowColor: const Color(0x6638BDF8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    _SummaryCard(
                      summary: _summary,
                      mode: _lastSummarizedMode,
                      onCopy: _copySummary,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  const _InputCard({
    required this.controller,
    required this.wordCount,
    required this.charCount,
    required this.onClear,
    required this.onPaste,
  });

  final TextEditingController controller;
  final int wordCount;
  final int charCount;
  final VoidCallback onClear;
  final VoidCallback onPaste;

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            minLines: 8,
            maxLines: 14,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.45),
            cursorColor: const Color(0xFF38BDF8),
            decoration: InputDecoration(
              hintText: 'Paste long text, articles, or lecture notes here...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.40)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
          const Divider(height: 1, color: Color(0xFF334155)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Text(
                  '$wordCount words | $charCount chars',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (!hasText)
                  TextButton.icon(
                    onPressed: onPaste,
                    icon: const Icon(Icons.paste_rounded, size: 16),
                    label: const Text('Paste'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF38BDF8),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                if (hasText)
                  IconButton(
                    tooltip: 'Clear input',
                    onPressed: onClear,
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    color: Colors.white54,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.summary,
    required this.mode,
    required this.onCopy,
  });

  final String summary;
  final SummaryMode? mode;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final hasSummary = summary.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasSummary ? const Color(0xFF38BDF8) : const Color(0xFF334155),
          width: hasSummary ? 1.5 : 1.0,
        ),
        boxShadow: hasSummary
            ? [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasSummary ? (mode?.icon ?? Icons.auto_awesome) : Icons.auto_awesome,
                color: hasSummary ? const Color(0xFF38BDF8) : Colors.white38,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                hasSummary && mode != null
                    ? '${mode!.label} Summary'
                    : 'Summary',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (hasSummary)
                TextButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF38BDF8),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            hasSummary
                ? summary
                : 'Your synthesized AI summary will appear here.',
            style: TextStyle(
              color: hasSummary ? Colors.white : Colors.white38,
              fontSize: 15,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
