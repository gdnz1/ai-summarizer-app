import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_strings.dart';
import '../models/app_language.dart';
import '../models/summary_mode.dart';
import '../services/groq_summarizer_service.dart';
import '../services/ocr_service.dart';
import '../widgets/language_selector_button.dart';
import '../widgets/mode_selector_bar.dart';
import '../widgets/ocr_source_sheet.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  final TextEditingController _textController = TextEditingController();
  final GroqSummarizerService _summarizerService = GroqSummarizerService();
  final OcrService _ocrService = OcrService();

  AppLanguage _selectedLanguage = AppLanguage.tr;
  SummaryMode _selectedMode = SummaryMode.executive;
  bool _isLoading = false;
  bool _isScanning = false;
  String _summary = '';
  SummaryMode? _lastSummarizedMode;

  AppStrings get _strings => AppStrings.of(_selectedLanguage);

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
      _showMessage(_strings.emptyInputError, isError: true);
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
        language: _selectedLanguage,
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

  Future<void> _handleOcrScan() async {
    if (kIsWeb) {
      _showMessage(_strings.webOcrNotice);
      return;
    }

    final source = await OcrSourceSheet.show(context, _strings);
    if (source == null) return;

    setState(() => _isScanning = true);

    try {
      final extractedText = source == ImageSource.camera
          ? await _ocrService.extractTextFromCamera()
          : await _ocrService.extractTextFromGallery();

      if (!mounted) return;

      if (extractedText != null && extractedText.isNotEmpty) {
        _textController.text = extractedText;
        final count = extractedText.split(RegExp(r'\s+')).length;
        _showMessage(_strings.scannedSuccess(count));
      }
    } catch (error) {
      if (!mounted) return;
      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
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
      _showMessage(_strings.clipboardPasted);
    }
  }

  void _copySummary() {
    if (_summary.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _summary));
    _showMessage(_strings.summaryCopied);
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
        centerTitle: false,
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
            Text(
              _strings.appTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          LanguageSelectorButton(
            selectedLanguage: _selectedLanguage,
            onLanguageChanged: (lang) {
              setState(() => _selectedLanguage = lang);
            },
          ),
        ],
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
                      _strings.appSubtitle,
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
                      strings: _strings,
                      onModeChanged: (mode) {
                        setState(() => _selectedMode = mode);
                      },
                    ),
                    const SizedBox(height: 20),
                    if (_isScanning)
                      Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF38BDF8)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _strings.scanningBanner,
                                style: const TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    _InputCard(
                      controller: _textController,
                      wordCount: _wordCount,
                      charCount: _charCount,
                      strings: _strings,
                      onClear: _clearInput,
                      onPaste: _pasteFromClipboard,
                      onScan: _handleOcrScan,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading || _isScanning ? null : _summarizeText,
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
                                _strings.summarizeButton(_selectedMode),
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
                      strings: _strings,
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
    required this.strings,
    required this.onClear,
    required this.onPaste,
    required this.onScan,
  });

  final TextEditingController controller;
  final int wordCount;
  final int charCount;
  final AppStrings strings;
  final VoidCallback onClear;
  final VoidCallback onPaste;
  final VoidCallback onScan;

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
              hintText: strings.inputHint,
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
                  strings.stats(wordCount, charCount),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onScan,
                  icon: const Icon(Icons.document_scanner_rounded, size: 16),
                  label: Text(strings.scanAction),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF38BDF8),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                if (!hasText) ...[
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: onPaste,
                    icon: const Icon(Icons.paste_rounded, size: 16),
                    label: Text(strings.pasteAction),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF38BDF8),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
                if (hasText)
                  IconButton(
                    tooltip: strings.clearTooltip,
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
    required this.strings,
    required this.onCopy,
  });

  final String summary;
  final SummaryMode? mode;
  final AppStrings strings;
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
                strings.summaryTitle(mode),
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
                  label: Text(strings.copyAction),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF38BDF8),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            hasSummary ? summary : strings.summaryPlaceholder,
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
