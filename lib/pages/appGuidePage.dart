import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:timebalance/controllers/appSettingsControllerProvider.dart';
import 'package:timebalance/main.dart';

@RoutePage()
class AppGuidePage extends ConsumerStatefulWidget {
  const AppGuidePage({
    super.key,
  });

  @override
  ConsumerState<AppGuidePage> createState() => _AppGuidePageState();
}

class _AppGuidePageState extends ConsumerState<AppGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: AppThemeModel.glassColor,
        pages: [
          PageViewModel(
              title: "Time Balance",
              body:
                  "Мы собрали самые полезные функции в одном месте и возвели в абсолют!",
              image: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/guide%20video%2FAnimatedSticker-ezgif.com-gif-maker.gif?alt=media&token=ef77de3a-382f-4c79-bf76-63db4092b7b9",
              )),
          PageViewModel(
              title: "Уровень Концентрации",
              body:
                  """Ваш Уровень-% концентрации расчитывается автоматически.\nУчитываются - задержки перед началом нового помидора, дополнительное время для перерыва и укороченное время концентрации.\nДля получения достоверных данных - полностью останавливайте таймер в конце работы (Пауза -> Стоп).""",
              image: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/guide%20video%2F%D0%BA%D0%BE%D0%BD%D1%86%D0%B5%D0%BD%D1%82%D1%80%D0%B0%D1%86%D0%B8%D1%8F.gif?alt=media&token=d82104aa-8b25-484f-a333-fa69ea5546e3",
              )),
          PageViewModel(
              title: "Сверхурочная работа",
              body:
                  """Имейте ввиду, что мы не поощряем дополнительное время работы или пропуск перерывов.\nМногочисленный пропуск этапов - также не повлияет на ваш уровень концентрации и статистику.""",
              image: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/timebalance-5906a.appspot.com/o/guide%20video%2F%D1%81%D0%BF%D1%8F%D1%89%D0%B8%D0%B9.gif?alt=media&token=6f90a6f2-90f6-49c2-b3d1-c9cf1543b4d0",
              )),
        ],
        onDone: () async {
          await ref
              .read(userAppSettingsController.notifier)
              .saveUserAppSettings(ref
                  .read(userAppSettingsController)
                  .copyWith(needGuide: false));
          ref.read(userAppSettingsController.notifier).setGuidePlayVar(false);
          AutoRouter.of(context).replaceNamed("/main");
        },
        showSkipButton: true,
        showNextButton: true,
        showDoneButton: true,
        doneStyle: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppThemeModel.glassSecondColor)),
        skipStyle: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppThemeModel.glassSecondColor)),
        nextStyle: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(AppThemeModel.glassSecondColor)),
        skip: const Text(
          "Пропуск",
          style: AppThemeModel.infoTextStyle,
        ),
        next: const Icon(
          Icons.navigate_next_rounded,
          color: AppThemeModel.mainInfoColor,
        ),
        done: const Text(
          "Начать!",
          style: AppThemeModel.infoTextStyle,
        ),
      ),
    );
  }
}
