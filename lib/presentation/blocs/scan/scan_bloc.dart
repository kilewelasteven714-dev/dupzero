import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/duplicate_group.dart';
import '../../../domain/entities/scan_result.dart';
import '../../../domain/usecases/start_scan_usecase.dart';
import '../../../domain/usecases/get_scan_history_usecase.dart';
import '../../../domain/repositories/scan_repository.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final StartScanUseCase startScan;
  final GetScanHistoryUseCase getHistory;
  StreamSubscription<ScanProgress>? _sub;
  static const _uuid = Uuid();

  ScanBloc({required this.startScan, required this.getHistory})
      : super(ScanInitial()) {
    on<StartScanEvent>(_onStart);
    on<ScanProgressUpdatedEvent>(_onProgress);
    on<ScanCompletedEvent>(_onComplete);
    on<ScanErrorEvent>(_onError);
    on<CancelScanEvent>(_onCancel);
    on<LoadScanHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onStart(StartScanEvent e, Emitter<ScanState> emit) async {
    await _sub?.cancel();
    final scanId = _uuid.v4();
    final stream = startScan(StartScanParams(
        paths: e.paths, detectSimilar: e.detectSimilar));

    emit(const ScanInProgress(
        scanned: 0, total: 0, currentFile: 'Starting...', groupsFound: 0));

    _sub = stream.listen(
      (progress) => add(ScanProgressUpdatedEvent(progress)),
      onError: (e) => add(ScanErrorEvent(e.toString())),
      onDone: () => add(ScanCompletedEvent(scanId)),
    );
  }

  void _onProgress(ScanProgressUpdatedEvent e, Emitter<ScanState> emit) {
    final p = e.progress;
    if (p.isComplete) {
      add(ScanCompletedEvent(_uuid.v4()));
      return;
    }
    emit(ScanInProgress(
      scanned: p.scanned,
      total: p.total,
      currentFile: p.currentFile,
      groupsFound: p.groupsFound.length,
      liveGroups: p.groupsFound,
    ));
  }

  Future<void> _onComplete(ScanCompletedEvent e, Emitter<ScanState> emit) async {
    await _sub?.cancel();
    final current = state;
    final groups = current is ScanInProgress ? current.liveGroups : <DuplicateGroup>[];
    final result = ScanResult(
      id: e.scanId,
      startedAt: DateTime.now().subtract(const Duration(minutes: 1)),
      completedAt: DateTime.now(),
      groups: groups,
      totalFilesScanned: current is ScanInProgress ? current.scanned : 0,
      totalDuplicates: groups.fold(0, (s, g) => s + g.files.length - 1),
      totalWastedSpace: groups.fold(0, (s, g) => s + g.wastedSpace),
      isComplete: true,
    );
    emit(ScanComplete(result));
  }

  void _onError(ScanErrorEvent e, Emitter<ScanState> emit) {
    emit(ScanError(e.message));
  }

  Future<void> _onCancel(CancelScanEvent e, Emitter<ScanState> emit) async {
    await _sub?.cancel();
    emit(ScanInitial());
  }

  Future<void> _onLoadHistory(LoadScanHistoryEvent e, Emitter<ScanState> emit) async {
    final result = await getHistory();
    result.fold(
      (f) => emit(ScanError(f.toString())),
      (history) => emit(ScanHistoryLoaded(history)),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
