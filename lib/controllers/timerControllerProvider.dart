import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/data/models/dayStatsModel.dart';
import 'package:timebalance/data/models/pomodoroShemeModel.dart';
import 'package:timebalance/data/models/soundControllerStateModel.dart';
import 'package:timebalance/data/models/timerStateModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/objectbox.g.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds = 2000});

  cancle() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

final timerControllerProvider =
    StateNotifierProvider<TimerController, TimerStateModel>(
  (ref) => TimerController(),
);

class TimerController extends StateNotifier<TimerStateModel> {
  Timer? _timer;
  List<PomodoroShemeModel> schemes = [
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
  ];
  int currentSchemeId = 0;
  int sessionsCompleted = 0;

  int currentStageStartTime = 0;

  Store? _store;
  late Box<DayStatsEntity> box;
  late Box<PomodoroShemeEntity> boxShemes;
  late Box<TimerStateEntity> boxTimerState;

  final AudioPlayer audioPlayer = AudioPlayer();
  late final Box<SoundControllerStateEntity> boxSoundSettings;
  late SoundControllerStateModel soundSettings;

  final debouncer = Debouncer(milliseconds: 5000);

  void updateSchemes(List<PomodoroShemeModel> newSchemeList) {
    schemes = newSchemeList;
  }

  int getCompletedSessions() {
    return sessionsCompleted;
  }

  PomodoroShemeModel getCurrentScheme() {
    return schemes[currentSchemeId];
  }

  TimerController()
      : super(TimerStateModel(
          breakStepAutomatically: true,
          workStepAutomatically: false,
          selectedShemeName: "обычный",
          dayStatistics: DayStatsModel(
            shemeName: "обычный",
            statsDate: DateTime.now(),
            maximumWorkTimeDuringThisInterval: 0,
            totalWorkTimeForTheEntireInterval: 0,
          ),
          currentState: StepType.off, // Start in delay before work
          remainingTimeInSeconds: 0, // Initially 0, indicating paused state
        )) {
    _initObjectBox();
  }

  PomodoroShemeEntity? getPomodoroShemeByName(String shemeName) {
    final query = boxShemes
        .query(PomodoroShemeEntity_.shemeName.equals(shemeName))
        .build();
    log("|🔍|-> найдено PomodoroShemeEntity: ${query.find().length}");
    final result = query.findFirst();
    query.close();
    return result;
  }

  DayStatsEntity? getDayStatsEntityByNameAndDate(
      String dayShemeName, DateTime date) {
    final query = box
        .query(DayStatsEntity_.shemeName
            .equals(dayShemeName)
            .and(DayStatsEntity_.statsDate.equals(date.millisecondsSinceEpoch)))
        .build();
    log("|🔍|-> найдено DayStatsEntity: ${query.find().length}");
    final result = query.findFirst();
    query.close();
    return result;
  }

  void startTimer({bool userInput = false}) {
    if (_timer == null || !_timer!.isActive) {
      if (currentStageStartTime == 0) {
        currentStageStartTime = DateTime.now().millisecondsSinceEpoch;
      }
      _startTimer(userInput: userInput);
    }
    if (state.currentState == StepType.off) {
      if (currentStageStartTime == 0) {
        currentStageStartTime = DateTime.now().millisecondsSinceEpoch;
      }
      playSound("carbonate");
      switchToWork();
    }
  }

  void pauseTimer() {
    if (countdownTimer.timerIsActive() && countdownTimer.isRunning) {
      countdownTimer.stopTimer();
    } else {
      debouncer.cancle();
    }
    log("|-> pauseTimer, ${state.currentState}=state.currentState");
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(
      currentState: state.currentState == StepType.work
          ? StepType.pause
          : state.currentState == StepType.longBreak
              ? StepType.longDelayBeforeWork
              : state.currentState == StepType.shortBreak
                  ? StepType.delayBeforeWork
                  : state.currentState,
    );
    log("|-> new state, ${state.currentState}=state.currentState");
  }

