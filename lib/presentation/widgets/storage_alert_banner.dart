import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/storage/storage_bloc.dart';
import '../../core/constants/app_constants.dart';

/// Shows a prominent red/orange alert banner when storage >= 70%.
/// Tapping it takes the user directly to the Scan page.
class StorageAlertBanner extends StatelessWidget {
  const StorageAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageBloc, StorageState>(
      builder: (ctx, state) {
        if (state is! StorageLoaded) return const SizedBox.shrink();
        if (!state.info.isAboveThreshold) return const SizedBox.shrink();

        final pct = state.info.usedPercent;
        final isCritical = pct >= 90;
        final cs = Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () => context.go('/scan'),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCritical
                    ? [const Color(0xFFFF3B3B), const Color(0xFFFF6B35)]
                    : [const Color(0xFFFF8C00), const Color(0xFFFFB347)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isCritical ? Colors.red : Colors.orange).withOpacity(0.4),
                  blurRadius: 12, offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCritical ? Icons.warning_rounded : Icons.storage_rounded,
                  color: Colors.white, size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  isCritical
                      ? '🚨 Storage Almost Full! ${state.info.usedPercentFormatted}'
                      : '⚠️ Storage ${state.info.usedPercentFormatted} Full',
                  style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Only ${state.info.freeFormatted} left. '
                  '${isCritical ? 'Scan NOW to free up space!' : 'Tap to scan for duplicates.'}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9), fontSize: 12,
                  ),
                ),
              ])),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Scan Now',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ]),
          ),
        );
      },
    );
  }
}
