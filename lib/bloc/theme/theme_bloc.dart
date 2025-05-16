import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'isDarkMode';

  ThemeBloc() : super(const ThemeState(isDarkMode: false)) {
    on<ToggleTheme>(_onToggleTheme);
    on<LoadTheme>(_onLoadTheme);
  }

  Future<void> _onToggleTheme(
      ToggleTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final newIsDark = !state.isDarkMode;
    await prefs.setBool(_themeKey, newIsDark);
    emit(ThemeState(isDarkMode: newIsDark));
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    emit(ThemeState(isDarkMode: isDark));
  }
}