  void stopTimer({bool completeStop = false}) {
    if (countdownTimer.timerIsActive()) {
      countdownTimer.stopTimer();
      countdownTimer.completeNotification();
    } else {
      debouncer.cancle();
    }
    state = state.copyWith(
      currentState: completeStop ? StepType.off : StepType.delayBeforeWork,
      remainingTimeInSeconds: 0,
    );
    if (completeStop) {
      _saveDayStatistics();
      state = state.copyWith(currentState: StepType.off);
      currentStageStartTime = 0;
      sessionsCompleted = 0;
    }
  }

  void switchToWork() {
    log("|-> switchToWork, ${state.currentState}=state.currentState, ");
    debouncer.run(() {
      countdownTimer
          .startTimer(schemes[currentSchemeId].workSessionTimeInSeconds);
    });
    state = state.copyWith(
      currentState: StepType.work,
      remainingTimeInSeconds: schemes[currentSchemeId].workSessionTimeInSeconds,
    );
  }

  void _startTimer({bool userInput = false}) {
    log("|-> start timer, ${state.currentState}=state.currentState");
    if (countdownTimer.timerIsActive() && !countdownTimer.isRunning) {
      countdownTimer.resumeTimer();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTimeInSeconds > 0) {
        state = state.copyWith(
          dayStatistics: state.dayStatistics.copyWith(
              totalWorkTimeForTheEntireInterval:
                  state.dayStatistics.totalWorkTimeForTheEntireInterval +
                      (state.currentState == StepType.work ? 1 : 0)),
          remainingTimeInSeconds: state.remainingTimeInSeconds - 1,
          currentState: state.currentState == StepType.longDelayBeforeWork
              ? StepType.longBreak
              : state.currentState == StepType.delayBeforeWork
                  ? StepType.shortBreak
                  : state.currentState == StepType.pause
                      ? StepType.work
                      : state.currentState,
        );
        log("|timer tik|");
        //log("new step - ${state.currentState}");
      } else {
        transitionToNextStep(userInput: userInput);
      }
    });
    log("|-> new state, ${state.currentState}=state.currentState");
  }

  Future saveTimerState() async {
    boxTimerState.put(TimerStateEntity(
        currentState: state.currentState.toString(),
        workStepAutomatically: state.workStepAutomatically,
        breakStepAutomatically: state.breakStepAutomatically,
        remainingTimeInSeconds: state.remainingTimeInSeconds,
        selectedShemeName: state.selectedShemeName));
    log("|💾|-> timer state сохранен");
  }

  void transitionToNextStep({bool stageSkip = false, bool userInput = false}) {
    final scheme = schemes[currentSchemeId];
    switch (state.currentState) {
      case StepType.work:
        sessionsCompleted++;
        int previousTime = state.remainingTimeInSeconds;
        if (sessionsCompleted % scheme.numberOfSessionsBeforeLongBreak == 0) {
          countdownTimer.title = "Длинный Перерыв";
          debouncer.run(() {
            countdownTimer.startTimer(scheme.breakTimeInSeconds);
          });
          state = state.copyWith(
            currentState: StepType.longBreak,
            remainingTimeInSeconds: scheme.breakTimeInSeconds,
          );
        } else {
          countdownTimer.title = "Перерыв";
          debouncer.run(() {
            countdownTimer.startTimer(scheme.shortBreakTimeInSeconds);
          });
          state = state.copyWith(
            currentState: StepType.shortBreak,
            remainingTimeInSeconds: scheme.shortBreakTimeInSeconds,
          );
        }
        if (!stageSkip) {
          playSound(soundSettings.breakSound);
          state = state.copyWith(
              dayStatistics: state.dayStatistics.copyWith(
                  maximumWorkTimeDuringThisInterval:
                      state.dayStatistics.maximumWorkTimeDuringThisInterval +
                          scheme.workSessionTimeInSeconds));
        }

        break;
      case StepType.shortBreak:
      case StepType.longBreak:
        state = state.copyWith(
          currentState: !state.workStepAutomatically
              ? userInput
                  ? StepType.work
                  : StepType.delayBeforeWork
              : StepType.work,
          remainingTimeInSeconds: scheme.workSessionTimeInSeconds,
        );
        countdownTimer.title = "Концентрация";
        debouncer.run(() {
          countdownTimer.startTimer(scheme.workSessionTimeInSeconds);
        });
        if (state.workStepAutomatically && countdownTimer.timerIsActive()) {
          countdownTimer.stopTimer();
        }
        log("|🛠️|-> переключение на рабочий режим - $userInput=userInput, $stageSkip=stageSkip");
        if (!stageSkip) playSound(soundSettings.workSound);
        if (!userInput) {
          currentStageStartTime = DateTime.now().millisecondsSinceEpoch;
        }
        if (currentStageStartTime == 0) {
          currentStageStartTime = DateTime.now().millisecondsSinceEpoch;
        }

        break;
      case StepType.off:
        countdownTimer.completeNotification();
        state = state.copyWith(
          currentState: StepType.work,
          remainingTimeInSeconds: scheme.workSessionTimeInSeconds,
          dayStatistics: state.dayStatistics.copyWith(
              maximumWorkTimeDuringThisInterval:
                  state.dayStatistics.maximumWorkTimeDuringThisInterval +
                      scheme.workSessionTimeInSeconds),
        );
        currentStageStartTime = DateTime.now().millisecondsSinceEpoch;

        break;
      default:
        break;
    }
    _saveDayStatistics();
    saveTimerState();
  }

  DateTime getClearedDateTime() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    return startOfDay;
  }

  String formatTime(int? seconds, bool pad) {
    return (pad)
        ? "${(seconds! / 60).floor()}:${(seconds % 60).toString().padLeft(2, "0")}"
        : (seconds! > 59)
            ? "${(seconds / 60).floor()}:${(seconds % 60).toString().padLeft(2, "0")}"
            : seconds.toString();
  }

  void _initObjectBox() async {
    final store = objectbox.store;
    _store = store;
    box = store.box<DayStatsEntity>();
    boxTimerState = store.box<TimerStateEntity>();
    boxSoundSettings = store.box<SoundControllerStateEntity>();
    var loadedTimerState = await boxTimerState.getAllAsync();
    if (loadedTimerState.isNotEmpty) {
      var currentState = StepType.delayBeforeWork;
      switch (loadedTimerState.first.currentState) {
        case "delayBeforeWork":
          currentState = StepType.delayBeforeWork;
          break;
        case "delayBeforeLongBreak":
          currentState = StepType.delayBeforeLongBreak;
          break;
        case "delayBeforeShortBreak":
          currentState = StepType.delayBeforeShortBreak;
          break;
        case "longBreak":
          currentState = StepType.longBreak;
          break;
        case "longDelayBeforeWork":
          currentState = StepType.longDelayBeforeWork;
          break;
        case "pause":
          currentState = StepType.pause;
          break;
        case "off":
          currentState = StepType.off;
          break;
        case "shortBreak":
          currentState = StepType.shortBreak;
          break;
        case "work":
          currentState = StepType.work;
          break;
      }
      var dayStatsEntity = getDayStatsEntityByNameAndDate(
              loadedTimerState.first.selectedShemeName, getClearedDateTime()) ??
          DayStatsEntity(
              shemeName: loadedTimerState.first.selectedShemeName,
              statsDate: getClearedDateTime(),
              maximumWorkTimeDuringThisInterval:
                  state.dayStatistics.maximumWorkTimeDuringThisInterval,
              totalWorkTimeForTheEntireInterval:
                  state.dayStatistics.totalWorkTimeForTheEntireInterval);
      log("|⚙️✅|-> загружены настройки dayStatsEntity - ${dayStatsEntity.shemeName}=shemeName, ${dayStatsEntity.maximumWorkTimeDuringThisInterval}=max, ${dayStatsEntity.totalWorkTimeForTheEntireInterval}=total");
      state = TimerStateModel(
          breakStepAutomatically: loadedTimerState.first.breakStepAutomatically,
          workStepAutomatically: loadedTimerState.first.workStepAutomatically,
          dayStatistics: DayStatsModel(
            shemeName: loadedTimerState.first.selectedShemeName,
            statsDate: dayStatsEntity.statsDate,
            maximumWorkTimeDuringThisInterval:
                dayStatsEntity.maximumWorkTimeDuringThisInterval,
            totalWorkTimeForTheEntireInterval:
                dayStatsEntity.totalWorkTimeForTheEntireInterval,
          ),
          currentState: currentState,
          remainingTimeInSeconds: loadedTimerState.first.remainingTimeInSeconds,
          selectedShemeName: loadedTimerState.first.selectedShemeName);
    }
    final entity = boxSoundSettings.get(1);
    if (entity != null) {
      soundSettings = SoundControllerStateModel(
        breakSound: entity.breakSound,
        workSound: entity.workSound,
        playWorkSound: entity.playWorkSound,
        playBreakSound: entity.playBreakSound,
        soundsVolume: entity.soundsVolume,
      );
    } else {
      soundSettings = SoundControllerStateModel(
          breakSound: 'moondrop.mp3',
          workSound: 'everblue.mp3',
          playWorkSound: true,
          playBreakSound: true,
          soundsVolume: 0.5);
    }
    log(state.currentState.toString());
    log(state.remainingTimeInSeconds.toString());
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());
    // audioPlayer.playbackEventStream.listen((event) {},
    //     onError: (Object e, StackTrace stackTrace) {
    //   log('A stream error occurred: $e');
    // });

    boxShemes = schemeBox;

    changeSheme(state.dayStatistics.shemeName);
  }

  Future<void> playSound(String soundName) async {
    try {
      if ((soundName == soundSettings.workSound &&
              soundSettings.playWorkSound) ||
          (soundName == soundSettings.breakSound &&
              soundSettings.playBreakSound)) {
        audioPlayer.setAudioContext(
          AudioContext(
            iOS: AudioContextIOS(
              category: AVAudioSessionCategory.playback,
              options: const {
                AVAudioSessionOptions.mixWithOthers,
              },
            ),
            android: const AudioContextAndroid(
              contentType: AndroidContentType.music,
              usageType: AndroidUsageType.notification,
              audioFocus: AndroidAudioFocus.gainTransient,
            ),
          ),
        );

        await audioPlayer.play(AssetSource('sounds/$soundName'));
      }
    } catch (e, stackTrace) {
      logger.e(
          'Error playing sound: $e, stack trace: $stackTrace, assets/sounds/$soundName=soundName');
    }
  }

  void setVolume(double volume) {
    soundSettings = soundSettings.copyWith(soundsVolume: volume);
    audioPlayer.setVolume(volume);
    saveSoundSettings();
  }

  void updateSoundSettings(SoundControllerStateModel newState) {
    soundSettings = newState;
    saveSoundSettings();
  }

  Future saveSoundSettings() async {
    final entity = SoundControllerStateEntity(
      breakSound: soundSettings.breakSound,
      workSound: soundSettings.workSound,
      playWorkSound: soundSettings.playWorkSound,
      playBreakSound: soundSettings.playBreakSound,
      soundsVolume: soundSettings.soundsVolume,
    );
    await boxSoundSettings.putAsync(entity);
  }

  Future changeSheme(String newShemeName) async {
    if (schemes.indexWhere((element) => element.shemeName == newShemeName) !=
        -1) {
      pauseTimer();
      stopTimer(completeStop: true);
      if (countdownTimer.timerIsActive()) {
        countdownTimer.completeNotification();
      } else {
        debouncer.cancle();
      }
      currentSchemeId =
          schemes.indexWhere((element) => element.shemeName == newShemeName);
      var dayStatsEntity =
          getDayStatsEntityByNameAndDate(newShemeName, getClearedDateTime()) ??
              DayStatsEntity(
                  shemeName: newShemeName,
                  statsDate: getClearedDateTime(),
                  maximumWorkTimeDuringThisInterval: 0,
                  totalWorkTimeForTheEntireInterval: 0);
      state = state.copyWith(
          remainingTimeInSeconds: 0,
          selectedShemeName: newShemeName,
          currentState: StepType.off,
          dayStatistics: state.dayStatistics.copyWith(
            shemeName: dayStatsEntity.shemeName,
            maximumWorkTimeDuringThisInterval:
                dayStatsEntity.maximumWorkTimeDuringThisInterval,
            totalWorkTimeForTheEntireInterval:
                dayStatsEntity.totalWorkTimeForTheEntireInterval,
            statsDate: dayStatsEntity.statsDate,
          ));

      // startTimer(userInput: true);
    }
  }

  void resetStep() {
    if (state.currentState == StepType.work ||
        state.currentState == StepType.pause ||
        state.currentState == StepType.delayBeforeLongBreak ||
        state.currentState == StepType.delayBeforeShortBreak) {
      countdownTimer.title = "Концентрация";
      // if (countdownTimer.timerIsActive()) {
      //   countdownTimer.stopTimer();
      // } else {
      //   debouncer.cancle();
      // }
      debouncer.run(() {
        countdownTimer
            .startTimer(schemes[currentSchemeId].workSessionTimeInSeconds);
      });
      state = state.copyWith(
          dayStatistics: state.dayStatistics.copyWith(
              maximumWorkTimeDuringThisInterval:
                  state.dayStatistics.maximumWorkTimeDuringThisInterval +
                      (schemes[currentSchemeId].workSessionTimeInSeconds -
                          state.remainingTimeInSeconds)),
          remainingTimeInSeconds:
              schemes[currentSchemeId].workSessionTimeInSeconds);
    } else if (state.currentState == StepType.delayBeforeWork ||
        state.currentState == StepType.shortBreak) {
      countdownTimer.title = "Перерыв";
      // if (countdownTimer.timerIsActive()) {
      //   countdownTimer.stopTimer();
      // } else {
      //   debouncer.cancle();
      // }
      debouncer.run(() {
        countdownTimer
            .startTimer(schemes[currentSchemeId].shortBreakTimeInSeconds);
      });
      state = state.copyWith(
          dayStatistics: state.dayStatistics.copyWith(
              totalWorkTimeForTheEntireInterval:
                  state.dayStatistics.totalWorkTimeForTheEntireInterval -
                      (schemes[currentSchemeId].shortBreakTimeInSeconds -
                          state.remainingTimeInSeconds)),
          remainingTimeInSeconds:
              schemes[currentSchemeId].shortBreakTimeInSeconds);
    } else if (state.currentState == StepType.longDelayBeforeWork ||
        state.currentState == StepType.longBreak) {
      countdownTimer.title = "Длинный Перерыв";
      // if (countdownTimer.timerIsActive()) {
      //   countdownTimer.stopTimer();
      // } else {
      //   debouncer.cancle();
      // }
      debouncer.run(() {
        countdownTimer.startTimer(schemes[currentSchemeId].breakTimeInSeconds);
      });
      state = state.copyWith(
          dayStatistics: state.dayStatistics.copyWith(
              totalWorkTimeForTheEntireInterval:
                  state.dayStatistics.totalWorkTimeForTheEntireInterval -
                      (schemes[currentSchemeId].breakTimeInSeconds -
                          state.remainingTimeInSeconds)),
          remainingTimeInSeconds: schemes[currentSchemeId].breakTimeInSeconds);
    }
  }

  Future _saveDayStatistics() async {
    var dayStatsEntity = getDayStatsEntityByNameAndDate(
            state.dayStatistics.shemeName, getClearedDateTime()) ??
        DayStatsEntity(
            shemeName: state.selectedShemeName,
            statsDate: getClearedDateTime(),
            maximumWorkTimeDuringThisInterval:
                state.dayStatistics.maximumWorkTimeDuringThisInterval,
            totalWorkTimeForTheEntireInterval:
                state.dayStatistics.totalWorkTimeForTheEntireInterval);

    // Update properties based on the current state, ensuring all fields are set correctly
    dayStatsEntity.maximumWorkTimeDuringThisInterval =
        state.dayStatistics.maximumWorkTimeDuringThisInterval;
    dayStatsEntity.totalWorkTimeForTheEntireInterval = state
        .dayStatistics.totalWorkTimeForTheEntireInterval
        .clamp(0, state.dayStatistics.maximumWorkTimeDuringThisInterval);
    state = state.copyWith(
        dayStatistics: state.dayStatistics.copyWith(
            totalWorkTimeForTheEntireInterval:
                state.dayStatistics.totalWorkTimeForTheEntireInterval.clamp(
                    0, state.dayStatistics.maximumWorkTimeDuringThisInterval)));

    logger
        .w("попытка сохранить статистику работы - ${dayStatsEntity.statsDate}");

    await box.putAsync(dayStatsEntity);

    if (dayStatsEntity.totalWorkTimeForTheEntireInterval > 10 &&
        dayStatsEntity.maximumWorkTimeDuringThisInterval > 10) {
      log("""|🧠🔥|-> Day statistics saved or updated for ${dayStatsEntity.shemeName} / ${dayStatsEntity.statsDate}
    / $currentStageStartTime=currentStageStartTime
    / ${dayStatsEntity.maximumWorkTimeDuringThisInterval}=dayStatsEntity.maximumWorkTimeDuringThisInterval
    / ${dayStatsEntity.totalWorkTimeForTheEntireInterval}=dayStatsEntity.totalWorkTimeForTheEntireInterval
    / концентрация - ${((dayStatsEntity.totalWorkTimeForTheEntireInterval / dayStatsEntity.maximumWorkTimeDuringThisInterval) * 100).round()}%""");
    }
  }

  void addMinute() {
    if (state.currentState == StepType.work) {
      state = state.copyWith(
          dayStatistics: state.dayStatistics.copyWith(
              maximumWorkTimeDuringThisInterval:
                  state.dayStatistics.maximumWorkTimeDuringThisInterval + 60));
    } else if (state.dayStatistics.totalWorkTimeForTheEntireInterval != 0) {
      state = state.copyWith(
          dayStatistics: state.dayStatistics.copyWith(
              totalWorkTimeForTheEntireInterval:
                  (state.dayStatistics.totalWorkTimeForTheEntireInterval - 60)
                      .clamp(0, 999999999999999999)));
    }
    state = state.copyWith(
        remainingTimeInSeconds: state.remainingTimeInSeconds + 60);
  }

  void subtractMinute() {
    if (state.remainingTimeInSeconds > 60) {
      if (state.currentState == StepType.work) {
        state = state.copyWith(
            dayStatistics: state.dayStatistics.copyWith(
                totalWorkTimeForTheEntireInterval:
                    (state.dayStatistics.totalWorkTimeForTheEntireInterval - 60)
                        .clamp(
                            0,
                            state.dayStatistics
                                .totalWorkTimeForTheEntireInterval)));
      }
      state = state.copyWith(
          remainingTimeInSeconds: state.remainingTimeInSeconds - 60);
    } else {
      state = state.copyWith(remainingTimeInSeconds: 0);
      // _transitionToPreviousStep();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
