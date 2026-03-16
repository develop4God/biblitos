import 'package:flutter_riverpod/flutter_riverpod.dart';

const kSupportedLanguages = ['en', 'es', 'pt', 'fr'];
const kDefaultLanguage = 'en';
const kAudioBasePath = 'assets/audio/';

class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super(kDefaultLanguage);

  void setLanguage(String language) {
    if (kSupportedLanguages.contains(language)) {
      state = language;
    }
  }

  String buildPath(String audioKey) => '$kAudioBasePath$state/$audioKey.mp3';

  String buildSfxPath(String sfxKey) => '${kAudioBasePath}en/sfx/$sfxKey.mp3';
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String>(
  (ref) => LocaleNotifier(),
);
