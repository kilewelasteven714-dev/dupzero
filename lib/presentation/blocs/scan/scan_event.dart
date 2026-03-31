part of 'scan_bloc.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();
  @override List<Object?> get props => [];
}

class StartScanEvent extends ScanEvent {
  final List<String> paths;
  final bool detectSimilar;
  const StartScanEvent({required this.paths, this.detectSimilar = true});
  @override List<Object?> get props => [paths, detectSimilar];
}

class ScanProgressUpdatedEvent extends ScanEvent {
  final ScanProgress progress;
  const ScanProgressUpdatedEvent(this.progress);
  @override List<Object?> get props => [progress];
}

class ScanCompletedEvent extends ScanEvent {
  final String scanId;
  const ScanCompletedEvent(this.scanId);
  @override List<Object?> get props => [scanId];
}

class ScanErrorEvent extends ScanEvent {
  final String message;
  const ScanErrorEvent(this.message);
  @override List<Object?> get props => [message];
}

class CancelScanEvent extends ScanEvent {}
class LoadScanHistoryEvent extends ScanEvent {}
