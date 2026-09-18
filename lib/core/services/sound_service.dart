import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:tarkeez/core/constants/sound_paths.dart';

class SoundService {
  final SoLoud _soloud = SoLoud.instance;
  AudioSource? _bellSound;

  bool get isReady => _bellSound != null;

  Future<void> init() async {
    if (_bellSound != null) return;
    try {
      if (!_soloud.isInitialized) await _soloud.init();
      _bellSound = await _soloud.loadAsset(
        SoundPaths.bell,
      );
      debugPrint('🔊 Background SoundService initialized.');
    } catch (e, stackTrace) {
      debugPrint('❌ SoundService initialization failed: $e');
      debugPrint('$stackTrace');
    }
  }

  void playBell() {
    final sound = _bellSound;
    if (sound == null) {
      debugPrint('❌ Bell sound is not initialized.');
      return;
    }
    try {
      _soloud.play(sound);
      debugPrint('🔔 Bell played.');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to play bell: $e');
      debugPrint('$stackTrace');
    }
  }

  Future<void> dispose() async {
    final sound = _bellSound;
    if (sound != null) {
      await _soloud.disposeSource(sound);
      _bellSound = null;
    }
    if (_soloud.isInitialized) _soloud.deinit();
  }
}
