import 'dart:io';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import '../constants/app_constants.dart';
import 'hash_service.dart';
import '../../domain/entities/duplicate_file.dart';
import '../../domain/entities/duplicate_group.dart';
import '../../domain/repositories/scan_repository.dart';

class FileScannerService {
  final HashService _hashService;
  static const _uuid = Uuid();
  FileScannerService(this._hashService);

  Stream<ScanProgress> scanPaths(List<String> paths, {bool detectSimilar = true}) async* {
    final allFiles = <File>[];
    for (final path in paths) {
      final dir = Directory(path);
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is File) allFiles.add(entity);
        }
      }
    }
    final total = allFiles.length;
    final hashMap = <String, List<DuplicateFile>>{};
    final groups = <DuplicateGroup>[];
    int scanned = 0;

    for (final file in allFiles) {
      scanned++;
      final fileName = p.basename(file.path);
      try {
        final stat = await file.stat();
        final mime = lookupMimeType(file.path);
        final hash = await _hashService.computeSha256(file.path);
        final dupFile = DuplicateFile(
          id: _uuid.v4(), path: file.path, name: fileName,
          size: stat.size, hash: hash, modifiedAt: stat.modified,
          source: FileSource.local, mimeType: mime,
        );
        hashMap.putIfAbsent(hash, () => []).add(dupFile);
      } catch (e, stack) { debugPrint('Error: $e'); }
      if (scanned % 10 == 0 || scanned == total) {
        yield ScanProgress(scanned: scanned, total: total, currentFile: fileName, groupsFound: List.from(groups));
      }
    }

    for (final entry in hashMap.entries) {
      if (entry.value.length > 1) {
        final ts = entry.value.fold(0, (s, f) => s + f.size);
        final cat = _cat(entry.value.first.mimeType);
        groups.add(DuplicateGroup(
          id: _uuid.v4(), files: entry.value, category: cat,
          duplicateType: DuplicateType.exact,
          totalSize: ts, wastedSpace: ts - entry.value.first.size,
          detectedAt: DateTime.now(),
        ));
      }
    }
    yield ScanProgress(scanned: total, total: total, currentFile: '', groupsFound: groups, isComplete: true);
  }

  FileCategory _cat(String? mime) {
    if (mime == null) return FileCategory.other;
    if (mime.startsWith('image/')) return FileCategory.image;
    if (mime.startsWith('video/')) return FileCategory.video;
    if (mime.startsWith('audio/')) return FileCategory.audio;
    if (mime.contains('pdf') || mime.contains('document') || mime.contains('text')) return FileCategory.document;
    return FileCategory.other;
  }
}
