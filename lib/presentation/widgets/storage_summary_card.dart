import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/storage/storage_bloc.dart';

class StorageSummaryCard extends StatelessWidget {
  const StorageSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return BlocBuilder<StorageBloc, StorageState>(
      builder: (ctx, state) {
        final info = state is StorageLoaded ? state.info : null;
        final pct = info?.usedPercent ?? 65.6;
        final isAlert = pct >= 70;
        final isCritical = pct >= 90;

        // Bar color shifts: green → orange → red
        final barColor = isCritical
            ? Colors.red
            : isAlert
                ? Colors.orange
                : cs.primary;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: isAlert
                ? Border.all(color: barColor.withOpacity(0.5), width: 1.5)
                : null,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.storage_outlined,
                color: isAlert ? barColor : cs.primary, size: 20),
              const SizedBox(width: 8),
              Text('Device Storage',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              // Live percentage badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  info?.usedPercentFormatted ?? '${pct.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: barColor, fontWeight: FontWeight.w800, fontSize: 12,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 4),
            Text(
              info != null
                  ? '${info.usedFormatted} used of ${info.totalFormatted}'
                  : 'Loading...',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            // Animated progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: pct / 100),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value, minHeight: 12,
                  backgroundColor: cs.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                ),
              ),
            ),
            // Threshold marker at 70%
            Stack(children: [
              const SizedBox(height: 14, width: double.infinity),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.70 - 60,
                top: 2,
                child: Text('70%', style: TextStyle(fontSize: 9, color: cs.onSurfaceVariant)),
              ),
            ]),
            Row(children: [
              _Dot(label: 'Used', value: info?.usedFormatted ?? '41.6 GB', color: barColor),
              const SizedBox(width: 20),
              _Dot(label: 'Free', value: info?.freeFormatted ?? '22.4 GB', color: cs.secondary),
              const SizedBox(width: 20),
              _Dot(label: 'Freed by DupZero', value: '1.2 GB', color: cs.tertiary),
            ]),
          ]),
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Dot({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant)),
      ]),
      Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
    ]);
  }
}
