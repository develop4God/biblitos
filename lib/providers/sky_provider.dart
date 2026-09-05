import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkyNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
    debugPrint('🌗 sky toggled — isNight: $state');
  }
}

final skyProvider = NotifierProvider<SkyNotifier, bool>(SkyNotifier.new);
