import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _ambientPlayer = AudioPlayer();

  static const double _ambientNormalVolume = 1.0;
  static const double _ambientDuckedVolume = 0.3;

  Future<void> play(String path) async {
    try {
      await _player.setAsset(path);
      await _player.play();
    } catch (e) {
      // ignore: avoid_print
      print('AudioService: file not found → $path');
    }
  }

  Future<void> playAmbient(String path) async {
    try {
      await _ambientPlayer.setAsset(path);
      await _ambientPlayer.setLoopMode(LoopMode.one);
      await _ambientPlayer.setVolume(_ambientNormalVolume);
      await _ambientPlayer.play();
    } catch (e) {
      // ignore: avoid_print
      print('AudioService: file not found → $path');
    }
  }

  Future<void> stopAmbient() => _ambientPlayer.stop();

  Future<void> playDucked(String path) async {
    final wasPlaying = _ambientPlayer.playing;
    if (wasPlaying) {
      await _ambientPlayer.setVolume(_ambientDuckedVolume);
    }
    try {
      await play(path);
    } finally {
      if (wasPlaying) {
        await _ambientPlayer.setVolume(_ambientNormalVolume);
      }
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
    _ambientPlayer.dispose();
  }
}
