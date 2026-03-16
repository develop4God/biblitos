// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AnimalConfig {
  String get animalKey => throw _privateConstructorUsedError;
  String get audioKey => throw _privateConstructorUsedError;
  String get spritePath => throw _privateConstructorUsedError;
  String get reactAnimation => throw _privateConstructorUsedError;
  String get idleAnimation => throw _privateConstructorUsedError;
  bool get isDraggable => throw _privateConstructorUsedError;

  /// Create a copy of AnimalConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnimalConfigCopyWith<AnimalConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimalConfigCopyWith<$Res> {
  factory $AnimalConfigCopyWith(
    AnimalConfig value,
    $Res Function(AnimalConfig) then,
  ) = _$AnimalConfigCopyWithImpl<$Res, AnimalConfig>;
  @useResult
  $Res call({
    String animalKey,
    String audioKey,
    String spritePath,
    String reactAnimation,
    String idleAnimation,
    bool isDraggable,
  });
}

/// @nodoc
class _$AnimalConfigCopyWithImpl<$Res, $Val extends AnimalConfig>
    implements $AnimalConfigCopyWith<$Res> {
  _$AnimalConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnimalConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? animalKey = null,
    Object? audioKey = null,
    Object? spritePath = null,
    Object? reactAnimation = null,
    Object? idleAnimation = null,
    Object? isDraggable = null,
  }) {
    return _then(
      _value.copyWith(
            animalKey: null == animalKey
                ? _value.animalKey
                : animalKey // ignore: cast_nullable_to_non_nullable
                      as String,
            audioKey: null == audioKey
                ? _value.audioKey
                : audioKey // ignore: cast_nullable_to_non_nullable
                      as String,
            spritePath: null == spritePath
                ? _value.spritePath
                : spritePath // ignore: cast_nullable_to_non_nullable
                      as String,
            reactAnimation: null == reactAnimation
                ? _value.reactAnimation
                : reactAnimation // ignore: cast_nullable_to_non_nullable
                      as String,
            idleAnimation: null == idleAnimation
                ? _value.idleAnimation
                : idleAnimation // ignore: cast_nullable_to_non_nullable
                      as String,
            isDraggable: null == isDraggable
                ? _value.isDraggable
                : isDraggable // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnimalConfigImplCopyWith<$Res>
    implements $AnimalConfigCopyWith<$Res> {
  factory _$$AnimalConfigImplCopyWith(
    _$AnimalConfigImpl value,
    $Res Function(_$AnimalConfigImpl) then,
  ) = __$$AnimalConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String animalKey,
    String audioKey,
    String spritePath,
    String reactAnimation,
    String idleAnimation,
    bool isDraggable,
  });
}

/// @nodoc
class __$$AnimalConfigImplCopyWithImpl<$Res>
    extends _$AnimalConfigCopyWithImpl<$Res, _$AnimalConfigImpl>
    implements _$$AnimalConfigImplCopyWith<$Res> {
  __$$AnimalConfigImplCopyWithImpl(
    _$AnimalConfigImpl _value,
    $Res Function(_$AnimalConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnimalConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? animalKey = null,
    Object? audioKey = null,
    Object? spritePath = null,
    Object? reactAnimation = null,
    Object? idleAnimation = null,
    Object? isDraggable = null,
  }) {
    return _then(
      _$AnimalConfigImpl(
        animalKey: null == animalKey
            ? _value.animalKey
            : animalKey // ignore: cast_nullable_to_non_nullable
                  as String,
        audioKey: null == audioKey
            ? _value.audioKey
            : audioKey // ignore: cast_nullable_to_non_nullable
                  as String,
        spritePath: null == spritePath
            ? _value.spritePath
            : spritePath // ignore: cast_nullable_to_non_nullable
                  as String,
        reactAnimation: null == reactAnimation
            ? _value.reactAnimation
            : reactAnimation // ignore: cast_nullable_to_non_nullable
                  as String,
        idleAnimation: null == idleAnimation
            ? _value.idleAnimation
            : idleAnimation // ignore: cast_nullable_to_non_nullable
                  as String,
        isDraggable: null == isDraggable
            ? _value.isDraggable
            : isDraggable // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AnimalConfigImpl implements _AnimalConfig {
  const _$AnimalConfigImpl({
    required this.animalKey,
    required this.audioKey,
    required this.spritePath,
    required this.reactAnimation,
    required this.idleAnimation,
    this.isDraggable = false,
  });

  @override
  final String animalKey;
  @override
  final String audioKey;
  @override
  final String spritePath;
  @override
  final String reactAnimation;
  @override
  final String idleAnimation;
  @override
  @JsonKey()
  final bool isDraggable;

  @override
  String toString() {
    return 'AnimalConfig(animalKey: $animalKey, audioKey: $audioKey, spritePath: $spritePath, reactAnimation: $reactAnimation, idleAnimation: $idleAnimation, isDraggable: $isDraggable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnimalConfigImpl &&
            (identical(other.animalKey, animalKey) ||
                other.animalKey == animalKey) &&
            (identical(other.audioKey, audioKey) ||
                other.audioKey == audioKey) &&
            (identical(other.spritePath, spritePath) ||
                other.spritePath == spritePath) &&
            (identical(other.reactAnimation, reactAnimation) ||
                other.reactAnimation == reactAnimation) &&
            (identical(other.idleAnimation, idleAnimation) ||
                other.idleAnimation == idleAnimation) &&
            (identical(other.isDraggable, isDraggable) ||
                other.isDraggable == isDraggable));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    animalKey,
    audioKey,
    spritePath,
    reactAnimation,
    idleAnimation,
    isDraggable,
  );

  /// Create a copy of AnimalConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnimalConfigImplCopyWith<_$AnimalConfigImpl> get copyWith =>
      __$$AnimalConfigImplCopyWithImpl<_$AnimalConfigImpl>(this, _$identity);
}

abstract class _AnimalConfig implements AnimalConfig {
  const factory _AnimalConfig({
    required final String animalKey,
    required final String audioKey,
    required final String spritePath,
    required final String reactAnimation,
    required final String idleAnimation,
    final bool isDraggable,
  }) = _$AnimalConfigImpl;

  @override
  String get animalKey;
  @override
  String get audioKey;
  @override
  String get spritePath;
  @override
  String get reactAnimation;
  @override
  String get idleAnimation;
  @override
  bool get isDraggable;

  /// Create a copy of AnimalConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnimalConfigImplCopyWith<_$AnimalConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
