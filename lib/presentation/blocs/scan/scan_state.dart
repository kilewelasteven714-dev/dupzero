part of 'scan_bloc.dart';

abstract class ScanState extends Equatable {
  const ScanState();
  @override List<Object?> get props => [];
}

class ScanInitial extends ScanState {}

class ScanInProgress extends ScanState {
  final int scanned, total, groupsFound;
  final String currentFile;
  final List<DuplicateGroup> liveGroups;

  const ScanInProgress({
    required this.scanned,
    required this.total,
    required this.currentFile,
    required this.groupsFound,
    this.liveGroups = const [],
  });

  @override
  List<Object?> get props => [scanned, total, currentFile, groupsFound];
}

class ScanComplete extends ScanState {
  final ScanResult result;
  const ScanComplete(this.result);
  @override List<Object?> get props => [result];
}

class ScanError extends ScanState {
  final String message;
  const ScanError(this.message);
  @override List<Object?> get props => [message];
}

class ScanHistoryLoaded extends ScanState {
  final List<ScanResult> history;
  const ScanHistoryLoaded(this.history);
  @override List<Object?> get props => [history];
}
