import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Prompts user to rate app at right moment
/// Shows after: 5 scans, 3 days of use, 10 files deleted
/// Developed by Tavoo — DupZero
class RatingService {
  static const _keyScansCount     = 'rating_scans_count';
  static const _keyDeletedCount   = 'rating_deleted_count';
  static const _keyFirstUse       = 'rating_first_use';
  static const _keyRatingShown    = 'rating_shown';
  static const _keyNeverAsk       = 'rating_never_ask';

  static Future<void> recordScan() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_keyScansCount) ?? 0) + 1;
    await prefs.setInt(_keyScansCount, count);
    if (prefs.getString(_keyFirstUse) == null) {
      await prefs.setString(_keyFirstUse, DateTime.now().toIso8601String());
    }
  }

  static Future<void> recordDeletion(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final total = (prefs.getInt(_keyDeletedCount) ?? 0) + count;
    await prefs.setInt(_keyDeletedCount, total);
  }

  static Future<bool> shouldShowRating() async {
    final prefs = await SharedPreferences.getInstance();

    // Never show if user said no
    if (prefs.getBool(_keyNeverAsk) ?? false) return false;

    // Never show twice
    if (prefs.getBool(_keyRatingShown) ?? false) return false;

    final scans   = prefs.getInt(_keyScansCount) ?? 0;
    final deleted = prefs.getInt(_keyDeletedCount) ?? 0;
    final firstUse = prefs.getString(_keyFirstUse);

    // Need: 5+ scans AND 3+ days AND 10+ files deleted
    if (scans < 5) return false;
    if (deleted < 10) return false;
    if (firstUse != null) {
      final days = DateTime.now()
        .difference(DateTime.parse(firstUse)).inDays;
      if (days < 3) return false;
    }

    return true;
  }

  static Future<void> showRatingDialog(BuildContext context) async {
    final should = await shouldShowRating();
    if (!should || !context.mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRatingShown, true);

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Text('⭐', style: TextStyle(fontSize: 40)),
        title: const Text('Je, Unapenda DupZero?',
          style: TextStyle(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center),
        content: const Text(
          'Tafadhali tuambie maoni yako kwenye Google Play. '
          'Itatusaidia kuimarisha app na kusaidia watu wengine.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await prefs.setBool(_keyNeverAsk, true);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Hapana Asante'),
          ),
          TextButton(
            onPressed: () {
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Baadaye'),
          ),
          FilledButton(
            onPressed: () {
              // Opens Play Store rating page
              // launchUrl(Uri.parse('market://details?id=com.tavoo.dupzero'));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('⭐ Kipa Rating'),
          ),
        ],
      ),
    );
  }
}
