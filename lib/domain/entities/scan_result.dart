import "package:equatable/equatable.dart";
import "duplicate_file.dart";
import "duplicate_group.dart";

class ScanResult extends Equatable {
  final String id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final List<DuplicateGroup> groups;
  final int totalFilesScanned;
  final int totalDuplicates;
  final int totalWastedSpace;
  final int spaceSaved;
  final bool isComplete;

  const ScanResult({
    required this.id, required this.startedAt, this.completedAt,
    required this.groups, required this.totalFilesScanned,
    required this.totalDuplicates, required this.totalWastedSpace,
    this.spaceSaved = 0, this.isComplete = false,
  });

  ScanResult copyWith({
    String? id, DateTime? startedAt, DateTime? completedAt,
    List<DuplicateGroup>? groups, int? totalFilesScanned,
    int? totalDuplicates, int? totalWastedSpace, int? spaceSaved, bool? isComplete,
  }) => ScanResult(
    id: id ?? this.id, startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    groups: groups ?? this.groups, totalFilesScanned: totalFilesScanned ?? this.totalFilesScanned,
    totalDuplicates: totalDuplicates ?? this.totalDuplicates,
    totalWastedSpace: totalWastedSpace ?? this.totalWastedSpace,
    spaceSaved: spaceSaved ?? this.spaceSaved, isComplete: isComplete ?? this.isComplete,
  );

  Map<FileCategory, List<DuplicateGroup>> get groupedByCategory {
    final map = <FileCategory, List<DuplicateGroup>>{};
    for (final g in groups) { map.putIfAbsent(g.category, () => []).add(g); }
    return map;
  }

  String _fmt(int b) {
    if (b < 1024) return "${b}B";
    if (b < 1048576) return "${(b/1024).toStringAsFixed(1)}KB";
    if (b < 1073741824) return "${(b/1048576).toStringAsFixed(1)}MB";
    return "${(b/1073741824).toStringAsFixed(2)}GB";
  }
  String get totalWastedFormatted => _fmt(totalWastedSpace);
  String get spaceSavedFormatted => _fmt(spaceSaved);

  @override
  List<Object?> get props => [id, startedAt, groups, totalFilesScanned, totalDuplicates, totalWastedSpace];
}