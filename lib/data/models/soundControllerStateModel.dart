import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'soundControllerStateModel.freezed.dart';
part 'soundControllerStateModel.g.dart';

@Entity()
class SoundControllerStateEntity {
  int id;
  String breakSound;
  String workSound;
  bool playWorkSound;
  bool playBreakSound;
  double soundsVolume;
  SoundControllerStateEntity({
    this.id = 0,
    required this.breakSound,
    required this.workSound,
    required this.playWorkSound,
    required this.playBreakSound,
    required this.soundsVolume,
  });
}

@freezed
class SoundControllerStateModel with _$SoundControllerStateModel {
  factory SoundControllerStateModel({
    required String breakSound,
    required String workSound,
    required bool playWorkSound,
    required bool playBreakSound,
    required double soundsVolume,
  }) = _SoundControllerStateModel;

  factory SoundControllerStateModel.fromJson(Map<String, dynamic> json) =>
      _$SoundControllerStateModelFromJson(json);
}
