part of 'cleanup_bloc.dart';

abstract class CleanupEvent extends Equatable {
  const CleanupEvent();
  @override List<Object?> get props => [];
}

class LoadGroupsEvent extends CleanupEvent {
  final List<DuplicateGroup> groups;
  const LoadGroupsEvent(this.groups);
  @override List<Object?> get props => [groups];
}

class ToggleFileSelectionEvent extends CleanupEvent {
  final String fileId;
  const ToggleFileSelectionEvent(this.fileId);
  @override List<Object?> get props => [fileId];
}

class SelectAllInGroupEvent extends CleanupEvent {
  final DuplicateGroup group;
  const SelectAllInGroupEvent(this.group);
  @override List<Object?> get props => [group.id];
}

class AutoSelectOldestEvent extends CleanupEvent {}
class DeleteSelectedEvent extends CleanupEvent {}
