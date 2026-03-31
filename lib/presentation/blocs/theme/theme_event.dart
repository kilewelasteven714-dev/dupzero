part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override List<Object?> get props => [];
}

class LoadThemeEvent extends ThemeEvent {}
class ChangeThemeModeEvent extends ThemeEvent {
  final ThemeMode mode;
  const ChangeThemeModeEvent(this.mode);
  @override List<Object?> get props => [mode];
}
class ChangeColorSeedEvent extends ThemeEvent {
  final String colorName;
  const ChangeColorSeedEvent(this.colorName);
  @override List<Object?> get props => [colorName];
}
