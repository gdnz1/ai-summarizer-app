import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/summary_mode.dart';

/// Interactive selector bar allowing users to switch between summarization personas.
class ModeSelectorBar extends StatelessWidget {
  const ModeSelectorBar({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    required this.strings,
  });

  final SummaryMode selectedMode;
  final ValueChanged<SummaryMode> onModeChanged;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: SummaryMode.values.map((mode) {
            final isSelected = mode == selectedMode;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => onModeChanged(mode),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF38BDF8).withValues(alpha: 0.15)
                          : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF38BDF8)
                            : const Color(0xFF334155),
                        width: isSelected ? 1.8 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          mode.icon,
                          size: 19,
                          color: isSelected
                              ? const Color(0xFF38BDF8)
                              : Colors.white70,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          strings.modeLabel(mode),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            strings.modeDescription(selectedMode),
            key: ValueKey('${selectedMode}_${strings.language}'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF38BDF8).withValues(alpha: 0.85),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
