import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const _kLeftHanded = 'left_handed';
  static const _kHaptics = 'haptics_enabled';
  static const _kSound = 'sound_enabled';

  bool _leftHandedMode = false;
  bool _hapticsEnabled = true;
  bool _soundEnabled = true;
  bool _loaded = false;

  bool get leftHandedMode => _leftHandedMode;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      _leftHandedMode = p.getBool(_kLeftHanded) ?? false;
      _hapticsEnabled = p.getBool(_kHaptics) ?? true;
      _soundEnabled = p.getBool(_kSound) ?? true;
    } catch (e) {
      debugPrint('SettingsProvider load error: $e');
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist(String key, bool value) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setBool(key, value);
    } catch (e) {
      debugPrint('SettingsProvider persist error: $e');
    }
  }

  Future<void> toggleLeftHanded() async {
    _leftHandedMode = !_leftHandedMode;
    await _persist(_kLeftHanded, _leftHandedMode);
    notifyListeners();
  }

  Future<void> toggleHaptics() async {
    _hapticsEnabled = !_hapticsEnabled;
    await _persist(_kHaptics, _hapticsEnabled);
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    await _persist(_kSound, _soundEnabled);
    notifyListeners();
  }
}