part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final Color colorSeed;
  final String colorName;

  const ThemeState({required this.themeMode, required this.colorSeed, required this.colorName});

  factory ThemeState.initial() => ThemeState(
    themeMode: ThemeMode.system,
    colorSeed: AppColorThemes.defaultColor,
    colorName: AppColorThemes.defaultTheme,
  );

  ThemeState copyWith({ThemeMode? themeMode, Color? colorSeed, String? colorName}) =>
    ThemeState(
      themeMode: themeMode ?? this.themeMode,
      colorSeed: colorSeed ?? this.colorSeed,
      colorName: colorName ?? this.colorName,
    );

  @override List<Object?> get props => [themeMode, colorSeed, colorName];
}
