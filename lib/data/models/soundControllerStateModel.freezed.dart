// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'soundControllerStateModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SoundControllerStateModel _$SoundControllerStateModelFromJson(
    Map<String, dynamic> json) {
  return _SoundControllerStateModel.fromJson(json);
}

/// @nodoc
mixin _$SoundControllerStateModel {
  String get breakSound => throw _privateConstructorUsedError;
  String get workSound => throw _privateConstructorUsedError;
  bool get playWorkSound => throw _privateConstructorUsedError;
  bool get playBreakSound => throw _privateConstructorUsedError;
  double get soundsVolume => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SoundControllerStateModelCopyWith<SoundControllerStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoundControllerStateModelCopyWith<$Res> {
  factory $SoundControllerStateModelCopyWith(SoundControllerStateModel value,
          $Res Function(SoundControllerStateModel) then) =
      _$SoundControllerStateModelCopyWithImpl<$Res, SoundControllerStateModel>;
  @useResult
  $Res call(
      {String breakSound,
      String workSound,
      bool playWorkSound,
      bool playBreakSound,
      double soundsVolume});
}

/// @nodoc
class _$SoundControllerStateModelCopyWithImpl<$Res,
        $Val extends SoundControllerStateModel>
    implements $SoundControllerStateModelCopyWith<$Res> {
  _$SoundControllerStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breakSound = null,
    Object? workSound = null,
    Object? playWorkSound = null,
    Object? playBreakSound = null,
    Object? soundsVolume = null,
  }) {
    return _then(_value.copyWith(
      breakSound: null == breakSound
          ? _value.breakSound
          : breakSound // ignore: cast_nullable_to_non_nullable
              as String,
      workSound: null == workSound
          ? _value.workSound
          : workSound // ignore: cast_nullable_to_non_nullable
              as String,
      playWorkSound: null == playWorkSound
          ? _value.playWorkSound
          : playWorkSound // ignore: cast_nullable_to_non_nullable
              as bool,
      playBreakSound: null == playBreakSound
          ? _value.playBreakSound
          : playBreakSound // ignore: cast_nullable_to_non_nullable
              as bool,
      soundsVolume: null == soundsVolume
          ? _value.soundsVolume
          : soundsVolume // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SoundControllerStateModelImplCopyWith<$Res>
    implements $SoundControllerStateModelCopyWith<$Res> {
  factory _$$SoundControllerStateModelImplCopyWith(
          _$SoundControllerStateModelImpl value,
          $Res Function(_$SoundControllerStateModelImpl) then) =
      __$$SoundControllerStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String breakSound,
      String workSound,
      bool playWorkSound,
      bool playBreakSound,
      double soundsVolume});
}

/// @nodoc
class __$$SoundControllerStateModelImplCopyWithImpl<$Res>
    extends _$SoundControllerStateModelCopyWithImpl<$Res,
        _$SoundControllerStateModelImpl>
    implements _$$SoundControllerStateModelImplCopyWith<$Res> {
  __$$SoundControllerStateModelImplCopyWithImpl(
      _$SoundControllerStateModelImpl _value,
      $Res Function(_$SoundControllerStateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? breakSound = null,
    Object? workSound = null,
    Object? playWorkSound = null,
    Object? playBreakSound = null,
    Object? soundsVolume = null,
  }) {
    return _then(_$SoundControllerStateModelImpl(
      breakSound: null == breakSound
          ? _value.breakSound
          : breakSound // ignore: cast_nullable_to_non_nullable
              as String,
      workSound: null == workSound
          ? _value.workSound
          : workSound // ignore: cast_nullable_to_non_nullable
              as String,
      playWorkSound: null == playWorkSound
          ? _value.playWorkSound
          : playWorkSound // ignore: cast_nullable_to_non_nullable
              as bool,
      playBreakSound: null == playBreakSound
          ? _value.playBreakSound
          : playBreakSound // ignore: cast_nullable_to_non_nullable
              as bool,
      soundsVolume: null == soundsVolume
          ? _value.soundsVolume
          : soundsVolume // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SoundControllerStateModelImpl implements _SoundControllerStateModel {
  _$SoundControllerStateModelImpl(
      {required this.breakSound,
      required this.workSound,
      required this.playWorkSound,
      required this.playBreakSound,
      required this.soundsVolume});

  factory _$SoundControllerStateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoundControllerStateModelImplFromJson(json);

  @override
  final String breakSound;
  @override
  final String workSound;
  @override
  final bool playWorkSound;
  @override
  final bool playBreakSound;
  @override
  final double soundsVolume;

  @override
  String toString() {
    return 'SoundControllerStateModel(breakSound: $breakSound, workSound: $workSound, playWorkSound: $playWorkSound, playBreakSound: $playBreakSound, soundsVolume: $soundsVolume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoundControllerStateModelImpl &&
            (identical(other.breakSound, breakSound) ||
                other.breakSound == breakSound) &&
            (identical(other.workSound, workSound) ||
                other.workSound == workSound) &&
            (identical(other.playWorkSound, playWorkSound) ||
                other.playWorkSound == playWorkSound) &&
            (identical(other.playBreakSound, playBreakSound) ||
                other.playBreakSound == playBreakSound) &&
            (identical(other.soundsVolume, soundsVolume) ||
                other.soundsVolume == soundsVolume));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, breakSound, workSound,
      playWorkSound, playBreakSound, soundsVolume);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SoundControllerStateModelImplCopyWith<_$SoundControllerStateModelImpl>
      get copyWith => __$$SoundControllerStateModelImplCopyWithImpl<
          _$SoundControllerStateModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoundControllerStateModelImplToJson(
      this,
    );
  }
}

abstract class _SoundControllerStateModel implements SoundControllerStateModel {
  factory _SoundControllerStateModel(
      {required final String breakSound,
      required final String workSound,
      required final bool playWorkSound,
      required final bool playBreakSound,
      required final double soundsVolume}) = _$SoundControllerStateModelImpl;

  factory _SoundControllerStateModel.fromJson(Map<String, dynamic> json) =
      _$SoundControllerStateModelImpl.fromJson;

  @override
  String get breakSound;
  @override
  String get workSound;
  @override
  bool get playWorkSound;
  @override
  bool get playBreakSound;
  @override
  double get soundsVolume;
  @override
  @JsonKey(ignore: true)
  _$$SoundControllerStateModelImplCopyWith<_$SoundControllerStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
