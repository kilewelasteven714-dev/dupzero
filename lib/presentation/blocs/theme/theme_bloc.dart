import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences _prefs;

  ThemeBloc(this._prefs) : super(ThemeState.initial()) {
    on<LoadThemeEvent>(_onLoad);
    on<ChangeThemeModeEvent>(_onChangeMode);
    on<ChangeColorSeedEvent>(_onChangeSeed);
  }

  void _onLoad(LoadThemeEvent event, Emitter<ThemeState> emit) {
    final modeIdx = _prefs.getInt(AppConstants.themeKey) ?? ThemeMode.system.index;
    final colorName = _prefs.getString(AppConstants.colorSeedKey) ?? 'Blue Pulse';
    final color = AppColorThemes.themes[colorName] ?? AppColorThemes.defaultColor;
    emit(state.copyWith(themeMode: ThemeMode.values[modeIdx], colorSeed: color, colorName: colorName));
  }

  Future<void> _onChangeMode(ChangeThemeModeEvent event, Emitter<ThemeState> emit) async {
    await _prefs.setInt(AppConstants.themeKey, event.mode.index);
    emit(state.copyWith(themeMode: event.mode));
  }

  Future<void> _onChangeSeed(ChangeColorSeedEvent event, Emitter<ThemeState> emit) async {
    await _prefs.setString(AppConstants.colorSeedKey, event.colorName);
    final color = AppColorThemes.themes[event.colorName] ?? AppColorThemes.defaultColor;
    emit(state.copyWith(colorSeed: color, colorName: event.colorName));
  }
}
