import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String path) async {
    try {
      await _player.setAsset(path);
      await _player.play();
    } catch (e) {
      // ignore: avoid_print
      print('AudioService: file not found → $path');
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
