import 'package:flutter/material.dart';

/// App-level Recycle Bin.
/// When a user deletes duplicates, files are first moved here.
/// They can restore files within 30 days before permanent purge.
/// After 30 days OR when user empties trash — permanently deleted from device.
class TrashPage extends StatefulWidget {
  const TrashPage({super.key});
  @override State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  // In production: loaded from Hive deletedFilesBox
  final List<_TrashItem> _items = [
    _TrashItem(name: 'IMG_20240312_vacation.jpg', size: '4.2 MB', daysLeft: 28, path: '/WhatsApp/Media/'),
    _TrashItem(name: 'birthday_video.mp4', size: '120.4 MB', daysLeft: 14, path: '/Telegram/'),
    _TrashItem(name: 'CV_Tavoo_2024.pdf', size: '0.8 MB', daysLeft: 5, path: '/Downloads/'),
    _TrashItem(name: 'selfie_002.jpg', size: '2.7 MB', daysLeft: 1, path: '/DCIM/Camera/'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Bin'),
        actions: [
          if (_items.isNotEmpty)
            TextButton.icon(
              icon: Icon(Icons.delete_forever_rounded, color: cs.error),
              label: Text('Empty', style: TextStyle(color: cs.error, fontWeight: FontWeight.w700)),
              onPressed: () => _emptyTrash(context),
            ),
        ],
      ),
      body: _items.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.delete_outline_rounded, size: 72, color: cs.onSurfaceVariant.withOpacity(0.3)),
              const SizedBox(height: 16),
              const Text('Recycle bin is empty'),
              const SizedBox(height: 8),
              Text('Deleted files appear here for 30 days
before permanent removal.',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                textAlign: TextAlign.center),
            ]))
          : Column(children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  Icon(Icons.info_outline_rounded, color: cs.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'Files are permanently deleted after 30 days or when you empty the bin.',
                    style: TextStyle(fontSize: 12, color: cs.onSurface),
                  )),
                ]),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _items.length,
                  itemBuilder: (_, i) => _TrashCard(
                    item: _items[i],
                    onRestore: () => setState(() => _items.removeAt(i)),
                    onDelete: () => _confirmPermanentDelete(context, i),
                  ),
                ),
              ),
            ]),
    );
  }

  Future<void> _emptyTrash(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.delete_forever_rounded, color: cs.error, size: 36),
        title: const Text('Empty Recycle Bin?'),
        content: Text(
          'This will PERMANENTLY delete all ${_items.length} files. '
          'This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
    if (confirmed == true) setState(() => _items.clear());
  }

  Future<void> _confirmPermanentDelete(BuildContext context, int i) async {
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Permanently Delete?'),
        content: Text('"${_items[i].name}" will be permanently removed and cannot be recovered.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
    if (confirmed == true) setState(() => _items.removeAt(i));
  }
}

class _TrashItem {
  final String name, size, path;
  final int daysLeft;
  const _TrashItem({required this.name, required this.size, required this.path, required this.daysLeft});
}

class _TrashCard extends StatelessWidget {
  final _TrashItem item;
  final VoidCallback onRestore, onDelete;
  const _TrashCard({required this.item, required this.onRestore, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isExpiring = item.daysLeft <= 3;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 44, height: 44, decoration: BoxDecoration(
            color: isExpiring ? cs.errorContainer : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.insert_drive_file_outlined,
            color: isExpiring ? cs.error : cs.onSurfaceVariant),
        ),
        title: Text(item.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.path, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
          Row(children: [
            Text(item.size, style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
            const Text(' · '),
            Text(
              item.daysLeft <= 1 ? '⚠️ Deletes tomorrow!' : '${item.daysLeft} days left',
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: isExpiring ? cs.error : cs.onSurfaceVariant,
              )),
          ]),
        ]),
        isThreeLine: true,
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            icon: Icon(Icons.restore_rounded, color: cs.primary),
            tooltip: 'Restore',
            onPressed: onRestore,
          ),
          IconButton(
            icon: Icon(Icons.delete_forever_rounded, color: cs.error),
            tooltip: 'Delete forever',
            onPressed: onDelete,
          ),
        ]),
      ),
    );
  }
}
