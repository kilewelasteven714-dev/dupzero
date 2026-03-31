import '../repositories/scan_repository.dart';

class StartScanUseCase {
  final ScanRepository _repo;
  StartScanUseCase(this._repo);

  Stream<ScanProgress> call({required List<String> paths, bool detectSimilar = true}) =>
      _repo.scanLocalFiles(paths: paths, detectSimilar: detectSimilar);
}
