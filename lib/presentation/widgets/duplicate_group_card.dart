import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/duplicate_group.dart';
import '../../domain/entities/duplicate_file.dart';
import '../blocs/cleanup/cleanup_bloc.dart';
import 'file_preview_sheet.dart';

class DuplicateGroupCard extends StatefulWidget {
  final DuplicateGroup group;
  final CleanupReady state;
  const DuplicateGroupCard({super.key, required this.group, required this.state});
  @override
  State<DuplicateGroupCard> createState() => _DuplicateGroupCardState();
}

class _DuplicateGroupCardState extends State<DuplicateGroupCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final group = widget.group;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _catColor(group.category, cs).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_catIcon(group.category),
                    color: _catColor(group.category, cs), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('${group.files.length} files',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  if (group.duplicateType == DuplicateType.similar)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: cs.tertiaryContainer,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text('SIMILAR',
                          style: TextStyle(
                              color: cs.onTertiaryContainer,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                ]),
                Text('Wasting ${_fmt(group.wastedSpace)}',
                    style: TextStyle(fontSize: 12, color: cs.error)),
              ])),
              // Preview button
              IconButton(
                icon: const Icon(Icons.visibility_outlined, size: 20),
                tooltip: 'Preview files',
                onPressed: () => FilePreviewSheet.show(context, group),
              ),
              IconButton(
                icon: const Icon(Icons.select_all_outlined, size: 20),
                tooltip: 'Select duplicates',
                onPressed: () =>
                    context.read<CleanupBloc>().add(SelectAllInGroupEvent(group)),
              ),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                  color: cs.onSurfaceVariant),
            ]),
          ),
        ),
        // File list
        if (_expanded) ...[
          const Divider(height: 1, indent: 16),
          ...group.files.asMap().entries.map((entry) {
            final file = entry.value;
            final isFirst = entry.key == 0;
            final selected = widget.state.selectedFiles[file.id] ?? false;
            return _FileRow(file: file, isKeep: isFirst, selected: selected);
          }),
          const SizedBox(height: 8),
        ],
      ]),
    );
  }

  Color _catColor(FileCategory cat, ColorScheme cs) {
    switch (cat) {
      case FileCategory.image: return cs.primary;
      case FileCategory.video: return cs.secondary;
      case FileCategory.audio: return cs.tertiary;
      case FileCategory.document: return cs.error;
      case FileCategory.other: return cs.outline;
    }
  }

  IconData _catIcon(FileCategory cat) {
    switch (cat) {
      case FileCategory.image: return Icons.image_outlined;
      case FileCategory.video: return Icons.videocam_outlined;
      case FileCategory.audio: return Icons.music_note_outlined;
      case FileCategory.document: return Icons.description_outlined;
      case FileCategory.other: return Icons.insert_drive_file_outlined;
    }
  }

  String _fmt(int b) {
    if (b < 1048576) return '${(b / 1024).toStringAsFixed(0)} KB';
    return '${(b / 1048576).toStringAsFixed(1)} MB';
  }
}

class _FileRow extends StatelessWidget {
  final DuplicateFile file;
  final bool isKeep, selected;
  const _FileRow({required this.file, required this.isKeep, required this.selected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: isKeep
          ? null
          : () => context
              .read<CleanupBloc>()
              .add(ToggleFileSelectionEvent(file.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          if (isKeep)
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                  color: cs.secondaryContainer, shape: BoxShape.circle),
              child: Icon(Icons.star, size: 14, color: cs.secondary),
            )
          else
            Checkbox(
              value: selected,
              visualDensity: VisualDensity.compact,
              onChanged: (_) => context
                  .read<CleanupBloc>()
                  .add(ToggleFileSelectionEvent(file.id)),
            ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(file.name,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isKeep ? cs.onSurfaceVariant : null),
                overflow: TextOverflow.ellipsis),
            Text(file.sizeFormatted,
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
          ])),
          if (isKeep)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(4)),
              child: Text('KEEP',
                  style: TextStyle(
                      color: cs.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ),
        ]),
      ),
    );
  }
}
