// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animal_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnimalConfig {

 String get animalKey; String get audioKey; String get spritePath; String get reactAnimation; String get idleAnimation; bool get isDraggable;
/// Create a copy of AnimalConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnimalConfigCopyWith<AnimalConfig> get copyWith => _$AnimalConfigCopyWithImpl<AnimalConfig>(this as AnimalConfig, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AnimalConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimalConfig&&(identical(other.animalKey, _this.animalKey) || other.animalKey == _this.animalKey)&&(identical(other.audioKey, _this.audioKey) || other.audioKey == _this.audioKey)&&(identical(other.spritePath, _this.spritePath) || other.spritePath == _this.spritePath)&&(identical(other.reactAnimation, _this.reactAnimation) || other.reactAnimation == _this.reactAnimation)&&(identical(other.idleAnimation, _this.idleAnimation) || other.idleAnimation == _this.idleAnimation)&&(identical(other.isDraggable, _this.isDraggable) || other.isDraggable == _this.isDraggable));
}


@override
int get hashCode {
  final _this = this as AnimalConfig;
  return Object.hash(runtimeType,_this.animalKey,_this.audioKey,_this.spritePath,_this.reactAnimation,_this.idleAnimation,_this.isDraggable);
}

@override
String toString() {
  final _this = this as AnimalConfig;
  return 'AnimalConfig(animalKey: ${_this.animalKey}, audioKey: ${_this.audioKey}, spritePath: ${_this.spritePath}, reactAnimation: ${_this.reactAnimation}, idleAnimation: ${_this.idleAnimation}, isDraggable: ${_this.isDraggable})';
}


}

/// @nodoc
abstract mixin class $AnimalConfigCopyWith<$Res>  {
  factory $AnimalConfigCopyWith(AnimalConfig value, $Res Function(AnimalConfig) _then) = _$AnimalConfigCopyWithImpl;
@useResult
$Res call({
 String animalKey, String audioKey, String spritePath, String reactAnimation, String idleAnimation, bool isDraggable
});




}
/// @nodoc
class _$AnimalConfigCopyWithImpl<$Res>
    implements $AnimalConfigCopyWith<$Res> {
  _$AnimalConfigCopyWithImpl(this._self, this._then);

  final AnimalConfig _self;
  final $Res Function(AnimalConfig) _then;

/// Create a copy of AnimalConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? animalKey = null,Object? audioKey = null,Object? spritePath = null,Object? reactAnimation = null,Object? idleAnimation = null,Object? isDraggable = null,}) {
  return _then(AnimalConfig(
animalKey: null == animalKey ? _self.animalKey : animalKey // ignore: cast_nullable_to_non_nullable
as String,audioKey: null == audioKey ? _self.audioKey : audioKey // ignore: cast_nullable_to_non_nullable
as String,spritePath: null == spritePath ? _self.spritePath : spritePath // ignore: cast_nullable_to_non_nullable
as String,reactAnimation: null == reactAnimation ? _self.reactAnimation : reactAnimation // ignore: cast_nullable_to_non_nullable
as String,idleAnimation: null == idleAnimation ? _self.idleAnimation : idleAnimation // ignore: cast_nullable_to_non_nullable
as String,isDraggable: null == isDraggable ? _self.isDraggable : isDraggable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AnimalConfig].
extension AnimalConfigPatterns on AnimalConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnimalConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnimalConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnimalConfig value)  $default,){
final _that = this;
switch (_that) {
case _AnimalConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnimalConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AnimalConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String animalKey,  String audioKey,  String spritePath,  String reactAnimation,  String idleAnimation,  bool isDraggable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnimalConfig() when $default != null:
return $default(_that.animalKey,_that.audioKey,_that.spritePath,_that.reactAnimation,_that.idleAnimation,_that.isDraggable);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String animalKey,  String audioKey,  String spritePath,  String reactAnimation,  String idleAnimation,  bool isDraggable)  $default,) {final _that = this;
switch (_that) {
case _AnimalConfig():
return $default(_that.animalKey,_that.audioKey,_that.spritePath,_that.reactAnimation,_that.idleAnimation,_that.isDraggable);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String animalKey,  String audioKey,  String spritePath,  String reactAnimation,  String idleAnimation,  bool isDraggable)?  $default,) {final _that = this;
switch (_that) {
case _AnimalConfig() when $default != null:
return $default(_that.animalKey,_that.audioKey,_that.spritePath,_that.reactAnimation,_that.idleAnimation,_that.isDraggable);case _:
  return null;

}
}

}

