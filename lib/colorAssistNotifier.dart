import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noveru/sharedPreferencesInstance.dart';

class ColorAssistNotifier extends StateNotifier<bool> {
  static const String keyColorAssist = 'color_assist';

  final _prefs = SharedPreferencesInstance().prefs;

  ColorAssistNotifier() : super(true) {
    state = _loadColorAssist() ?? true;
  }

  Future<void> switchColorAssist(colorAssist) async {
    await _saveColorAssist(colorAssist).then((value) {
      if (value == true) {
        // print(colorAssist);
        state = colorAssist;
      }
    });
  }

  bool? _loadColorAssist() {
    // print('_loadColorAssist');
    final loaded = _prefs.getBool(keyColorAssist) ?? true;
    return loaded;
  }

  Future<bool> _saveColorAssist(bool colorAssist) async {
    // print('_saveThemeMode');
    _prefs.setBool(keyColorAssist, colorAssist);
    return true;
  }
  
}

final colorAssistProvider = StateNotifierProvider<ColorAssistNotifier, bool>((ref) => ColorAssistNotifier());