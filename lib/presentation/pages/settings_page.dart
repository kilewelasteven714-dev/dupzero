import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/user_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (ctx, settingsState) {
          final settings = settingsState is SettingsLoaded
              ? settingsState.settings : const UserSettings();

          return ListView(padding: const EdgeInsets.all(16), children: [

            // ── APPEARANCE ───────────────────────────────────────────
            _SectionTitle('Appearance'),
            Card(child: Column(children: [
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text('Theme'),
                trailing: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (ctx, ts) => DropdownButton<ThemeMode>(
                    value: ts.themeMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                    ],
                    onChanged: (v) =>
                        ctx.read<ThemeBloc>().add(ChangeThemeModeEvent(v!)),
                  ),
                ),
              ),
              const Divider(height: 1, indent: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Color Theme', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (ctx, ts) => Wrap(
                      spacing: 12, runSpacing: 12,
                      children: AppColorThemes.themes.entries.map((e) =>
                        GestureDetector(
                          onTap: () => ctx.read<ThemeBloc>().add(ChangeColorSeedEvent(e.key)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: e.value, shape: BoxShape.circle,
                              border: ts.colorName == e.key
                                  ? Border.all(color: cs.onSurface, width: 3)
                                  : Border.all(color: Colors.transparent, width: 3),
                              boxShadow: ts.colorName == e.key
                                  ? [BoxShadow(color: e.value.withOpacity(0.5), blurRadius: 8)]
                                  : [],
                            ),
                            child: ts.colorName == e.key
                                ? const Icon(Icons.check, color: Colors.white, size: 20)
                                : null,
                          ),
                        )
                      ).toList(),
                    ),
                  ),
                ]),
              ),
            ])),

            const SizedBox(height: 16),

            // ── STORAGE ALERTS ───────────────────────────────────────
            _SectionTitle('Storage Alerts'),
            Card(child: Column(children: [
              ListTile(
                leading: Container(
                  width: 36, height: 36, decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.notifications_active_outlined, color: Colors.orange, size: 20),
                ),
                title: const Text('Storage Alert at 70%'),
                subtitle: const Text('Get notified when storage exceeds 70% — so you know to check for duplicates'),
                isThreeLine: true,
                trailing: Switch(
                  value: settings.notifyOnNewDuplicate,
                  onChanged: (v) => _update(ctx, settings.copyWith(notifyOnNewDuplicate: v)),
                ),
              ),
              const Divider(height: 1, indent: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Row(children: [
                  Icon(Icons.info_outline, size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'Alert fires when storage ≥ 70%. Re-alerts after 12 hours if storage stays high.',
                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  )),
                ]),
              ),
            ])),

            const SizedBox(height: 16),

            // ── SCAN OPTIONS ─────────────────────────────────────────
            _SectionTitle('Scan Options'),
            Card(child: Column(children: [
              SwitchListTile(
                secondary: const Icon(Icons.image_outlined),
                title: const Text('Scan Images'),
                value: settings.scanImages,
                onChanged: (v) => _update(ctx, settings.copyWith(scanImages: v)),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.videocam_outlined),
                title: const Text('Scan Videos'),
                value: settings.scanVideos,
                onChanged: (v) => _update(ctx, settings.copyWith(scanVideos: v)),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.music_note_outlined),
                title: const Text('Scan Audio'),
                value: settings.scanAudio,
                onChanged: (v) => _update(ctx, settings.copyWith(scanAudio: v)),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.description_outlined),
                title: const Text('Scan Documents'),
                value: settings.scanDocuments,
                onChanged: (v) => _update(ctx, settings.copyWith(scanDocuments: v)),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.auto_awesome_outlined),
                title: const Text('AI Similar Image Detection'),
                subtitle: const Text('Perceptual hashing — finds near-duplicate photos'),
                value: settings.detectSimilarImages,
                onChanged: (v) => _update(ctx, settings.copyWith(detectSimilarImages: v)),
              ),
            ])),

            const SizedBox(height: 16),

            // ── AUTOMATION ───────────────────────────────────────────
            _SectionTitle('Automation'),
            Card(child: Column(children: [
              ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('Scheduled Cleanup'),
                subtitle: const Text('Auto-scan and delete duplicates'),
                trailing: DropdownButton<ScheduleFrequency>(
                  value: settings.scheduleFrequency,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: ScheduleFrequency.none, child: Text('Off')),
                    DropdownMenuItem(value: ScheduleFrequency.daily, child: Text('Daily')),
                    DropdownMenuItem(value: ScheduleFrequency.weekly, child: Text('Weekly')),
                    DropdownMenuItem(value: ScheduleFrequency.monthly, child: Text('Monthly')),
                  ],
                  onChanged: (v) =>
                      ctx.read<SettingsBloc>().add(ScheduleCleanupEvent(v!)),
                ),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.download_outlined),
                title: const Text('Watch Downloads for Duplicates'),
                subtitle: const Text('Alert instantly when a downloaded file already exists on your device'),
                value: settings.notifyOnNewDuplicate,
                onChanged: (v) => _update(ctx, settings.copyWith(notifyOnNewDuplicate: v)),
                isThreeLine: true,
              ),
              SwitchListTile(
                secondary: const Icon(Icons.share_outlined),
                title: const Text('Auto-delete after social post'),
                subtitle: const Text('Delete device copy after posting to WhatsApp, Facebook, Instagram, TikTok'),
                value: settings.autoDeleteAfterPost,
                onChanged: (v) => _update(ctx, settings.copyWith(autoDeleteAfterPost: v)),
                isThreeLine: true,
              ),
            ])),

            const SizedBox(height: 16),

            // ── OFFLINE / CONNECTIVITY ───────────────────────────────
            _SectionTitle('Connectivity'),
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.wifi_off_rounded, color: cs.secondary, size: 20),
                  const SizedBox(width: 8),
                  Text('Offline-First Design',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 10),
                _FeatureRow('✓', 'All scanning works without internet'),
                _FeatureRow('✓', 'File deletion works offline'),
                _FeatureRow('✓', 'Storage alerts work offline'),
                _FeatureRow('✓', 'Download watcher works offline'),
                _FeatureRow('✓', 'All settings & history stored locally'),
                const Divider(height: 20),
                _FeatureRow('☁', 'Cloud scan needs internet (Pro)'),
                _FeatureRow('☁', 'Cross-device sync needs internet (Pro)'),
                _FeatureRow('☁', 'App updates via store only'),
              ]),
            )),

            const SizedBox(height: 16),

            // ── ACCOUNT ──────────────────────────────────────────────
            _SectionTitle('Account'),
            Card(child: Column(children: [
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: const Text('Upgrade to Pro'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => context.go('/premium'),
              ),
              const Divider(height: 1, indent: 16),
              BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
                if (state is AuthAuthenticated) {
                  return ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign Out'),
                    onTap: () => ctx.read<AuthBloc>().add(SignOutEvent()),
                  );
                }
                return ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Sign In'),
                  onTap: () => context.go('/auth'),
                );
              }),
            ])),

            const SizedBox(height: 24),

            // ── ABOUT / DEVELOPER CREDIT ─────────────────────────────
            _SectionTitle('About'),
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.deblur, color: cs.onPrimary, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('DupZero',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    Text('Version 1.1.0',
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                  ]),
                ]),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 10),
                Row(children: [
                  Icon(Icons.person_outline, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  const Text('Developer', style: TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text('Tavoo',
                    style: TextStyle(
                      color: cs.primary, fontWeight: FontWeight.w800, fontSize: 15)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.code_outlined, size: 18, color: cs.onSurfaceVariant),
                  const SizedBox(width: 8),
                  const Text('Built with Flutter'),
                  const Spacer(),
                  Text('Android · iOS · Windows · macOS',
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                ]),
              ]),
            )),

            const SizedBox(height: 32),
          ]);
        },
      ),
    );
  }

  void _update(BuildContext ctx, UserSettings settings) =>
      ctx.read<SettingsBloc>().add(UpdateSettingsEvent(settings));
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        )),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String icon, text;
  const _FeatureRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Text(icon, style: TextStyle(
          color: icon == '✓'
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        )),
        const SizedBox(width: 8),
        Expanded(child: Text(text,
          style: TextStyle(fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface))),
      ]),
    );
  }
}
