import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../blocs/scan/scan_bloc.dart';
import '../blocs/cleanup/cleanup_bloc.dart';
import '../blocs/storage/storage_bloc.dart';
import '../widgets/scan_progress_details.dart';
import '../widgets/smart_suggestions_card.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _images = true, _videos = true, _audio = true, _docs = true;
  bool _similar = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan')),
      body: BlocConsumer<ScanBloc, ScanState>(
        listener: (ctx, state) {
          if (state is ScanComplete) {
            // Refresh storage after scan (counts may have changed)
            context.read<StorageBloc>().add(RefreshStorageEvent());
            // Load groups into cleanup bloc
            ctx.read<CleanupBloc>().add(LoadGroupsEvent(state.result.groups));
          }
        },
        builder: (ctx, state) {
          if (state is ScanInProgress) return _ScanningView(state: state);
          if (state is ScanComplete) return _ScanCompleteView(state: state);
          if (state is ScanError) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.error_outline, size: 64, color: cs.error),
              const SizedBox(height: 16),
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => ctx.read<ScanBloc>().add(
                  StartScanEvent(paths: ['/storage/emulated/0'],
                      detectSimilar: _similar)),
                child: const Text('Try Again'),
              ),
            ]));
          }
          return _SetupView(
            images: _images, videos: _videos, audio: _audio, docs: _docs,
            similar: _similar,
            onToggle: (key, val) => setState(() {
              if (key == 'images') _images = val;
              else if (key == 'videos') _videos = val;
              else if (key == 'audio') _audio = val;
              else if (key == 'docs') _docs = val;
              else if (key == 'similar') _similar = val;
            }),
            onStart: () => _startScan(ctx),
          );
        },
      ),
    );
  }

  Future<void> _startScan(BuildContext ctx) async {
    // Request storage permission first
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      if (!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text('Storage permission required to scan files'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    if (!ctx.mounted) return;
    ctx.read<ScanBloc>().add(StartScanEvent(
      paths: ['/storage/emulated/0'],
      detectSimilar: _similar,
    ));
  }
}

// ── Setup view ────────────────────────────────────────────────────────
class _SetupView extends StatelessWidget {
  final bool images, videos, audio, docs, similar;
  final void Function(String, bool) onToggle;
  final VoidCallback onStart;

  const _SetupView({
    required this.images, required this.videos, required this.audio,
    required this.docs, required this.similar,
    required this.onToggle, required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Ready card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: [
            Container(
              width: 56, height: 56, decoration: BoxDecoration(
                color: cs.primary, shape: BoxShape.circle),
              child: Icon(Icons.search_rounded, color: cs.onPrimary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Ready to Scan', style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
              Text('Configure file types below then start.',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13)),
            ])),
          ]),
        ),

        const SizedBox(height: 24),
        Text('File Types', style: theme.textTheme.titleSmall
            ?.copyWith(fontWeight: FontWeight.w700, color: cs.primary)),
        const SizedBox(height: 10),

        Card(child: Column(children: [
          _Toggle(icon: Icons.image_outlined, label: 'Images',
              value: images, onChanged: (v) => onToggle('images', v)),
          _Toggle(icon: Icons.videocam_outlined, label: 'Videos',
              value: videos, onChanged: (v) => onToggle('videos', v)),
          _Toggle(icon: Icons.music_note_outlined, label: 'Audio',
              value: audio, onChanged: (v) => onToggle('audio', v)),
          _Toggle(icon: Icons.description_outlined, label: 'Documents',
              value: docs, onChanged: (v) => onToggle('docs', v)),
        ])),

        const SizedBox(height: 16),
        Text('AI Detection', style: theme.textTheme.titleSmall
            ?.copyWith(fontWeight: FontWeight.w700, color: cs.primary)),
        const SizedBox(height: 10),

        Card(child: _Toggle(
          icon: Icons.auto_awesome_outlined,
          label: 'Detect Similar Images',
          subtitle: 'Perceptual hashing for near-duplicate photos',
          value: similar,
          onChanged: (v) => onToggle('similar', v),
        )),

        const SizedBox(height: 24),
        FilledButton(
          onPressed: onStart,
          style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 54)),
          child: const Text('Start Scan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 16),
      ]),
    );
  }
}

