import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Mock data — in production comes from Hive analyticsBox
    final weeklyData = [120, 340, 280, 510, 450, 720, 660];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxVal = weeklyData.reduce((a, b) => a > b ? a : b).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── STAT CARDS ──────────────────────────────────────────
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5,
            children: [
              _StatCard(icon: Icons.savings_outlined, label: 'Total Saved', value: '1.2 GB', color: cs.primary),
              _StatCard(icon: Icons.search_outlined, label: 'Scans Run', value: '14', color: cs.secondary),
              _StatCard(icon: Icons.delete_outline, label: 'Files Deleted', value: '247', color: cs.error),
              _StatCard(icon: Icons.copy_outlined, label: 'Groups Found', value: '83', color: cs.tertiary),
              _StatCard(icon: Icons.timer_outlined, label: 'Time Saved', value: '4.2 hrs', color: Colors.orange),
              _StatCard(icon: Icons.folder_outlined, label: 'Folders Scanned', value: '312', color: Colors.teal),
            ],
          ),

          const SizedBox(height: 24),

          // ── WEEKLY BAR CHART ─────────────────────────────────────
          Text('Space Freed — Last 7 Days',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: BarChart(BarChartData(
              maxY: maxVal * 1.2,
              barGroups: weeklyData.asMap().entries.map((e) => BarChartGroupData(
                x: e.key,
                barRods: [BarChartRodData(
                  toY: e.value.toDouble(),
                  color: e.key == 5 ? cs.primary : cs.primary.withOpacity(0.3),
                  width: 22,
                  borderRadius: BorderRadius.circular(6),
                )],
              )).toList(),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) => Text(days[v.toInt()],
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
                )),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
            )),
          ),

          const SizedBox(height: 24),

          // ── TYPE BREAKDOWN PIE CHART ─────────────────────────────
          Text('Duplicates by File Type',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              width: 160, height: 160,
              child: PieChart(PieChartData(
                sections: [
                  PieChartSectionData(value: 45, color: cs.primary, title: '45%', radius: 55, titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  PieChartSectionData(value: 30, color: cs.secondary, title: '30%', radius: 55, titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  PieChartSectionData(value: 15, color: cs.tertiary, title: '15%', radius: 55, titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  PieChartSectionData(value: 10, color: cs.error, title: '10%', radius: 55, titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ],
                sectionsSpace: 3,
                centerSpaceRadius: 30,
              )),
            ),
            const SizedBox(width: 24),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Legend(cs.primary, 'Images', '45%'),
              _Legend(cs.secondary, 'Videos', '30%'),
              _Legend(cs.tertiary, 'Documents', '15%'),
              _Legend(cs.error, 'Audio', '10%'),
            ]),
          ]),

          const SizedBox(height: 24),

          // ── TOP BLOAT SOURCES ────────────────────────────────────
          Text('Biggest Space Wasters',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...[
            _BloatSource('WhatsApp Media', '340 MB', 0.72, cs.primary),
            _BloatSource('DCIM/Camera', '280 MB', 0.58, cs.secondary),
            _BloatSource('Telegram', '210 MB', 0.44, cs.tertiary),
            _BloatSource('Downloads', '180 MB', 0.38, cs.error),
          ].map((b) => _BloatSourceRow(source: b)),

          const SizedBox(height: 32),

          // Developer credit
          Center(child: Column(children: [
            Text('DupZero v1.1.0', style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
            const SizedBox(height: 2),
            Text('Developed by Tavoo',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cs.primary)),
          ])),

          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 22),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label, pct;
  const _Legend(this.color, this.label, this.pct);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text('$label ($pct)', style: const TextStyle(fontSize: 13)),
      ]),
    );
  }
}

class _BloatSource {
  final String name, size;
  final double fraction;
  final Color color;
  const _BloatSource(this.name, this.size, this.fraction, this.color);
}

class _BloatSourceRow extends StatelessWidget {
  final _BloatSource source;
  const _BloatSourceRow({required this.source});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(source.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const Spacer(),
          Text(source.size, style: TextStyle(fontWeight: FontWeight.w700, color: source.color)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: source.fraction),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            builder: (_, v, __) => LinearProgressIndicator(
              value: v, minHeight: 8,
              backgroundColor: cs.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(source.color),
            ),
          ),
        ),
      ]),
    );
  }
}
