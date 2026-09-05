import 'package:biblitos/components/animals/animal_config.dart';
import 'package:biblitos/components/animals/board_target.dart';
import 'package:biblitos/components/animals/idle_effect.dart';
import 'package:biblitos/components/animals/react_effect.dart';
import 'package:biblitos/components/animals/tap_feedback_effect.dart';
import 'package:biblitos/components/drag_debug_logger.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';

class AnimalComponent extends SpriteComponent with TapCallbacks, DragCallbacks {
  final AnimalConfig config;
  final void Function(String audioKey, String reactAnimation) onTapped;

  int _tapCount = 0;
  Effect? _hintEffect;

  /// The three below are only used when [AnimalConfig.isDraggable] is true —
  /// they define the "drag this animal onto the ark" objective. Noah (not
  /// draggable-to-target) simply omits them.
  final Vector2 Function()? getBoardTargetCenter;
  final double? boardRadius;
  final void Function()? onBoarded;

  AnimalComponent({
    required this.config,
    required this.onTapped,
    required Vector2 position,
    required Vector2 size,
    this.getBoardTargetCenter,
    this.boardRadius,
    this.onBoarded,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(config.spritePath);
    debugPrint('🧩 ${config.animalKey} loaded — size: $size');

    add(idleEffectFor(config.idleAnimation));
    if (config.isDraggable) {
      _hintEffect = idleEffectFor('hint');
      add(_hintEffect!);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(tapFeedbackEffectFor(_tapCount++));
    onTapped(config.audioKey, config.reactAnimation);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    logDropPositionRatio(config.animalKey, this);

    if (config.isDraggable &&
        getBoardTargetCenter != null &&
        boardRadius != null &&
        onBoarded != null &&
        isWithinBoardRadius(
          componentCenter: position + size / 2,
          targetCenter: getBoardTargetCenter!(),
          radius: boardRadius!,
        )) {
      if (_hintEffect != null) {
        _hintEffect!.removeFromParent();
        _hintEffect = null;
      }
      playReactAnimation();
      onBoarded!();
    }
  }

  void playReactAnimation() {
    add(reactEffectFor(config.reactAnimation));
  }
}
