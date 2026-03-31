import 'package:dartz/dartz.dart';
import '../entities/scan_result.dart';
import '../entities/duplicate_group.dart';
import '../../core/errors/failures.dart';

abstract class ScanRepository {
  Stream<ScanProgress> scanLocalFiles({required List<String> paths, required bool detectSimilar});
  Stream<ScanProgress> scanCloudStorage({required CloudProvider provider, required String accessToken});
  Future<Either<Failure, ScanResult>> finalizeScan(String scanId);
  Future<Either<Failure, List<ScanResult>>> getScanHistory();
  Future<Either<Failure, Unit>> deleteScanHistory(String scanId);
}

enum CloudProvider { googleDrive, oneDrive, iCloud }

class ScanProgress {
  final int scanned, total;
  final String currentFile;
  final List<DuplicateGroup> groupsFound;
  final bool isComplete;
  final String? error;

  const ScanProgress({
    required this.scanned, required this.total, required this.currentFile,
    required this.groupsFound, this.isComplete = false, this.error,
  });

  double get percentage => total == 0 ? 0 : scanned / total;
  int get totalDuplicates => groupsFound.fold(0, (s, g) => s + g.files.length - 1);
  int get totalWastedSpace => groupsFound.fold(0, (s, g) => s + g.wastedSpace);
}
