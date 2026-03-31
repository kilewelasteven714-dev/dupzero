part of 'cleanup_bloc.dart';

abstract class CleanupState extends Equatable {
  const CleanupState();
  @override List<Object?> get props => [];
}

class CleanupInitial extends CleanupState {}

class CleanupReady extends CleanupState {
  final List<DuplicateGroup> groups;
  final Map<String, bool> selectedFiles;

  const CleanupReady({required this.groups, required this.selectedFiles});

  CleanupReady copyWith({List<DuplicateGroup>? groups, Map<String, bool>? selectedFiles}) =>
      CleanupReady(groups: groups ?? this.groups, selectedFiles: selectedFiles ?? this.selectedFiles);

  int get selectedCount => selectedFiles.values.where((v) => v).length;
  int get totalPotentialSavings {
    final selectedIds = selectedFiles.entries.where((e) => e.value).map((e) => e.key).toSet();
    return groups
        .expand((g) => g.files)
        .where((f) => selectedIds.contains(f.id))
        .fold(0, (s, f) => s + f.size);
  }

  @override List<Object?> get props => [groups, selectedFiles];
}

class CleanupDeleting extends CleanupState {
  final int count;
  const CleanupDeleting({required this.count});
  @override List<Object?> get props => [count];
}

class CleanupSuccess extends CleanupState {
  final int freedBytes, deletedCount;
  const CleanupSuccess({required this.freedBytes, required this.deletedCount});
  @override List<Object?> get props => [freedBytes, deletedCount];
}

class CleanupError extends CleanupState {
  final String message;
  const CleanupError(this.message);
  @override List<Object?> get props => [message];
}
