import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../../domain/entities/user_settings.dart';

/// Lets the user add folders that DupZero will NEVER scan or touch.
/// This protects important personal documents, work files, etc.
class ExcludedFoldersPage extends StatelessWidget {
  const ExcludedFoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Protected Folders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add folder',
            onPressed: () => _addFolder(context),
          ),
        ],
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (ctx, state) {
          final settings = state is SettingsLoaded ? state.settings : const UserSettings();
          final excluded = settings.excludedPaths;

          if (excluded.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.shield_outlined, size: 64, color: cs.onSurfaceVariant.withOpacity(0.4)),
              const SizedBox(height: 16),
              const Text('No protected folders yet'),
              const SizedBox(height: 8),
              Text('Add folders DupZero should never scan or touch.',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton.icon(
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Protected Folder'),
                onPressed: () => _addFolder(context),
              ),
            ]));
          }

          return Column(children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Icon(Icons.shield_outlined, color: cs.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  'DupZero will never scan, touch, or delete files in these folders.',
                  style: TextStyle(fontSize: 13, color: cs.onSurface),
                )),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: excluded.length,
                itemBuilder: (_, i) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(Icons.folder_special_outlined, color: cs.primary),
                    title: Text(excluded[i],
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: cs.error),
                      onPressed: () {
                        final updated = List<String>.from(excluded)..removeAt(i);
                        ctx.read<SettingsBloc>().add(UpdateSettingsEvent(
                          settings.copyWith(excludedPaths: updated)));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Future<void> _addFolder(BuildContext context) async {
    final ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Protected Folder'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: '/storage/emulated/0/ImportantDocs',
            helperText: 'Enter the full folder path',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('Protect'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      final state = context.read<SettingsBloc>().state;
      final settings = state is SettingsLoaded ? state.settings : const UserSettings();
      final updated = List<String>.from(settings.excludedPaths)..add(result);
      context.read<SettingsBloc>().add(UpdateSettingsEvent(
        settings.copyWith(excludedPaths: updated)));
    }
  }
}
