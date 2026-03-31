import 'package:dartz/dartz.dart';
import '../entities/duplicate_file.dart';
import '../../core/errors/failures.dart';

abstract class FileRepository {
  Future<Either<Failure, Unit>> deleteFile(DuplicateFile file);
  Future<Either<Failure, Unit>> deleteFiles(List<DuplicateFile> files);
  Future<Either<Failure, int>> getTotalStorageSpace();
  Future<Either<Failure, int>> getFreeStorageSpace();
  Future<Either<Failure, String>> getFileHash(String path);
  Future<Either<Failure, List<int>>> computePerceptualHash(String imagePath);
  Future<Either<Failure, Unit>> moveToTrash(DuplicateFile file);
  Future<Either<Failure, Unit>> restoreFromTrash(String fileId);
}
