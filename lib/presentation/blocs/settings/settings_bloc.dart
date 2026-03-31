import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_settings.dart';
import '../../../domain/repositories/settings_repository.dart';
import '../../../domain/usecases/get_settings_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase _getSettings;
  final SaveSettingsUseCase _saveSettings;
  final SettingsRepository _repo;

  SettingsBloc({
    required GetSettingsUseCase getSettings,
    required SaveSettingsUseCase saveSettings,
    required SettingsRepository repo,
  }) : _getSettings = getSettings, _saveSettings = saveSettings, _repo = repo,
       super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoad);
    on<UpdateSettingsEvent>(_onUpdate);
    on<ScheduleCleanupEvent>(_onSchedule);
  }

  Future<void> _onLoad(LoadSettingsEvent e, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final r = await _getSettings();
    r.fold((f) => emit(SettingsError(f.message)), (s) => emit(SettingsLoaded(s)));
  }

  Future<void> _onUpdate(UpdateSettingsEvent e, Emitter<SettingsState> emit) async {
    await _saveSettings(e.settings);
    emit(SettingsLoaded(e.settings));
  }

  Future<void> _onSchedule(ScheduleCleanupEvent e, Emitter<SettingsState> emit) async {
    await _repo.scheduleCleanup(e.frequency);
    if (state is SettingsLoaded) {
      final s = (state as SettingsLoaded).settings.copyWith(scheduleFrequency: e.frequency);
      await _saveSettings(s);
      emit(SettingsLoaded(s));
    }
  }
}
