import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/failures.dart';
import '../../core/services/file_scanner_service.dart';
import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  final FileScannerService _scanner;
  static const _uuid = Uuid();
  final List<ScanResult> _history = [];

  ScanRepositoryImpl(this._scanner);

  @override
  Stream<ScanProgress> scanLocalFiles({
    required List<String> paths,
    required bool detectSimilar,
  }) =>
      _scanner.scanPaths(paths, detectSimilar: detectSimilar);

  @override
  Stream<ScanProgress> scanCloudStorage({
    required CloudProvider provider,
    required String accessToken,
  }) async* {
    yield const ScanProgress(
        scanned: 0, total: 1, currentFile: 'Connecting...', groupsFound: []);
    await Future.delayed(const Duration(seconds: 1));
    yield const ScanProgress(
        scanned: 1,
        total: 1,
        currentFile: '',
        groupsFound: [],
        isComplete: true);
  }

  @override
  Future<Either<Failure, ScanResult>> finalizeScan(String scanId) async {
    return Right(ScanResult(
      id: scanId,
      startedAt: DateTime.now(),
      completedAt: DateTime.now(),
      groups: [],
      totalFilesScanned: 0,
      totalDuplicates: 0,
      totalWastedSpace: 0,
      isComplete: true,
    ));
  }

  @override
  Future<Either<Failure, List<ScanResult>>> getScanHistory() async =>
      Right(List.from(_history));

  @override
  Future<Either<Failure, Unit>> deleteScanHistory(String scanId) async {
    _history.removeWhere((s) => s.id == scanId);
    return const Right(unit);
  }
}
