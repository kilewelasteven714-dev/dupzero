import 'package:flutter/material.dart';
import '../../domain/entities/duplicate_group.dart';

/// Shows a live breakdown of duplicates found by category during scanning.
class ScanProgressDetails extends StatelessWidget {
  final List<DuplicateGroup> groupsFound;

  const ScanProgressDetails({super.key, required this.groupsFound});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final counts = <FileCategory, int>{};
    int wasted = 0;

    for (final g in groupsFound) {
      counts[g.category] = (counts[g.category] ?? 0) + 1;
      wasted += g.wastedSpace;
    }

    if (counts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Found so far', style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w700, color: cs.onSurfaceVariant)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          ...counts.entries.map((e) => _CategoryChip(category: e.key, count: e.value)),
          _CategoryChip.wasted(wasted),
        ]),
      ]),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final FileCategory? category;
  final int count;
  final bool isWasted;

  const _CategoryChip({required this.category, required this.count, this.isWasted = false});

  factory _CategoryChip.wasted(int bytes) =>
      _CategoryChip(category: null, count: bytes, isWasted: true);

  String get _label {
    if (isWasted) return _fmtBytes(count);
    switch (category!) {
      case FileCategory.image: return '$count images';
      case FileCategory.video: return '$count videos';
      case FileCategory.audio: return '$count audio';
      case FileCategory.document: return '$count docs';
      case FileCategory.other: return '$count other';
    }
  }

  IconData get _icon {
    if (isWasted) return Icons.data_usage_outlined;
    switch (category!) {
      case FileCategory.image: return Icons.image_outlined;
      case FileCategory.video: return Icons.videocam_outlined;
      case FileCategory.audio: return Icons.music_note_outlined;
      case FileCategory.document: return Icons.description_outlined;
      case FileCategory.other: return Icons.insert_drive_file_outlined;
    }
  }

  String _fmtBytes(int b) {
    if (b < 1048576) return '${(b / 1024).toStringAsFixed(0)}KB wasted';
    return '${(b / 1048576).toStringAsFixed(1)}MB wasted';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isWasted ? cs.errorContainer.withOpacity(0.5) : cs.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(_icon, size: 13, color: isWasted ? cs.error : cs.primary),
        const SizedBox(width: 4),
        Text(_label, style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: isWasted ? cs.error : cs.primary,
        )),
      ]),
    );
  }
}
