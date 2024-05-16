// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallpapersControllerStateModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WallpapersControllerStateModel _$WallpapersControllerStateModelFromJson(
    Map<String, dynamic> json) {
  return _WallpapersControllerStateModel.fromJson(json);
}

/// @nodoc
mixin _$WallpapersControllerStateModel {
  WallpapersState get state => throw _privateConstructorUsedError;
  int get loadingProcent => throw _privateConstructorUsedError;
  String get linkToCurrentWallpaper => throw _privateConstructorUsedError;
  String get fullPathToCurrentWallpapers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WallpapersControllerStateModelCopyWith<WallpapersControllerStateModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WallpapersControllerStateModelCopyWith<$Res> {
  factory $WallpapersControllerStateModelCopyWith(
          WallpapersControllerStateModel value,
          $Res Function(WallpapersControllerStateModel) then) =
      _$WallpapersControllerStateModelCopyWithImpl<$Res,
          WallpapersControllerStateModel>;
  @useResult
  $Res call(
      {WallpapersState state,
      int loadingProcent,
      String linkToCurrentWallpaper,
      String fullPathToCurrentWallpapers});
}

/// @nodoc
class _$WallpapersControllerStateModelCopyWithImpl<$Res,
        $Val extends WallpapersControllerStateModel>
    implements $WallpapersControllerStateModelCopyWith<$Res> {
  _$WallpapersControllerStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? loadingProcent = null,
    Object? linkToCurrentWallpaper = null,
    Object? fullPathToCurrentWallpapers = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as WallpapersState,
      loadingProcent: null == loadingProcent
          ? _value.loadingProcent
          : loadingProcent // ignore: cast_nullable_to_non_nullable
              as int,
      linkToCurrentWallpaper: null == linkToCurrentWallpaper
          ? _value.linkToCurrentWallpaper
          : linkToCurrentWallpaper // ignore: cast_nullable_to_non_nullable
              as String,
      fullPathToCurrentWallpapers: null == fullPathToCurrentWallpapers
          ? _value.fullPathToCurrentWallpapers
          : fullPathToCurrentWallpapers // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WallpapersControllerStateModelImplCopyWith<$Res>
    implements $WallpapersControllerStateModelCopyWith<$Res> {
  factory _$$WallpapersControllerStateModelImplCopyWith(
          _$WallpapersControllerStateModelImpl value,
          $Res Function(_$WallpapersControllerStateModelImpl) then) =
      __$$WallpapersControllerStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WallpapersState state,
      int loadingProcent,
      String linkToCurrentWallpaper,
      String fullPathToCurrentWallpapers});
}

/// @nodoc
class __$$WallpapersControllerStateModelImplCopyWithImpl<$Res>
    extends _$WallpapersControllerStateModelCopyWithImpl<$Res,
        _$WallpapersControllerStateModelImpl>
    implements _$$WallpapersControllerStateModelImplCopyWith<$Res> {
  __$$WallpapersControllerStateModelImplCopyWithImpl(
      _$WallpapersControllerStateModelImpl _value,
      $Res Function(_$WallpapersControllerStateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? loadingProcent = null,
    Object? linkToCurrentWallpaper = null,
    Object? fullPathToCurrentWallpapers = null,
  }) {
    return _then(_$WallpapersControllerStateModelImpl(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as WallpapersState,
      loadingProcent: null == loadingProcent
          ? _value.loadingProcent
          : loadingProcent // ignore: cast_nullable_to_non_nullable
              as int,
      linkToCurrentWallpaper: null == linkToCurrentWallpaper
          ? _value.linkToCurrentWallpaper
          : linkToCurrentWallpaper // ignore: cast_nullable_to_non_nullable
              as String,
      fullPathToCurrentWallpapers: null == fullPathToCurrentWallpapers
          ? _value.fullPathToCurrentWallpapers
          : fullPathToCurrentWallpapers // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WallpapersControllerStateModelImpl
    implements _WallpapersControllerStateModel {
  _$WallpapersControllerStateModelImpl(
      {required this.state,
      required this.loadingProcent,
      required this.linkToCurrentWallpaper,
      required this.fullPathToCurrentWallpapers});

  factory _$WallpapersControllerStateModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WallpapersControllerStateModelImplFromJson(json);

  @override
  final WallpapersState state;
  @override
  final int loadingProcent;
  @override
  final String linkToCurrentWallpaper;
  @override
  final String fullPathToCurrentWallpapers;

  @override
  String toString() {
    return 'WallpapersControllerStateModel(state: $state, loadingProcent: $loadingProcent, linkToCurrentWallpaper: $linkToCurrentWallpaper, fullPathToCurrentWallpapers: $fullPathToCurrentWallpapers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WallpapersControllerStateModelImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.loadingProcent, loadingProcent) ||
                other.loadingProcent == loadingProcent) &&
            (identical(other.linkToCurrentWallpaper, linkToCurrentWallpaper) ||
                other.linkToCurrentWallpaper == linkToCurrentWallpaper) &&
            (identical(other.fullPathToCurrentWallpapers,
                    fullPathToCurrentWallpapers) ||
                other.fullPathToCurrentWallpapers ==
                    fullPathToCurrentWallpapers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, state, loadingProcent,
      linkToCurrentWallpaper, fullPathToCurrentWallpapers);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WallpapersControllerStateModelImplCopyWith<
          _$WallpapersControllerStateModelImpl>
      get copyWith => __$$WallpapersControllerStateModelImplCopyWithImpl<
          _$WallpapersControllerStateModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WallpapersControllerStateModelImplToJson(
      this,
    );
  }
}

abstract class _WallpapersControllerStateModel
    implements WallpapersControllerStateModel {
  factory _WallpapersControllerStateModel(
          {required final WallpapersState state,
          required final int loadingProcent,
          required final String linkToCurrentWallpaper,
          required final String fullPathToCurrentWallpapers}) =
      _$WallpapersControllerStateModelImpl;

  factory _WallpapersControllerStateModel.fromJson(Map<String, dynamic> json) =
      _$WallpapersControllerStateModelImpl.fromJson;

  @override
  WallpapersState get state;
  @override
  int get loadingProcent;
  @override
  String get linkToCurrentWallpaper;
  @override
  String get fullPathToCurrentWallpapers;
  @override
  @JsonKey(ignore: true)
  _$$WallpapersControllerStateModelImplCopyWith<
          _$WallpapersControllerStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
