import 'package:biblitos/providers/audio_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ambientAssetPathFor', () {
    test('false maps to the day ambient asset', () {
      expect(ambientAssetPathFor(false), 'assets/audio/en/sfx/ambient_day.mp3');
    });

    test('true maps to the night ambient asset', () {
      expect(
        ambientAssetPathFor(true),
        'assets/audio/en/sfx/ambient_night.mp3',
      );
    });
  });
}
