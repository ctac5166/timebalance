// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pomodoroShemeModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PomodoroShemeModel _$PomodoroShemeModelFromJson(Map<String, dynamic> json) {
  return _PomodoroShemeModel.fromJson(json);
}

/// @nodoc
mixin _$PomodoroShemeModel {
  String get shemeName => throw _privateConstructorUsedError;
  int get breakTimeInSeconds => throw _privateConstructorUsedError;
  int get shortBreakTimeInSeconds => throw _privateConstructorUsedError;
  int get workSessionTimeInSeconds => throw _privateConstructorUsedError;
  int get numberOfSessionsBeforeLongBreak => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PomodoroShemeModelCopyWith<PomodoroShemeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PomodoroShemeModelCopyWith<$Res> {
  factory $PomodoroShemeModelCopyWith(
          PomodoroShemeModel value, $Res Function(PomodoroShemeModel) then) =
      _$PomodoroShemeModelCopyWithImpl<$Res, PomodoroShemeModel>;
  @useResult
  $Res call(
      {String shemeName,
      int breakTimeInSeconds,
      int shortBreakTimeInSeconds,
      int workSessionTimeInSeconds,
      int numberOfSessionsBeforeLongBreak});
}

/// @nodoc
class _$PomodoroShemeModelCopyWithImpl<$Res, $Val extends PomodoroShemeModel>
    implements $PomodoroShemeModelCopyWith<$Res> {
  _$PomodoroShemeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shemeName = null,
    Object? breakTimeInSeconds = null,
    Object? shortBreakTimeInSeconds = null,
    Object? workSessionTimeInSeconds = null,
    Object? numberOfSessionsBeforeLongBreak = null,
  }) {
    return _then(_value.copyWith(
      shemeName: null == shemeName
          ? _value.shemeName
          : shemeName // ignore: cast_nullable_to_non_nullable
              as String,
      breakTimeInSeconds: null == breakTimeInSeconds
          ? _value.breakTimeInSeconds
          : breakTimeInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakTimeInSeconds: null == shortBreakTimeInSeconds
          ? _value.shortBreakTimeInSeconds
          : shortBreakTimeInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      workSessionTimeInSeconds: null == workSessionTimeInSeconds
          ? _value.workSessionTimeInSeconds
          : workSessionTimeInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      numberOfSessionsBeforeLongBreak: null == numberOfSessionsBeforeLongBreak
          ? _value.numberOfSessionsBeforeLongBreak
          : numberOfSessionsBeforeLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PomodoroShemeModelImplCopyWith<$Res>
    implements $PomodoroShemeModelCopyWith<$Res> {
  factory _$$PomodoroShemeModelImplCopyWith(_$PomodoroShemeModelImpl value,
          $Res Function(_$PomodoroShemeModelImpl) then) =
      __$$PomodoroShemeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shemeName,
      int breakTimeInSeconds,
      int shortBreakTimeInSeconds,
      int workSessionTimeInSeconds,
      int numberOfSessionsBeforeLongBreak});
}

/// @nodoc
class __$$PomodoroShemeModelImplCopyWithImpl<$Res>
    extends _$PomodoroShemeModelCopyWithImpl<$Res, _$PomodoroShemeModelImpl>
    implements _$$PomodoroShemeModelImplCopyWith<$Res> {
  __$$PomodoroShemeModelImplCopyWithImpl(_$PomodoroShemeModelImpl _value,
      $Res Function(_$PomodoroShemeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shemeName = null,
    Object? breakTimeInSeconds = null,
    Object? shortBreakTimeInSeconds = null,
    Object? workSessionTimeInSeconds = null,
    Object? numberOfSessionsBeforeLongBreak = null,
  }) {
    return _then(_$PomodoroShemeModelImpl(
      shemeName: null == shemeName
          ? _value.shemeName
          : shemeName // ignore: cast_nullable_to_non_nullable
              as String,
      breakTimeInSeconds: null == breakTimeInSeconds
          ? _value.breakTimeInSeconds
          : breakTimeInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      shortBreakTimeInSeconds: null == shortBreakTimeInSeconds
          ? _value.shortBreakTimeInSeconds
          : shortBreakTimeInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      workSessionTimeInSeconds: null == workSessionTimeInSeconds
          ? _value.workSessionTimeInSeconds
          : workSessionTimeInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      numberOfSessionsBeforeLongBreak: null == numberOfSessionsBeforeLongBreak
          ? _value.numberOfSessionsBeforeLongBreak
          : numberOfSessionsBeforeLongBreak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PomodoroShemeModelImpl implements _PomodoroShemeModel {
  _$PomodoroShemeModelImpl(
      {required this.shemeName,
      required this.breakTimeInSeconds,
      required this.shortBreakTimeInSeconds,
      required this.workSessionTimeInSeconds,
      required this.numberOfSessionsBeforeLongBreak});

  factory _$PomodoroShemeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PomodoroShemeModelImplFromJson(json);

  @override
  final String shemeName;
  @override
  final int breakTimeInSeconds;
  @override
  final int shortBreakTimeInSeconds;
  @override
  final int workSessionTimeInSeconds;
  @override
  final int numberOfSessionsBeforeLongBreak;

  @override
  String toString() {
    return 'PomodoroShemeModel(shemeName: $shemeName, breakTimeInSeconds: $breakTimeInSeconds, shortBreakTimeInSeconds: $shortBreakTimeInSeconds, workSessionTimeInSeconds: $workSessionTimeInSeconds, numberOfSessionsBeforeLongBreak: $numberOfSessionsBeforeLongBreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PomodoroShemeModelImpl &&
            (identical(other.shemeName, shemeName) ||
                other.shemeName == shemeName) &&
            (identical(other.breakTimeInSeconds, breakTimeInSeconds) ||
                other.breakTimeInSeconds == breakTimeInSeconds) &&
            (identical(
                    other.shortBreakTimeInSeconds, shortBreakTimeInSeconds) ||
                other.shortBreakTimeInSeconds == shortBreakTimeInSeconds) &&
            (identical(
                    other.workSessionTimeInSeconds, workSessionTimeInSeconds) ||
                other.workSessionTimeInSeconds == workSessionTimeInSeconds) &&
            (identical(other.numberOfSessionsBeforeLongBreak,
                    numberOfSessionsBeforeLongBreak) ||
                other.numberOfSessionsBeforeLongBreak ==
                    numberOfSessionsBeforeLongBreak));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      shemeName,
      breakTimeInSeconds,
      shortBreakTimeInSeconds,
      workSessionTimeInSeconds,
      numberOfSessionsBeforeLongBreak);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PomodoroShemeModelImplCopyWith<_$PomodoroShemeModelImpl> get copyWith =>
      __$$PomodoroShemeModelImplCopyWithImpl<_$PomodoroShemeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PomodoroShemeModelImplToJson(
      this,
    );
  }
}

abstract class _PomodoroShemeModel implements PomodoroShemeModel {
  factory _PomodoroShemeModel(
          {required final String shemeName,
          required final int breakTimeInSeconds,
          required final int shortBreakTimeInSeconds,
          required final int workSessionTimeInSeconds,
          required final int numberOfSessionsBeforeLongBreak}) =
      _$PomodoroShemeModelImpl;

  factory _PomodoroShemeModel.fromJson(Map<String, dynamic> json) =
      _$PomodoroShemeModelImpl.fromJson;

  @override
  String get shemeName;
  @override
  int get breakTimeInSeconds;
  @override
  int get shortBreakTimeInSeconds;
  @override
  int get workSessionTimeInSeconds;
  @override
  int get numberOfSessionsBeforeLongBreak;
  @override
  @JsonKey(ignore: true)
  _$$PomodoroShemeModelImplCopyWith<_$PomodoroShemeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
