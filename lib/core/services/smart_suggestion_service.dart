import '../constants/app_constants.dart';
import '../../domain/entities/duplicate_group.dart';
import '../../domain/entities/duplicate_file.dart';
import '../../domain/entities/scan_result.dart';

/// Analyzes scan results and generates smart suggestions.
/// Works 100% offline — pure logic, no network needed.
class SmartSuggestionService {
  /// Generates a list of human-readable, actionable suggestions.
  static List<SmartSuggestion> analyze(ScanResult result) {
    final suggestions = <SmartSuggestion>[];

    if (result.groups.isEmpty) return suggestions;

    // 1. Largest waste group
    final sorted = List<DuplicateGroup>.from(result.groups)
      ..sort((a, b) => b.wastedSpace.compareTo(a.wastedSpace));
    final biggest = sorted.first;
    suggestions.add(SmartSuggestion(
      icon: '💾',
      title: 'Biggest space waster',
      body: 'The group "${biggest.files.first.name}" wastes ${_fmt(biggest.wastedSpace)}. '
            'Deleting duplicates here frees the most space.',
      priority: SuggestionPriority.high,
    ));

    // 2. WhatsApp / Telegram bloat
    final waChats = result.groups.where((g) =>
      g.files.any((f) => f.path.contains('WhatsApp') || f.path.contains('Telegram')));
    if (waChats.isNotEmpty) {
      final waste = waChats.fold(0, (s, g) => s + g.wastedSpace);
      suggestions.add(SmartSuggestion(
        icon: '📱',
        title: 'Messaging app duplicates',
        body: '${waChats.length} groups of files duplicated from WhatsApp/Telegram '
              'are wasting ${_fmt(waste)}. These are safe to remove.',
        priority: SuggestionPriority.high,
      ));
    }

    // 3. Similar image clusters (perceptual hash)
    final similar = result.groups.where((g) => g.duplicateType == DuplicateType.similar).length;
    if (similar > 0) {
      suggestions.add(SmartSuggestion(
        icon: '🖼️',
        title: 'Near-duplicate photos',
        body: '$similar groups of very similar photos detected. '
              'Review them — you probably only need one version of each.',
        priority: SuggestionPriority.medium,
      ));
    }

    // 4. Downloads folder bloat
    final downloads = result.groups.where((g) =>
      g.files.any((f) => f.path.toLowerCase().contains('download')));
    if (downloads.isNotEmpty) {
      suggestions.add(SmartSuggestion(
        icon: '📥',
        title: 'Downloads folder duplicates',
        body: '${downloads.length} duplicate groups in your Downloads folder. '
              'These are usually safe to clean up.',
        priority: SuggestionPriority.medium,
      ));
    }

    // 5. Old files (older than 1 year)
    final now = DateTime.now();
    final old = result.groups.where((g) =>
      g.files.any((f) => now.difference(f.modifiedAt).inDays > 365));
    if (old.isNotEmpty) {
      suggestions.add(SmartSuggestion(
        icon: '📅',
        title: 'Old duplicate files',
        body: '${old.length} groups contain files older than 1 year. '
              'You likely no longer need the older copies.',
        priority: SuggestionPriority.low,
      ));
    }

    // 6. Total potential
    suggestions.add(SmartSuggestion(
      icon: '✨',
      title: 'Total potential savings',
      body: 'Cleaning all ${result.totalDuplicates} duplicates across '
            '${result.groups.length} groups will free ${_fmt(result.totalWastedSpace)}.',
      priority: SuggestionPriority.info,
    ));

    return suggestions;
  }

  static String _fmt(int b) {
    if (b < 1048576) return '${(b / 1024).toStringAsFixed(0)} KB';
    if (b < 1073741824) return '${(b / 1048576).toStringAsFixed(1)} MB';
    return '${(b / 1073741824).toStringAsFixed(2)} GB';
  }
}

enum SuggestionPriority { high, medium, low, info }

class SmartSuggestion {
  final String icon, title, body;
  final SuggestionPriority priority;

  const SmartSuggestion({
    required this.icon, required this.title,
    required this.body, required this.priority,
  });
}
