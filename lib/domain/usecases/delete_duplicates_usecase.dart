import 'package:dartz/dartz.dart';
import '../repositories/file_repository.dart';
import '../entities/duplicate_file.dart';
import '../../core/errors/failures.dart';

class DeleteDuplicatesUseCase {
  final FileRepository _repo;
  DeleteDuplicatesUseCase(this._repo);

  Future<Either<Failure, int>> call(List<DuplicateFile> files) async {
    int freed = 0;
    for (final file in files) {
      final result = await _repo.deleteFile(file);
      result.fold((_) => null, (_) => freed += file.size);
    }
    return Right(freed);
  }
}
