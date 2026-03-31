import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/services/hash_service.dart';
import '../../domain/entities/duplicate_file.dart';
import '../../domain/repositories/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final HashService _hashService;
  FileRepositoryImpl(this._hashService);

  @override
  Future<Either<Failure, Unit>> deleteFile(DuplicateFile file) async {
    try {
      if (file.source == FileSource.local) {
        final f = File(file.path);
        if (await f.exists()) await f.delete();
      }
      return const Right(unit);
    } catch (e) {
      return Left(LocalFailure('Failed to delete ${file.name}: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFiles(List<DuplicateFile> files) async {
    for (final f in files) {
      final r = await deleteFile(f);
      if (r.isLeft()) return r;
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, int>> getTotalStorageSpace() async =>
      const Right(64 * 1024 * 1024 * 1024);

  @override
  Future<Either<Failure, int>> getFreeStorageSpace() async =>
      const Right(22 * 1024 * 1024 * 1024);

  @override
  Future<Either<Failure, String>> getFileHash(String path) async {
    try {
      return Right(await _hashService.computeSha256(path));
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<int>>> computePerceptualHash(
      String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      return Right(await _hashService.computePerceptualHash(bytes));
    } catch (e) {
      return Left(LocalFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> moveToTrash(DuplicateFile file) =>
      deleteFile(file);

  @override
  Future<Either<Failure, Unit>> restoreFromTrash(String fileId) async =>
      const Right(unit);
}
