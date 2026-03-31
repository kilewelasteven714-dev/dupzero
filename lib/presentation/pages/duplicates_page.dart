import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cleanup/cleanup_bloc.dart';
import '../blocs/storage/storage_bloc.dart';
import '../widgets/duplicate_group_card.dart';
import '../widgets/permanent_delete_dialog.dart';
import '../../domain/entities/duplicate_file.dart';
import '../../domain/entities/duplicate_group.dart';

class DuplicatesPage extends StatefulWidget {
  const DuplicatesPage({super.key});
  @override State<DuplicatesPage> createState() => _DuplicatesPageState();
}

class _DuplicatesPageState extends State<DuplicatesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duplicates'),
        actions: [
          BlocBuilder<CleanupBloc, CleanupState>(builder: (ctx, state) {
            if (state is! CleanupReady) return const SizedBox.shrink();
            return PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'auto', child: Text('Auto-select oldest')),
                const PopupMenuItem(value: 'clear', child: Text('Clear selection')),
              ],
              onSelected: (v) {
                if (v == 'auto') ctx.read<CleanupBloc>().add(AutoSelectOldestEvent());
                if (v == 'clear') {
                  ctx.read<CleanupBloc>().add(LoadGroupsEvent(state.groups));
                }
              },
            );
          }),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'), Tab(text: 'Images'),
            Tab(text: 'Videos'), Tab(text: 'Audio'), Tab(text: 'Documents'),
          ],
        ),
      ),
      body: BlocConsumer<CleanupBloc, CleanupState>(
        listener: (ctx, state) {
          if (state is CleanupSuccess) {
            // Refresh storage after deletion
            context.read<StorageBloc>().add(RefreshStorageEvent());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Permanently deleted \${state.deletedCount} files · '
                'Freed \${_fmt(state.freedBytes)}'),
              backgroundColor: cs.primary,
              behavior: SnackBarBehavior.floating,
            ));
          }
          if (state is CleanupError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: cs.error,
            ));
          }
        },
        builder: (ctx, state) {
          if (state is CleanupInitial) {
            return _EmptyState(
              message: 'Run a scan to find duplicate files',
              icon: Icons.search_rounded,
            );
          }
          if (state is CleanupDeleting) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Permanently deleting \${state.count} files...'),
              const SizedBox(height: 8),
              const Text('This cannot be undone.',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            ]));
          }
          if (state is CleanupSuccess) {
            return _EmptyState(
              message: 'All done! Freed \${_fmt(state.freedBytes)} permanently.',
              icon: Icons.check_circle_outline_rounded,
            );
          }
          if (state is! CleanupReady) return const SizedBox.shrink();

          if (state.groups.isEmpty) {
            return _EmptyState(
              message: 'No duplicates found — your device is clean!',
              icon: Icons.done_all_rounded,
            );
          }

          return Column(children: [
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _GroupList(groups: state.groups, filter: null, state: state),
                  _GroupList(groups: state.groups, filter: FileCategory.image, state: state),
                  _GroupList(groups: state.groups, filter: FileCategory.video, state: state),
                  _GroupList(groups: state.groups, filter: FileCategory.audio, state: state),
                  _GroupList(groups: state.groups, filter: FileCategory.document, state: state),
                ],
              ),
            ),
            _BottomActionBar(state: state),
          ]);
        },
      ),
    );
  }

  String _fmt(int b) {
    if (b < 1048576) return '\${(b / 1024).toStringAsFixed(0)}KB';
    return '\${(b / 1048576).toStringAsFixed(1)}MB';
  }
}

class _GroupList extends StatelessWidget {
  final List<DuplicateGroup> groups;
  final FileCategory? filter;
  final CleanupReady state;

  const _GroupList({required this.groups, required this.filter, required this.state});

  @override
  Widget build(BuildContext context) {
    final filtered = filter == null
        ? groups : groups.where((g) => g.category == filter).toList();
    if (filtered.isEmpty) {
      return _EmptyState(
        message: 'No \${filter?.name ?? ''} duplicates found',
        icon: Icons.folder_open_outlined,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (ctx, i) => DuplicateGroupCard(
        group: filtered[i], state: state),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final CleanupReady state;
  const _BottomActionBar({required this.state});

  String _fmt(int b) {
    if (b < 1048576) return '\${(b / 1024).toStringAsFixed(0)}KB';
    return '\${(b / 1048576).toStringAsFixed(1)}MB';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final count = state.selectedCount;
    final savings = state.totalPotentialSavings;
    if (count == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Permanent deletion notice
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: cs.errorContainer.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(children: [
            Icon(Icons.warning_amber_rounded, size: 14, color: cs.error),
            const SizedBox(width: 6),
            Expanded(child: Text(
              'Deleted files are PERMANENTLY removed from your device.',
              style: TextStyle(fontSize: 11, color: cs.error, fontWeight: FontWeight.w600),
            )),
          ]),
        ),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('\$count file\${count == 1 ? '' : 's'} selected',
              style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Will free \${_fmt(savings)}',
              style: TextStyle(color: cs.primary, fontSize: 12)),
          ])),
          FilledButton.icon(
            onPressed: () => _confirmDelete(context, count, savings),
            icon: const Icon(Icons.delete_forever_rounded),
            label: const Text('Delete Forever'),
            style: FilledButton.styleFrom(
              backgroundColor: cs.error, foregroundColor: cs.onError,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ]),
      ]),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, int count, int savings) async {
    final confirmed = await PermanentDeleteDialog.show(
      context, fileCount: count, totalBytes: savings,
    );
    if (confirmed && context.mounted) {
      context.read<CleanupBloc>().add(DeleteSelectedEvent());
    }
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  const _EmptyState({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 64, color: cs.onSurfaceVariant.withOpacity(0.4)),
      const SizedBox(height: 16),
      Text(message,
        style: TextStyle(color: cs.onSurfaceVariant),
        textAlign: TextAlign.center),
    ]));
  }
}
