import 'package:freezed_annotation/freezed_annotation.dart';

part 'animal_config.freezed.dart';

@freezed
class AnimalConfig with _$AnimalConfig {
  const factory AnimalConfig({
    required String audioKey,
    required String spritePath,
    required String reactAnimation,
    required String idleAnimation,
    @Default(false) bool isDraggable,
  }) = _AnimalConfig;
}

const kNoahConfig = AnimalConfig(
  audioKey: 'noah_verse',
  spritePath: 'assets/noah_ark/characters/noah.png',
  reactAnimation: 'wave',
  idleAnimation: 'idle',
);

const kLionConfig = AnimalConfig(
  audioKey: 'lion_verse',
  spritePath: 'assets/noah_ark/characters/lion.png',
  reactAnimation: 'bounce',
  idleAnimation: 'idle',
);

const kElephantConfig = AnimalConfig(
  audioKey: 'elephant_verse',
  spritePath: 'assets/noah_ark/characters/elephant.png',
  reactAnimation: 'wiggle',
  idleAnimation: 'idle',
);

const kGiraffeConfig = AnimalConfig(
  audioKey: 'giraffe_verse',
  spritePath: 'assets/noah_ark/characters/giraffe.png',
  reactAnimation: 'stretch',
  idleAnimation: 'idle',
);

const kDoveConfig = AnimalConfig(
  audioKey: 'dove_verse',
  spritePath: 'assets/noah_ark/characters/dove.png',
  reactAnimation: 'fly',
  idleAnimation: 'idle',
);

const kSheepConfig = AnimalConfig(
  audioKey: 'sheep_verse',
  spritePath: 'assets/noah_ark/characters/sheep.png',
  reactAnimation: 'hop',
  idleAnimation: 'idle',
);
