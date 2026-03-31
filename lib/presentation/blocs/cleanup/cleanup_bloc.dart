import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/duplicate_file.dart';
import '../../../domain/entities/duplicate_group.dart';
import '../../../domain/usecases/delete_duplicates_usecase.dart';

part 'cleanup_event.dart';
part 'cleanup_state.dart';

class CleanupBloc extends Bloc<CleanupEvent, CleanupState> {
  final DeleteDuplicatesUseCase _deleteUseCase;

  CleanupBloc({required DeleteDuplicatesUseCase deleteUseCase})
      : _deleteUseCase = deleteUseCase, super(CleanupInitial()) {
    on<ToggleFileSelectionEvent>(_onToggle);
    on<SelectAllInGroupEvent>(_onSelectAll);
    on<AutoSelectOldestEvent>(_onAutoSelect);
    on<DeleteSelectedEvent>(_onDelete);
    on<LoadGroupsEvent>(_onLoad);
  }

  void _onLoad(LoadGroupsEvent e, Emitter<CleanupState> emit) {
    emit(CleanupReady(groups: e.groups, selectedFiles: const {}));
  }

  void _onToggle(ToggleFileSelectionEvent e, Emitter<CleanupState> emit) {
    if (state is! CleanupReady) return;
    final s = state as CleanupReady;
    final selected = Map<String, bool>.from(s.selectedFiles);
    selected[e.fileId] = !(selected[e.fileId] ?? false);
    emit(s.copyWith(selectedFiles: selected));
  }

  void _onSelectAll(SelectAllInGroupEvent e, Emitter<CleanupState> emit) {
    if (state is! CleanupReady) return;
    final s = state as CleanupReady;
    final selected = Map<String, bool>.from(s.selectedFiles);
    // Select all except the keep file (first/newest)
    for (int i = 1; i < e.group.files.length; i++) {
      selected[e.group.files[i].id] = true;
    }
    emit(s.copyWith(selectedFiles: selected));
  }

  void _onAutoSelect(AutoSelectOldestEvent e, Emitter<CleanupState> emit) {
    if (state is! CleanupReady) return;
    final s = state as CleanupReady;
    final selected = Map<String, bool>.from(s.selectedFiles);
    for (final group in s.groups) {
      final sorted = List<DuplicateFile>.from(group.files)
        ..sort((a, b) => a.modifiedAt.compareTo(b.modifiedAt));
      // Keep the newest, select the rest
      for (int i = 0; i < sorted.length - 1; i++) {
        selected[sorted[i].id] = true;
      }
    }
    emit(s.copyWith(selectedFiles: selected));
  }

  Future<void> _onDelete(DeleteSelectedEvent e, Emitter<CleanupState> emit) async {
    if (state is! CleanupReady) return;
    final s = state as CleanupReady;
    final toDelete = s.groups
        .expand((g) => g.files)
        .where((f) => s.selectedFiles[f.id] == true)
        .toList();

    if (toDelete.isEmpty) return;

    emit(CleanupDeleting(count: toDelete.length));
    final result = await _deleteUseCase(toDelete);
    result.fold(
      (f) => emit(CleanupError(f.message)),
      (freed) => emit(CleanupSuccess(freedBytes: freed, deletedCount: toDelete.length)),
    );
  }
}
