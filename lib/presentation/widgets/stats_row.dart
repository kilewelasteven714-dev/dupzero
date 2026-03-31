import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(children: [
      Expanded(child: _StatBox(
          icon: Icons.copy_outlined,
          label: 'Duplicates', value: '83', color: cs.primary)),
      const SizedBox(width: 12),
      Expanded(child: _StatBox(
          icon: Icons.delete_outline,
          label: 'Deleted', value: '247', color: cs.error)),
      const SizedBox(width: 12),
      Expanded(child: _StatBox(
          icon: Icons.savings_outlined,
          label: 'Saved', value: '1.2 GB', color: cs.tertiary)),
    ]);
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _StatBox(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w800, color: color)),
        Text(label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}
