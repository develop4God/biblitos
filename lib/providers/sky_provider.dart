import 'package:flutter_riverpod/flutter_riverpod.dart';

class SkyNotifier extends StateNotifier<bool> {
  SkyNotifier() : super(false);

  void toggle() => state = !state;
}

final skyProvider = StateNotifierProvider<SkyNotifier, bool>(
  (ref) => SkyNotifier(),
);