/// @nodoc


class _AnimalConfig implements AnimalConfig {
  const _AnimalConfig({required this.animalKey, required this.audioKey, required this.spritePath, required this.reactAnimation, required this.idleAnimation, this.isDraggable = false});
  

@override final  String animalKey;
@override final  String audioKey;
@override final  String spritePath;
@override final  String reactAnimation;
@override final  String idleAnimation;
@override@JsonKey() final  bool isDraggable;

/// Create a copy of AnimalConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnimalConfigCopyWith<_AnimalConfig> get copyWith => __$AnimalConfigCopyWithImpl<_AnimalConfig>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnimalConfig&&(identical(other.animalKey, animalKey) || other.animalKey == animalKey)&&(identical(other.audioKey, audioKey) || other.audioKey == audioKey)&&(identical(other.spritePath, spritePath) || other.spritePath == spritePath)&&(identical(other.reactAnimation, reactAnimation) || other.reactAnimation == reactAnimation)&&(identical(other.idleAnimation, idleAnimation) || other.idleAnimation == idleAnimation)&&(identical(other.isDraggable, isDraggable) || other.isDraggable == isDraggable));
}


@override
int get hashCode {
    return Object.hash(runtimeType,animalKey,audioKey,spritePath,reactAnimation,idleAnimation,isDraggable);
}

@override
String toString() {
    return 'AnimalConfig(animalKey: $animalKey, audioKey: $audioKey, spritePath: $spritePath, reactAnimation: $reactAnimation, idleAnimation: $idleAnimation, isDraggable: $isDraggable)';
}


}

/// @nodoc
abstract mixin class _$AnimalConfigCopyWith<$Res> implements $AnimalConfigCopyWith<$Res> {
  factory _$AnimalConfigCopyWith(_AnimalConfig value, $Res Function(_AnimalConfig) _then) = __$AnimalConfigCopyWithImpl;
@override @useResult
$Res call({
 String animalKey, String audioKey, String spritePath, String reactAnimation, String idleAnimation, bool isDraggable
});




}
/// @nodoc
class __$AnimalConfigCopyWithImpl<$Res>
    implements _$AnimalConfigCopyWith<$Res> {
  __$AnimalConfigCopyWithImpl(this._self, this._then);

  final _AnimalConfig _self;
  final $Res Function(_AnimalConfig) _then;

/// Create a copy of AnimalConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? animalKey = null,Object? audioKey = null,Object? spritePath = null,Object? reactAnimation = null,Object? idleAnimation = null,Object? isDraggable = null,}) {
  return _then(_AnimalConfig(
animalKey: null == animalKey ? _self.animalKey : animalKey // ignore: cast_nullable_to_non_nullable
as String,audioKey: null == audioKey ? _self.audioKey : audioKey // ignore: cast_nullable_to_non_nullable
as String,spritePath: null == spritePath ? _self.spritePath : spritePath // ignore: cast_nullable_to_non_nullable
as String,reactAnimation: null == reactAnimation ? _self.reactAnimation : reactAnimation // ignore: cast_nullable_to_non_nullable
as String,idleAnimation: null == idleAnimation ? _self.idleAnimation : idleAnimation // ignore: cast_nullable_to_non_nullable
as String,isDraggable: null == isDraggable ? _self.isDraggable : isDraggable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
