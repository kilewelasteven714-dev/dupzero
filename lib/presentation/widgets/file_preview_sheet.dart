import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/duplicate_file.dart';
import '../../domain/entities/duplicate_group.dart';

/// Bottom sheet that shows a visual side-by-side preview of duplicate files
/// so the user can see exactly what they are deleting before confirming.
class FilePreviewSheet extends StatelessWidget {
  final DuplicateGroup group;

  const FilePreviewSheet({super.key, required this.group});

  static Future<void> show(BuildContext context, DuplicateGroup group) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => FilePreviewSheet(group: group),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Column(children: [
        // Handle
        Container(margin: const EdgeInsets.only(top: 12, bottom: 8),
          width: 40, height: 4,
          decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2))),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Text('Preview Files', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ]),
        ),

        Expanded(
          child: ListView(controller: ctrl, padding: const EdgeInsets.all(16), children: [
            Text('Compare files in this group before deleting:',
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
            const SizedBox(height: 16),
            ...group.files.asMap().entries.map((e) => _FileCard(
              file: e.value,
              isKeep: e.key == 0,
            )),
          ]),
        ),
      ]),
    );
  }
}

class _FileCard extends StatelessWidget {
  final DuplicateFile file;
  final bool isKeep;

  const _FileCard({required this.file, required this.isKeep});

  bool get _isImage => ['.jpg','.jpeg','.png','.gif','.webp','.heic']
      .any((ext) => file.name.toLowerCase().endsWith(ext));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isKeep ? cs.secondaryContainer.withOpacity(0.3) : cs.errorContainer.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isKeep ? cs.secondary.withOpacity(0.4) : cs.error.withOpacity(0.3),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image preview if applicable
        if (_isImage)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 160, width: double.infinity,
              child: Image.file(
                File(file.path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: cs.surfaceContainerHighest,
                  child: Icon(Icons.broken_image_outlined, size: 48, color: cs.onSurfaceVariant),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(file.name,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                overflow: TextOverflow.ellipsis)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isKeep ? cs.secondaryContainer : cs.errorContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(isKeep ? 'KEEP' : 'DELETE',
                  style: TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w800,
                    color: isKeep ? cs.secondary : cs.error,
                  )),
              ),
            ]),
            const SizedBox(height: 6),
            _InfoRow(Icons.folder_outlined, file.path),
            _InfoRow(Icons.data_usage_outlined, file.sizeFormatted),
            _InfoRow(Icons.calendar_today_outlined,
              'Modified: ${file.modifiedAt.toString().split(' ').first}'),
          ]),
        ),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(children: [
        Icon(icon, size: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(child: Text(text,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
          overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
