import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/storage_alert_service.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc() : super(StorageInitial()) {
    on<LoadStorageEvent>(_onLoad);
    on<CheckStorageAlertEvent>(_onCheck);
    on<RefreshStorageEvent>(_onRefresh);
  }

  Future<void> _onLoad(LoadStorageEvent e, Emitter<StorageState> emit) async {
    emit(StorageLoading());
    final info = await StorageAlertService.getStorageInfo();
    emit(StorageLoaded(info: info));
    // Auto-check for alert when loaded
    await StorageAlertService.checkAndAlert();
  }

  Future<void> _onCheck(CheckStorageAlertEvent e, Emitter<StorageState> emit) async {
    final alerted = await StorageAlertService.checkAndAlert();
    if (state is StorageLoaded) {
      emit((state as StorageLoaded).copyWith(alertFired: alerted));
    }
  }

  Future<void> _onRefresh(RefreshStorageEvent e, Emitter<StorageState> emit) async {
    final info = await StorageAlertService.getStorageInfo();
    emit(StorageLoaded(info: info));
    await StorageAlertService.checkAndAlert();
  }
}
