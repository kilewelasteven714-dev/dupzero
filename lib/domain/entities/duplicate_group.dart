import 'package:equatable/equatable.dart';
import 'duplicate_file.dart';

enum DuplicateType { exact, similar }

class DuplicateGroup extends Equatable {
  final String id;
  final List<DuplicateFile> files;
  final FileCategory category;
  final DuplicateType duplicateType;
  final int totalSize;
  final int wastedSpace;
  final DateTime detectedAt;

  const DuplicateGroup({
    required this.id,
    required this.files,
    required this.category,
    required this.duplicateType,
    required this.totalSize,
    required this.wastedSpace,
    required this.detectedAt,
  });

  DuplicateGroup copyWith({
    String? id, List<DuplicateFile>? files, FileCategory? category,
    DuplicateType? duplicateType, int? totalSize, int? wastedSpace, DateTime? detectedAt,
  }) => DuplicateGroup(
    id: id ?? this.id, files: files ?? this.files, category: category ?? this.category,
    duplicateType: duplicateType ?? this.duplicateType, totalSize: totalSize ?? this.totalSize,
    wastedSpace: wastedSpace ?? this.wastedSpace, detectedAt: detectedAt ?? this.detectedAt,
  );

  int get selectedForDeletionCount => files.where((f) => f.isSelectedForDeletion).length;
  int get potentialSavings => files
    .where((f) => f.isSelectedForDeletion)
    .fold(0, (sum, f) => sum + f.size);

  @override
  List<Object?> get props => [id, files, category, duplicateType, totalSize, wastedSpace, detectedAt];
}
