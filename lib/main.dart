import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:themed/themed.dart';
import 'package:timebalance/controllers/appSettingsControllerProvider.dart';
import 'package:timebalance/controllers/notificationControllerProvider.dart';
// import 'package:timebalance/controllers/notificationControllerProvider.dart';
import 'package:timebalance/controllers/objectBoxController.dart';
import 'package:timebalance/controllers/timerControllerProvider.dart';
import 'package:timebalance/data/models/pomodoroShemeModel.dart';
import 'package:timebalance/data/models/timerStateModel.dart';
import 'package:timebalance/data/models/userAppSettingsModel.dart';
import 'package:timebalance/logger_riverpod.dart';
import 'package:timebalance/objectbox.g.dart';
import 'package:timebalance/pages/mainPage.dart';
import 'package:timebalance/routes/router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

late ObjectBox objectbox;
late AudioSession audioSession;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final countdownTimer = CountdownTimer(flutterLocalNotificationsPlugin);

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

final logger = Logger();
late final Box<PomodoroShemeEntity> schemeBox;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  logger.i('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    logger.i(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  objectbox = await ObjectBox.create();

  schemeBox = objectbox.store.box<PomodoroShemeEntity>();

  audioSession = await AudioSession.instance;
  await audioSession.configure(const AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
    avAudioSessionMode: AVAudioSessionMode.defaultMode,
    avAudioSessionRouteSharingPolicy:
        AVAudioSessionRouteSharingPolicy.defaultPolicy,
    avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
  ));

  runApp(ProviderScope(
    observers: [
      LoggerRiverpod(),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

final workStepColorSet = [
  const ColorRef(Color.fromARGB(255, 255, 157, 157), id: 'workStepColorSet-1'),
  const ColorRef(Colors.pink, id: 'workStepColorSet-2'),
  const ColorRef(Color.fromARGB(255, 172, 39, 97), id: 'workStepColorSet-3'),
  const ColorRef(Color.fromARGB(255, 223, 89, 160), id: 'workStepColorSet-4')
];
final breakStepColorSet = [
  const ColorRef(Color.fromARGB(255, 235, 250, 166), id: 'breakStepColorSet-1'),
  const ColorRef(Color.fromARGB(255, 155, 224, 76), id: 'breakStepColorSet-2'),
  const ColorRef(Color.fromARGB(255, 89, 128, 27), id: 'breakStepColorSet-3'),
  const ColorRef(Color.fromARGB(255, 210, 223, 89), id: 'breakStepColorSet-4')
];
final longBreakStepColorSet = [
  const ColorRef(Color.fromARGB(255, 166, 226, 250),
      id: 'longBreakStepColorSet-1'),
  const ColorRef(Color.fromARGB(255, 76, 152, 224),
      id: 'longBreakStepColorSet-2'),
  const ColorRef(Color.fromARGB(255, 27, 113, 128),
      id: 'longBreakStepColorSet-3'),
  const ColorRef(Color.fromARGB(255, 89, 152, 223),
      id: 'longBreakStepColorSet-4')
];
final pauseStepColorSet = [
  const ColorRef(Color.fromARGB(255, 19, 19, 19), id: 'pauseStepColorSet-1'),
  const ColorRef(Color.fromARGB(255, 57, 59, 61), id: 'pauseStepColorSet-2'),
  const ColorRef(Color.fromARGB(255, 166, 172, 173), id: 'pauseStepColorSet-3'),
  const ColorRef(Color.fromARGB(255, 50, 54, 58), id: 'pauseStepColorSet-4')
];

class AppThemeModel {
  static const mainInfoColor = ColorRef(Colors.white, id: 'mainInfoColor');
  static const glassColor =
      ColorRef(Color.fromARGB(54, 255, 255, 255), id: 'glassColor');
  static const glassSecondColor =
      ColorRef(Color.fromARGB(54, 0, 0, 0), id: 'glassSecondColor');
  static const glassBorderColor =
      ColorRef(Colors.white, id: 'glassBorderColor');
  static const textShadowColor =
      ColorRef(Color.fromARGB(255, 0, 0, 0), id: 'textShadowColor');
  static const chipTextColor = ColorRef(Colors.white, id: 'chipTextColor');
  static const chipTextStyle = TextStyleRef(
      TextStyle(fontSize: 16, color: Colors.white),
      id: 'chipTextStyle');
  static const iconShadowColor = ColorRef(Colors.black, id: 'iconShadowColor');
  static const iconColor = ColorRef(Colors.white, id: 'iconColor');
  static const infoTextStyle = TextStyleRef(
      TextStyle(fontSize: 16, color: Colors.white),
      id: 'infoTextStyle');
  static const labelTextStyle = TextStyleRef(
      TextStyle(fontSize: 28, color: Colors.white),
      id: 'labelTextStyle');
  static const infoTextSecondStyle = TextStyleRef(
      TextStyle(fontSize: 16, color: Colors.black),
      id: 'infoTextSecondStyle');
  static const bigCounterTextStyle = TextStyleRef(
      TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
      id: 'bigCounterTextStyle');
}

final lightTheme = {
  AppThemeModel.mainInfoColor: Colors.white,
  AppThemeModel.glassColor: const Color.fromARGB(54, 255, 255, 255),
  AppThemeModel.glassSecondColor: const Color.fromARGB(54, 0, 0, 0),
  AppThemeModel.glassBorderColor: Colors.white,
  AppThemeModel.textShadowColor: const Color.fromARGB(122, 0, 0, 0),
  AppThemeModel.chipTextStyle:
      const TextStyle(fontSize: 16, color: Colors.white),
  AppThemeModel.iconShadowColor: Colors.black,
  AppThemeModel.chipTextColor: Colors.white,
  AppThemeModel.iconColor: Colors.white,
  AppThemeModel.infoTextStyle:
      const TextStyle(fontSize: 16, color: Colors.white),
  AppThemeModel.labelTextStyle:
      const TextStyle(fontSize: 28, color: Colors.white),
  AppThemeModel.infoTextSecondStyle:
      const TextStyle(fontSize: 16, color: Colors.black),
  AppThemeModel.bigCounterTextStyle: const TextStyle(
      fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
};

final darkTheme = {
  AppThemeModel.mainInfoColor: Colors.white,
  AppThemeModel.glassColor: const Color.fromARGB(54, 0, 0, 0),
  AppThemeModel.glassSecondColor: const Color.fromARGB(54, 255, 255, 255),
  AppThemeModel.glassBorderColor: Colors.black,
  AppThemeModel.textShadowColor: const Color.fromARGB(122, 0, 0, 0),
  AppThemeModel.chipTextColor: Colors.black,
  AppThemeModel.chipTextStyle:
      const TextStyle(fontSize: 16, color: Colors.black),
  AppThemeModel.iconShadowColor: Colors.white,
  AppThemeModel.iconColor: Colors.white,
  AppThemeModel.infoTextStyle:
      const TextStyle(fontSize: 16, color: Colors.white),
  AppThemeModel.labelTextStyle:
      const TextStyle(fontSize: 28, color: Colors.white),
  AppThemeModel.infoTextSecondStyle:
      const TextStyle(fontSize: 16, color: Colors.black),
  AppThemeModel.bigCounterTextStyle: const TextStyle(
      fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
};

class ColorListTween extends Tween<List<Color>> {
  ColorListTween({super.begin, super.end});

  @override
  List<Color> lerp(double t) {
    if (begin == null || end == null) {
      return []; // Return an empty list if null
    }
    int length = math.min(begin!.length, end!.length);
    return List.generate(
        length,
        (index) =>
            Color.lerp(begin![index], end![index], t) ??
            begin![index] // Fallback to begin color if lerp is null
        );
  }
}

class _MyAppState extends ConsumerState<MyApp> with TickerProviderStateMixin {
  final _appRouter = AppRouter();
  late AnimationController _animationController;
  late Animation<List<Color>> _colorAnimation;
  late List<Color> _previousColors;
  StepType? _lastState;

  bool _notificationsEnabled = false;
  bool _themeInited = false;

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const MainPage(),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => const MainPage(),
      ));
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();

    final appSettingsState = ref.read(userAppSettingsController);
    if (!appSettingsState.animatedWallpapers) {
      _previousColors = workStepColorSet;
      _animationController = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      );

      _colorAnimation = ColorListTween(
        begin: _previousColors,
        end: _previousColors,
      ).animate(_animationController);
    }
  }

  List<Color> getColorListByType(StepType currentState) {
    switch (currentState) {
      case StepType.off:
        return pauseStepColorSet;
      case StepType.work:
        return workStepColorSet;
      case StepType.shortBreak:
        return breakStepColorSet;
      case StepType.longBreak:
        return longBreakStepColorSet;
      case StepType.pause:
        return pauseStepColorSet;
      case StepType.longDelayBeforeWork:
        return pauseStepColorSet;
      case StepType.delayBeforeShortBreak:
        return pauseStepColorSet;
      case StepType.delayBeforeWork:
        return pauseStepColorSet;
      case StepType.delayBeforeLongBreak:
        return pauseStepColorSet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentState = ref
        .watch(timerControllerProvider.select((model) => model.currentState));
    final appSettingsState = ref.watch(userAppSettingsController);
    // final notificationState = ref.watch(notificationProvider.notifier);

    if (!appSettingsState.isLoaded) {
      return const MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_themeInited) {
      _themeInited = true;
      Themed.clearCurrentTheme();
      Themed.currentTheme =
          appSettingsState.appTheme == UserAppThemeType.lightTheme
              ? lightTheme
              : darkTheme;
    }

    logger.w(
        "тема приложения установлена на ${Themed.ifCurrentThemeIs(lightTheme) ? "светлая" : "темная"}\n${appSettingsState.animatedWallpapers}=animatedWallpapers, ${appSettingsState.uploadedWallpapers}=uploadedWallpapers");

    if (_lastState != currentState && !appSettingsState.animatedWallpapers) {
      _lastState = currentState;
      List<Color> newColors = getColorListByType(currentState) ??
          _previousColors; // Use previous colors as a fallback

      if (!listEquals(newColors, _previousColors)) {
        _animationController.reset();
        _colorAnimation = ColorListTween(
          begin: _previousColors,
          end: newColors,
        ).animate(_animationController);
        _animationController.forward();
        _previousColors = newColors;
      }
    }

    if (!appSettingsState.animatedWallpapers &&
        !appSettingsState.uploadedWallpapers) {
      return AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return AnimatedMeshGradient(
            colors: _colorAnimation.value ??
                _previousColors, // Double check for null
            options: AnimatedMeshGradientOptions(
                amplitude: 3, frequency: 4, speed: 1),
            child: Themed(
              currentTheme:
                  appSettingsState.appTheme == UserAppThemeType.lightTheme
                      ? lightTheme
                      : darkTheme,
              child: MaterialAppWidget(
                appRouter: _appRouter,
              ),
            ),
          );
        },
      );
    } else {
      return Themed(
        child: MaterialAppWidget(
          appRouter: _appRouter,
        ),
      );
    }
  }
}

