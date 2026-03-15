import 'package:biblitos/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocaleNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('defaults to en', () {
      expect(container.read(localeProvider), 'en');
    });

    test('setLanguage updates state for supported language', () {
      container.read(localeProvider.notifier).setLanguage('es');
      expect(container.read(localeProvider), 'es');
    });

    test('setLanguage ignores unsupported language', () {
      container.read(localeProvider.notifier).setLanguage('de');
      expect(container.read(localeProvider), 'en');
    });

    test('buildPath returns correct path', () {
      container.read(localeProvider.notifier).setLanguage('pt');
      final path = container
          .read(localeProvider.notifier)
          .buildPath('lion_verse');
      expect(path, 'assets/audio/pt/lion_verse.mp3');
    });

    test('buildSfxPath always resolves to en/sfx/', () {
      container.read(localeProvider.notifier).setLanguage('fr');
      final path = container
          .read(localeProvider.notifier)
          .buildSfxPath('rain');
      expect(path, 'assets/audio/en/sfx/rain.mp3');
    });
  });
}

