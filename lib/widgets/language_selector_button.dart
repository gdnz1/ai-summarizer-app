import 'package:flutter/material.dart';

import '../models/app_language.dart';

/// Interactive button in the AppBar allowing quick toggling between Turkish and English.
class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  final AppLanguage selectedLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppLanguage>(
      initialValue: selectedLanguage,
      tooltip: selectedLanguage == AppLanguage.tr ? 'Dili Değiştir' : 'Change Language',
      onSelected: onLanguageChanged,
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedLanguage.flag,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Text(
              selectedLanguage.code.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Color(0xFF38BDF8),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppLanguage.tr,
          child: Row(
            children: [
              const Text('🇹🇷', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              const Text(
                'Türkçe (TR)',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (selectedLanguage == AppLanguage.tr)
                const Icon(Icons.check_rounded, color: Color(0xFF38BDF8), size: 18),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppLanguage.en,
          child: Row(
            children: [
              const Text('🇬🇧', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              const Text(
                'English (EN)',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (selectedLanguage == AppLanguage.en)
                const Icon(Icons.check_rounded, color: Color(0xFF38BDF8), size: 18),
            ],
          ),
        ),
      ],
    );
  }
}
