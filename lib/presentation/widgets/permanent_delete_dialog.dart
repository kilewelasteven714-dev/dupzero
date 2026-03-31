import 'package:flutter/material.dart';
import '../../core/services/storage_alert_service.dart';

/// Shows a strong permanent deletion warning before any file is deleted.
/// Must be awaited — returns true only if user explicitly confirms.
class PermanentDeleteDialog extends StatelessWidget {
  final int fileCount;
  final int totalBytes;

  const PermanentDeleteDialog({
    super.key, required this.fileCount, required this.totalBytes,
  });

  String _fmt(int b) {
    if (b < 1048576) return '${(b / 1024).toStringAsFixed(0)} KB';
    if (b < 1073741824) return '${(b / 1048576).toStringAsFixed(1)} MB';
    return '${(b / 1073741824).toStringAsFixed(2)} GB';
  }

  static Future<bool> show(BuildContext context, {
    required int fileCount, required int totalBytes,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PermanentDeleteDialog(fileCount: fileCount, totalBytes: totalBytes),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      icon: Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: cs.errorContainer, shape: BoxShape.circle),
        child: Icon(Icons.delete_forever_rounded, color: cs.error, size: 30),
      ),
      title: const Text('Permanently Delete Files?',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.errorContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            StorageAlertService.permanentDeletionWarning(fileCount, _fmt(totalBytes)),
            style: TextStyle(fontSize: 13, color: cs.onSurface, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Icon(Icons.info_outline, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(child: Text(
            '$fileCount file${fileCount == 1 ? '' : 's'} · ${_fmt(totalBytes)} will be freed',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          )),
        ]),
      ]),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, false),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12)),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: cs.error,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          ),
          child: const Text('Delete Forever', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}