class MaterialAppWidget extends ConsumerStatefulWidget {
  MaterialAppWidget({super.key, required this.appRouter});

  AppRouter appRouter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MaterialAppWidgetState();
}

class _MaterialAppWidgetState extends ConsumerState<MaterialAppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: widget.appRouter.config(),
      title: 'Flutter Demo',
      theme: ThemeData(
          iconTheme:
              const IconThemeData(color: AppThemeModel.iconColor, shadows: [
            Shadow(
              blurRadius: 8,
              color: AppThemeModel.iconShadowColor,
              offset: Offset(0, 0),
            ),
          ]),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              shadows: [
                Shadow(
                  blurRadius: 24,
                  color: AppThemeModel.textShadowColor,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
              circularTrackColor: AppThemeModel.glassColor,
              color: AppThemeModel.mainInfoColor),
          primaryColor: AppThemeModel.glassSecondColor,
          splashColor: AppThemeModel.glassSecondColor,
          highlightColor: AppThemeModel.glassSecondColor,
          focusColor: AppThemeModel.glassSecondColor,
          primaryColorLight: AppThemeModel.glassColor,
          primaryColorDark: AppThemeModel.glassSecondColor,
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: AppThemeModel.mainInfoColor,
            cursorColor: AppThemeModel.mainInfoColor,
            selectionHandleColor: AppThemeModel.mainInfoColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  shape: const MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      side:
                          BorderSide(color: AppThemeModel.glassColor, width: 1),
                    ),
                  ),
                  padding: const MaterialStatePropertyAll(
                      EdgeInsets.all(12)), // Same padding as in GlassContainer
                  overlayColor:
                      MaterialStateProperty.all(Colors.white.withOpacity(0.42)),
                  surfaceTintColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor:
                      MaterialStateProperty.all(AppThemeModel.glassColor))),
          dropdownMenuTheme: DropdownMenuThemeData(
              textStyle: AppThemeModel.infoTextStyle,
              menuStyle: MenuStyle(
                  backgroundColor: MaterialStateProperty.all(
                      AppThemeModel.glassColor.withOpacity(0.21)))),
          listTileTheme: const ListTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          canvasColor: Colors.transparent,
          chipTheme: ChipThemeData(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              side: BorderSide(
                  color: AppThemeModel.glassBorderColor.withOpacity(0.21),
                  width: 0.5),
              labelStyle: AppThemeModel.chipTextStyle +
                  const TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 12,
                        color: AppThemeModel.textShadowColor,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
              secondaryLabelStyle: AppThemeModel.infoTextStyle +
                  const TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 12,
                        color: AppThemeModel.textShadowColor,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
              checkmarkColor: AppThemeModel.iconColor,
              selectedColor: AppThemeModel.glassSecondColor,
              backgroundColor: AppThemeModel.glassColor),
          switchTheme: SwitchThemeData(
            trackOutlineColor: MaterialStateProperty.all(
                AppThemeModel.glassColor.withOpacity(0)),
            thumbColor: MaterialStateProperty.all(AppThemeModel.glassColor),
            trackColor: MaterialStateProperty.all(
                AppThemeModel.glassColor.withOpacity(0.21)),
          )),
    );
  }
}
