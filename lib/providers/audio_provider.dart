import 'package:biblitos/services/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

extension AudioServiceX on AudioService {
  Future<void> playVerse(String audioKey, String language) =>
      play('assets/audio/$language/$audioKey.mp3');

  Future<void> playSfx(String sfxKey) =>
      play('assets/audio/en/sfx/$sfxKey.mp3');
}

