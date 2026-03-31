import 'package:flutter/material.dart';
import '../../core/services/smart_suggestion_service.dart';
import '../../domain/entities/scan_result.dart';

class SmartSuggestionsCard extends StatelessWidget {
  final ScanResult result;

  const SmartSuggestionsCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final suggestions = SmartSuggestionService.analyze(result);

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Row(children: [
          Icon(Icons.lightbulb_outline_rounded, color: cs.primary, size: 18),
          const SizedBox(width: 8),
          Text('Smart Suggestions',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ]),
      ),
      SizedBox(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: suggestions.length,
          itemBuilder: (_, i) => _SuggestionCard(suggestion: suggestions[i]),
        ),
      ),
    ]);
  }
}

class _SuggestionCard extends StatelessWidget {
  final SmartSuggestion suggestion;
  const _SuggestionCard({required this.suggestion});

  Color _color(ColorScheme cs) {
    switch (suggestion.priority) {
      case SuggestionPriority.high: return cs.error;
      case SuggestionPriority.medium: return cs.primary;
      case SuggestionPriority.low: return cs.secondary;
      case SuggestionPriority.info: return cs.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = _color(cs);

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(suggestion.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(child: Text(suggestion.title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
            overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 8),
        Expanded(child: Text(suggestion.body,
          style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurface, height: 1.4),
          overflow: TextOverflow.fade)),
      ]),
    );
  }
}
