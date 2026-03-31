import 'package:equatable/equatable.dart';

enum FileCategory { image, video, audio, document, other }
enum FileSource { local, googleDrive, oneDrive, iCloud }

class DuplicateFile extends Equatable {
  final String id;
  final String path;
  final String name;
  final int size;
  final String? hash;
  final DateTime modifiedAt;
  final DateTime? createdAt;
  final FileSource source;
  final bool isSelectedForDeletion;
  final bool isKeepFile;
  final String? thumbnailPath;
  final String? mimeType;

  const DuplicateFile({
    required this.id,
    required this.path,
    required this.name,
    required this.size,
    this.hash,
    required this.modifiedAt,
    this.createdAt,
    required this.source,
    this.isSelectedForDeletion = false,
    this.isKeepFile = false,
    this.thumbnailPath,
    this.mimeType,
  });

  DuplicateFile copyWith({
    String? id, String? path, String? name, int? size, String? hash,
    DateTime? modifiedAt, DateTime? createdAt, FileSource? source,
    bool? isSelectedForDeletion, bool? isKeepFile,
    String? thumbnailPath, String? mimeType,
  }) => DuplicateFile(
    id: id ?? this.id, path: path ?? this.path, name: name ?? this.name,
    size: size ?? this.size, hash: hash ?? this.hash,
    modifiedAt: modifiedAt ?? this.modifiedAt, createdAt: createdAt ?? this.createdAt,
    source: source ?? this.source,
    isSelectedForDeletion: isSelectedForDeletion ?? this.isSelectedForDeletion,
    isKeepFile: isKeepFile ?? this.isKeepFile,
    thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    mimeType: mimeType ?? this.mimeType,
  );

  String get sizeFormatted {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)}GB';
  }

  @override
  List<Object?> get props => [id, path, name, size, hash, modifiedAt, source, isSelectedForDeletion];
}
