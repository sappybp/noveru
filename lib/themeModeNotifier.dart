import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noveru/sharedPreferencesInstance.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String keyThemeMode = 'theme_mode';

  final _prefs = SharedPreferencesInstance().prefs;

  ThemeModeNotifier() : super(ThemeMode.dark) {
    state = _loadThemeMode() ?? ThemeMode.dark;
  }

  Future<void> toggle() async {
    ThemeMode themeMode;
    switch (state) {
      case ThemeMode.light:
        themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        themeMode = ThemeMode.light;
        break;
      case ThemeMode.system:
        themeMode = ThemeMode.light;
        break;
    }

    await _saveThemeMode(themeMode).then((value) {
      if (value == true) {
        state = themeMode;
      }
    });
  }

  Future<void> switchThemeMode(themeMode) async {
    await _saveThemeMode(themeMode).then((value) {
      if (value == true) {
        // print(themeMode);
        state = themeMode;
      }
    });
  }


  ThemeMode? _loadThemeMode() {
    // print('_loadThemeMode');
    final loaded = valToMode(_prefs.getInt(keyThemeMode) ?? 0);
    return loaded;
  }

  // Future<bool> _saveThemeMode(ThemeMode themeMode) => _prefs.setInt(keyThemeMode, themeMode.name);

  Future<bool> _saveThemeMode(ThemeMode mode) async {
    // print('_saveThemeMode');
    _prefs.setInt('theme_mode', modeToVal(mode));
    return true;
  }

  int modeToVal(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 0;
      case ThemeMode.light:
        return 1;
      default:
        return 0;
    }
  }

  ThemeMode valToMode(int val) {
    switch (val) {
      case 0:
        return ThemeMode.dark;
      case 1:
        return ThemeMode.light;
      default:
        return ThemeMode.dark;
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) => ThemeModeNotifier());