import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/storage/storage_bloc.dart';
import '../widgets/storage_summary_card.dart';
import '../widgets/storage_alert_banner.dart';
import '../widgets/quick_scan_button.dart';
import '../widgets/recent_scans_card.dart';
import '../widgets/stats_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load storage info and check alert on every home visit
    context.read<StorageBloc>().add(LoadStorageEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: cs.primary, borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.deblur, color: cs.onPrimary, size: 20),
          ),
          const SizedBox(width: 8),
          const Text('DupZero'),
        ]),
        actions: [
          // Connectivity indicator
          _ConnectivityIndicator(),
          BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
            if (state is AuthAuthenticated) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    (state.user.displayName ?? state.user.email)[0].toUpperCase(),
                    style: TextStyle(
                      color: cs.primary, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<StorageBloc>().add(RefreshStorageEvent());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── STORAGE ALERT BANNER (appears when >= 70%) ──────────
              const StorageAlertBanner(),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WelcomeHeader(),
                    const SizedBox(height: 20),
                    const StorageSummaryCard(),
                    const SizedBox(height: 16),
                    const StatsRow(),
                    const SizedBox(height: 24),
                    Text('Quick Actions',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: QuickScanButton(
                        icon: Icons.folder_outlined,
                        label: 'Scan Device',
                        subtitle: 'Find local duplicates',
                        onTap: () => context.go('/scan'),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: QuickScanButton(
                        icon: Icons.cloud_outlined,
                        label: 'Cloud Scan',
                        subtitle: 'Drive, OneDrive, iCloud',
                        onTap: () => context.go('/scan'),
                        isPro: true,
                      )),
                    ]),
                    const SizedBox(height: 24),
                    Text('Recent Activity',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    const RecentScansCard(),
                    const SizedBox(height: 24),
                    _OfflineBadge(),
                    const SizedBox(height: 16),
                    _UpgradeProBanner(),
                    const SizedBox(height: 32),
                    _DeveloperCredit(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Developer credit ──────────────────────────────────────────────────
class _DeveloperCredit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(children: [
        Text('DupZero v1.1.0',
          style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text('Developed by Tavoo',
          style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w700,
            color: cs.primary, letterSpacing: 0.3,
          )),
      ]),
    );
  }
}

// ── Offline badge ─────────────────────────────────────────────────────
class _OfflineBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.secondary.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.wifi_off_rounded, size: 14, color: cs.secondary),
        const SizedBox(width: 6),
        Text('Works 100% Offline',
          style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: cs.secondary,
          )),
        const SizedBox(width: 4),
        Text('· Online only for cloud sync & updates',
          style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
      ]),
    );
  }
}

// ── Connectivity indicator ────────────────────────────────────────────
class _ConnectivityIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Icon(Icons.wifi, size: 18,
        color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Keep your device clean',
        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text('Detect and remove duplicate files to free up space.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant)),
    ]);
  }
}

class _UpgradeProBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
      final isPremium = state is AuthAuthenticated && state.user.isPremium;
      if (isPremium) return const SizedBox.shrink();

      return GestureDetector(
        onTap: () => context.go('/premium'),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Upgrade to Pro',
                style: TextStyle(
                  color: cs.onPrimary, fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 4),
              Text('Cloud scanning, AI detection & cross-device sync',
                style: TextStyle(color: cs.onPrimary.withOpacity(0.85), fontSize: 13)),
            ])),
            Icon(Icons.arrow_forward_ios, color: cs.onPrimary, size: 18),
          ]),
        ),
      );
    });
  }
}
