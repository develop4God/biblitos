import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'game_state_provider.freezed.dart';

@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default({}) Set<String> placedAnimals,
  }) = _GameState;
}

extension GameStateX on GameState {
  bool isPlaced(String key) => placedAnimals.contains(key);
  bool get allPlaced =>
      kAllAnimals.every(placedAnimals.contains);
}

const kAllAnimals = {
  'noah', 'lion', 'elephant', 'giraffe', 'dove', 'sheep'
};

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(const GameState());

  void placeAnimal(String animalKey) {
    if (kAllAnimals.contains(animalKey)) {
      state = state.copyWith(
        placedAnimals: {...state.placedAnimals, animalKey},
      );
    }
  }

  void reset() => state = const GameState();
}

final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>(
  (ref) => GameStateNotifier(),
);