class _Toggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _Toggle({
    required this.icon, required this.label, required this.value,
    required this.onChanged, this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: onChanged,
    );
  }
}

// ── Scanning view ─────────────────────────────────────────────────────
class _ScanningView extends StatelessWidget {
  final ScanInProgress state;
  const _ScanningView({required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pct = state.total > 0
        ? (state.scanned / state.total * 100).round() : 0;
    final circumference = 2 * 3.14159 * 70;
    final offset = circumference * (1 - pct / 100);

    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(height: 40),
        // Circular progress
        SizedBox(width: 180, height: 180, child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(180, 180),
              painter: _ArcPainter(progress: pct / 100, color: cs.primary),
            ),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$pct%',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800,
                      color: cs.primary)),
              Text('scanning',
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
            ]),
          ],
        )),

        const SizedBox(height: 20),
        Text('Scanning Files...',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),

        // Current file
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8)),
          child: Text(state.currentFile,
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
        ),

        const SizedBox(height: 20),
        // Stats
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _StatPill('${state.scanned}/${state.total}', 'files', cs.primary),
          const SizedBox(width: 16),
          _StatPill('${state.groupsFound}', 'groups', cs.error),
        ]),

        const SizedBox(height: 20),
        // Live breakdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ScanProgressDetails(
              groupsFound: state.liveGroups),
        ),

        const SizedBox(height: 20),
        OutlinedButton.icon(
          icon: const Icon(Icons.close),
          label: const Text('Cancel'),
          onPressed: () =>
              context.read<ScanBloc>().add(CancelScanEvent()),
        ),
        const SizedBox(height: 40),
      ]),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatPill(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 10.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final bg = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;
    final fg = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      2 * 3.14159 * progress,
      false, fg,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

// ── Scan complete view ────────────────────────────────────────────────
class _ScanCompleteView extends StatelessWidget {
  final ScanComplete state;
  const _ScanCompleteView({required this.state});

  String _fmt(int b) {
    if (b < 1048576) return '${(b / 1048576).toStringAsFixed(1)} MB';
    return '${(b / 1073741824).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final result = state.result;

    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(height: 40),
        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(color: cs.primaryContainer, shape: BoxShape.circle),
          child: Icon(Icons.check_rounded, color: cs.primary, size: 50),
        ),
        const SizedBox(height: 20),
        Text('Scan Complete!',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Found ${result.totalDuplicates} duplicates in ${result.groups.length} groups',
            style: TextStyle(color: cs.onSurfaceVariant)),

        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: _ResultCard(
                icon: Icons.copy_outlined, label: 'Duplicates',
                value: '${result.totalDuplicates}', color: cs.primary)),
            const SizedBox(width: 12),
            Expanded(child: _ResultCard(
                icon: Icons.folder_outlined, label: 'Groups',
                value: '${result.groups.length}', color: cs.secondary)),
            const SizedBox(width: 12),
            Expanded(child: _ResultCard(
                icon: Icons.savings_outlined, label: 'Wasted',
                value: _fmt(result.totalWastedSpace), color: cs.error)),
          ]),
        ),

        const SizedBox(height: 24),
        // Smart suggestions
        SmartSuggestionsCard(result: result),

        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => context.read<ScanBloc>().add(LoadScanHistoryEvent()),
              child: const Text('Scan Again'),
            )),
            const SizedBox(width: 12),
            Expanded(child: FilledButton(
              onPressed: () => context.go('/duplicates'),
              child: const Text('View Duplicates'),
            )),
          ]),
        ),
        const SizedBox(height: 40),
      ]),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _ResultCard({required this.icon, required this.label,
      required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}
