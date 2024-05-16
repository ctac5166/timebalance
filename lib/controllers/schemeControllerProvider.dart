import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:timebalance/data/models/pomodoroShemeModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/objectbox.g.dart';

final schemeControllerProvider =
    StateNotifierProvider<PomodoroSchemeNotifier, List<PomodoroShemeModel>>(
        (ref) {
  return PomodoroSchemeNotifier();
});

class PomodoroSchemeNotifier extends StateNotifier<List<PomodoroShemeModel>> {
  Store? _store;
  late final Box<PomodoroShemeEntity> _box;
  bool loading = false;

  bool get isLoading => loading;

  void setIsLoadingState(bool newValue) {
    loading = newValue;
  }

  PomodoroSchemeNotifier() : super([]) {
    init();
  }

  Future init() async {
    _box = schemeBox;
    await loadAllSchemes();
  }

  Future clearSchemes() async {
    state = [];
  }

  Future loadAllSchemes() async {
    setIsLoadingState(true);
    final entities = await _box.getAllAsync();
    var models = entities
        .map((e) => PomodoroShemeModel(
              shemeName: e.shemeName,
              breakTimeInSeconds: e.breakTimeInSeconds,
              shortBreakTimeInSeconds: e.shortBreakTimeInSeconds,
              workSessionTimeInSeconds: e.workSessionTimeInSeconds,
              numberOfSessionsBeforeLongBreak:
                  e.numberOfSessionsBeforeLongBreak,
            ))
        .toList();

    models.addAll([
      if (!kReleaseMode)
        PomodoroShemeModel(
          shemeName: "DEBUG",
          breakTimeInSeconds: 10,
          shortBreakTimeInSeconds: 5,
          workSessionTimeInSeconds: 10,
          numberOfSessionsBeforeLongBreak: 3,
        ),
      PomodoroShemeModel(
        shemeName: "обычный",
        breakTimeInSeconds: 50 * 60,
        shortBreakTimeInSeconds: 8 * 60,
        workSessionTimeInSeconds: 25 * 60,
        numberOfSessionsBeforeLongBreak: 4,
      ),
      PomodoroShemeModel(
        shemeName: "длинный",
        breakTimeInSeconds: 72 * 60,
        shortBreakTimeInSeconds: 11 * 60,
        workSessionTimeInSeconds: 50 * 60,
        numberOfSessionsBeforeLongBreak: 3,
      ),
      PomodoroShemeModel(
        shemeName: "короткий",
        breakTimeInSeconds: 36 * 60,
        shortBreakTimeInSeconds: 5 * 60,
        workSessionTimeInSeconds: 18 * 60,
        numberOfSessionsBeforeLongBreak: 3,
      )
    ]);

    clearSchemes();

    state = models;
    logger.d("схемы загружены");
    setIsLoadingState(false);
  }

  Future createNewScheme() async {
    setIsLoadingState(true);
    var currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    var newScheme = PomodoroShemeModel(
      shemeName: "помодоро - $currentTimeMillis",
      breakTimeInSeconds: 3000,
      shortBreakTimeInSeconds: 480,
      workSessionTimeInSeconds: 1500,
      numberOfSessionsBeforeLongBreak: 4,
    );

    var entity = PomodoroShemeEntity(
      shemeName: newScheme.shemeName,
      breakTimeInSeconds: newScheme.breakTimeInSeconds,
      shortBreakTimeInSeconds: newScheme.shortBreakTimeInSeconds,
      workSessionTimeInSeconds: newScheme.workSessionTimeInSeconds,
      numberOfSessionsBeforeLongBreak:
          newScheme.numberOfSessionsBeforeLongBreak,
    );

    await _box.putAsync(entity);
    state = [...state, newScheme];
    setIsLoadingState(false);
  }

  Future deleteScheme(String name) async {
    setIsLoadingState(true);
    final schemes =
        _box.query(PomodoroShemeEntity_.shemeName.equals(name)).build().find();
    for (var scheme in schemes) {
      if (!["обычный", "длинный", "короткий", "DEBUG"]
          .contains(scheme.shemeName)) {
        await _box.removeAsync(scheme.id); // Используем асинхронное удаление
      }
    }
    await loadAllSchemes(); // Обновляем состояние после удаления
    logger.d("схема удалена и состояние обновлено");
    setIsLoadingState(false);
  }

  Future updateScheme(PomodoroShemeModel model, String shemeName) async {
    setIsLoadingState(true);
    var existing = await _box
        .query(PomodoroShemeEntity_.shemeName.equals(shemeName))
        .build()
        .findFirstAsync();
    if (existing != null) {
      existing.shemeName = model.shemeName;
      existing.breakTimeInSeconds = model.breakTimeInSeconds;
      existing.shortBreakTimeInSeconds = model.shortBreakTimeInSeconds;
      existing.workSessionTimeInSeconds = model.workSessionTimeInSeconds;
      existing.numberOfSessionsBeforeLongBreak =
          model.numberOfSessionsBeforeLongBreak;
      logger.d("схема обновлена");
      await _box.putAsync(existing);
      await loadAllSchemes();
    } else {
      logger.i("схема с именем $shemeName - не найдена");
    }
    setIsLoadingState(false);
  }
}
