import 'package:flutter/material.dart';

class RecentScansCard extends StatelessWidget {
  const RecentScansCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final scans = [
      {'date': '2 hours ago', 'files': '1,204', 'found': '12', 'saved': '340 MB'},
      {'date': 'Yesterday',   'files': '982',   'found': '8',  'saved': '210 MB'},
      {'date': '3 days ago',  'files': '1,450', 'found': '19', 'saved': '680 MB'},
    ];

    return Card(
      child: Column(
        children: scans.asMap().entries.map((entry) {
          final s = entry.value;
          return Column(children: [
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.history, color: cs.primary, size: 20),
              ),
              title: Text(s['date']!,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle:
                  Text('${s['files']} files · ${s['found']} duplicates'),
              trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(s['saved']!,
                    style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                Text('freed',
                    style: TextStyle(
                        fontSize: 11, color: cs.onSurfaceVariant)),
              ]),
            ),
            if (entry.key < scans.length - 1)
              const Divider(height: 1, indent: 16),
          ]);
        }).toList(),
      ),
    );
  }
}
