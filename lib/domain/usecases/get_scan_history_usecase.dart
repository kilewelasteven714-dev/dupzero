import 'package:dartz/dartz.dart';
import '../repositories/scan_repository.dart';
import '../entities/scan_result.dart';
import '../../core/errors/failures.dart';

class GetScanHistoryUseCase {
  final ScanRepository _repo;
  GetScanHistoryUseCase(this._repo);

  Future<Either<Failure, List<ScanResult>>> call() => _repo.getScanHistory();
}
