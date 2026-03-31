import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'hash_service.dart';
import 'storage_alert_service.dart';

/// Watches download folders in real-time.
/// When a new file appears, it computes its hash and checks against known hashes.
/// If a match is found the user is alerted immediately.
/// This service is OFFLINE — it never needs internet.
class DownloadWatcherService {
  final HashService _hashService;
  final Map<String, String> _knownHashes = {}; // hash -> existing path
  final List<StreamSubscription<FileSystemEvent>> _watchers = [];
  bool _isRunning = false;

  DownloadWatcherService(this._hashService);

  bool get isRunning => _isRunning;

  // ── Start watching ────────────────────────────────────────────
  Future<void> start(List<String> basePaths) async {
    if (_isRunning) return;
    _isRunning = true;

    // Pre-build hash index from existing files
    await _buildHashIndex(basePaths);

    // Watch each download path for new files
    for (final base in basePaths) {
      for (final sub in AppConstants.watchedDownloadPaths) {
        final dir = Directory(p.join(base, sub));
        if (!await dir.exists()) continue;

        try {
          final sub_ = dir.watch(events: FileSystemEvent.create).listen((event) {
            _onNewFile(event.path);
          });
          _watchers.add(sub_);
        } catch (e) { debugPrint('DownloadWatcher: $e'); }
      }
    }
  }

  // ── Stop watching ─────────────────────────────────────────────
  Future<void> stop() async {
    for (final w in _watchers) { await w.cancel(); }
    _watchers.clear();
    _isRunning = false;
  }

  // ── Build hash index from existing files ──────────────────────
  Future<void> _buildHashIndex(List<String> basePaths) async {
    for (final base in basePaths) {
      final dir = Directory(base);
      if (!await dir.exists()) continue;
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is! File) continue;
        try {
          final hash = await _hashService.computeSha256(entity.path);
          _knownHashes[hash] = entity.path;
        } catch (e) { debugPrint('DownloadWatcher: $e'); }
      }
    }
  }

  // ── Handle new file event ─────────────────────────────────────
  Future<void> _onNewFile(String newFilePath) async {
    // Small delay to ensure file is fully written
    await Future.delayed(const Duration(milliseconds: 500));

    final file = File(newFilePath);
    if (!await file.exists()) return;

    try {
      final hash = await _hashService.computeSha256(newFilePath);
      if (_knownHashes.containsKey(hash)) {
        final existingPath = _knownHashes[hash]!;
        if (existingPath != newFilePath) {
          // DUPLICATE FOUND — alert the user immediately
          await StorageAlertService.showDuplicateDownloadAlert(
            fileName: p.basename(newFilePath),
            existingPath: existingPath,
          );
        }
      } else {
        // New unique file — add to index
        _knownHashes[hash] = newFilePath;
      }
    } catch (e) { debugPrint('DownloadWatcher: $e'); }
  }

  // ── Add a file to the known index (called after each scan) ────
  void indexFile(String path, String hash) {
    _knownHashes[hash] = path;
  }

  void clearIndex() => _knownHashes.clear();
}
