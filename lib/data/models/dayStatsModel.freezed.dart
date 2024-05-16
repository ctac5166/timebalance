// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dayStatsModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DayStatsModel _$DayStatsModelFromJson(Map<String, dynamic> json) {
  return _DayStatsModel.fromJson(json);
}

/// @nodoc
mixin _$DayStatsModel {
  String get shemeName => throw _privateConstructorUsedError;
  DateTime get statsDate => throw _privateConstructorUsedError;
  int get maximumWorkTimeDuringThisInterval =>
      throw _privateConstructorUsedError;
  int get totalWorkTimeForTheEntireInterval =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DayStatsModelCopyWith<DayStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayStatsModelCopyWith<$Res> {
  factory $DayStatsModelCopyWith(
          DayStatsModel value, $Res Function(DayStatsModel) then) =
      _$DayStatsModelCopyWithImpl<$Res, DayStatsModel>;
  @useResult
  $Res call(
      {String shemeName,
      DateTime statsDate,
      int maximumWorkTimeDuringThisInterval,
      int totalWorkTimeForTheEntireInterval});
}

/// @nodoc
class _$DayStatsModelCopyWithImpl<$Res, $Val extends DayStatsModel>
    implements $DayStatsModelCopyWith<$Res> {
  _$DayStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shemeName = null,
    Object? statsDate = null,
    Object? maximumWorkTimeDuringThisInterval = null,
    Object? totalWorkTimeForTheEntireInterval = null,
  }) {
    return _then(_value.copyWith(
      shemeName: null == shemeName
          ? _value.shemeName
          : shemeName // ignore: cast_nullable_to_non_nullable
              as String,
      statsDate: null == statsDate
          ? _value.statsDate
          : statsDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maximumWorkTimeDuringThisInterval: null ==
              maximumWorkTimeDuringThisInterval
          ? _value.maximumWorkTimeDuringThisInterval
          : maximumWorkTimeDuringThisInterval // ignore: cast_nullable_to_non_nullable
              as int,
      totalWorkTimeForTheEntireInterval: null ==
              totalWorkTimeForTheEntireInterval
          ? _value.totalWorkTimeForTheEntireInterval
          : totalWorkTimeForTheEntireInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DayStatsModelImplCopyWith<$Res>
    implements $DayStatsModelCopyWith<$Res> {
  factory _$$DayStatsModelImplCopyWith(
          _$DayStatsModelImpl value, $Res Function(_$DayStatsModelImpl) then) =
      __$$DayStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shemeName,
      DateTime statsDate,
      int maximumWorkTimeDuringThisInterval,
      int totalWorkTimeForTheEntireInterval});
}

/// @nodoc
class __$$DayStatsModelImplCopyWithImpl<$Res>
    extends _$DayStatsModelCopyWithImpl<$Res, _$DayStatsModelImpl>
    implements _$$DayStatsModelImplCopyWith<$Res> {
  __$$DayStatsModelImplCopyWithImpl(
      _$DayStatsModelImpl _value, $Res Function(_$DayStatsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shemeName = null,
    Object? statsDate = null,
    Object? maximumWorkTimeDuringThisInterval = null,
    Object? totalWorkTimeForTheEntireInterval = null,
  }) {
    return _then(_$DayStatsModelImpl(
      shemeName: null == shemeName
          ? _value.shemeName
          : shemeName // ignore: cast_nullable_to_non_nullable
              as String,
      statsDate: null == statsDate
          ? _value.statsDate
          : statsDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maximumWorkTimeDuringThisInterval: null ==
              maximumWorkTimeDuringThisInterval
          ? _value.maximumWorkTimeDuringThisInterval
          : maximumWorkTimeDuringThisInterval // ignore: cast_nullable_to_non_nullable
              as int,
      totalWorkTimeForTheEntireInterval: null ==
              totalWorkTimeForTheEntireInterval
          ? _value.totalWorkTimeForTheEntireInterval
          : totalWorkTimeForTheEntireInterval // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DayStatsModelImpl implements _DayStatsModel {
  _$DayStatsModelImpl(
      {required this.shemeName,
      required this.statsDate,
      required this.maximumWorkTimeDuringThisInterval,
      required this.totalWorkTimeForTheEntireInterval});

  factory _$DayStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayStatsModelImplFromJson(json);

  @override
  final String shemeName;
  @override
  final DateTime statsDate;
  @override
  final int maximumWorkTimeDuringThisInterval;
  @override
  final int totalWorkTimeForTheEntireInterval;

  @override
  String toString() {
    return 'DayStatsModel(shemeName: $shemeName, statsDate: $statsDate, maximumWorkTimeDuringThisInterval: $maximumWorkTimeDuringThisInterval, totalWorkTimeForTheEntireInterval: $totalWorkTimeForTheEntireInterval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayStatsModelImpl &&
            (identical(other.shemeName, shemeName) ||
                other.shemeName == shemeName) &&
            (identical(other.statsDate, statsDate) ||
                other.statsDate == statsDate) &&
            (identical(other.maximumWorkTimeDuringThisInterval,
                    maximumWorkTimeDuringThisInterval) ||
                other.maximumWorkTimeDuringThisInterval ==
                    maximumWorkTimeDuringThisInterval) &&
            (identical(other.totalWorkTimeForTheEntireInterval,
                    totalWorkTimeForTheEntireInterval) ||
                other.totalWorkTimeForTheEntireInterval ==
                    totalWorkTimeForTheEntireInterval));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, shemeName, statsDate,
      maximumWorkTimeDuringThisInterval, totalWorkTimeForTheEntireInterval);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DayStatsModelImplCopyWith<_$DayStatsModelImpl> get copyWith =>
      __$$DayStatsModelImplCopyWithImpl<_$DayStatsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DayStatsModelImplToJson(
      this,
    );
  }
}

abstract class _DayStatsModel implements DayStatsModel {
  factory _DayStatsModel(
          {required final String shemeName,
          required final DateTime statsDate,
          required final int maximumWorkTimeDuringThisInterval,
          required final int totalWorkTimeForTheEntireInterval}) =
      _$DayStatsModelImpl;

  factory _DayStatsModel.fromJson(Map<String, dynamic> json) =
      _$DayStatsModelImpl.fromJson;

  @override
  String get shemeName;
  @override
  DateTime get statsDate;
  @override
  int get maximumWorkTimeDuringThisInterval;
  @override
  int get totalWorkTimeForTheEntireInterval;
  @override
  @JsonKey(ignore: true)
  _$$DayStatsModelImplCopyWith<_$DayStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
