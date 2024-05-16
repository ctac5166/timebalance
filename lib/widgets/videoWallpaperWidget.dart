import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/controllers/appSettingsControllerProvider.dart';
import 'package:timebalance/controllers/videoWallpaperManagerProvider.dart';
import 'package:timebalance/data/models/userAppSettingsModel.dart';
import 'package:timebalance/data/models/wallpapersControllerStateModel.dart';
import 'package:timebalance/main.dart';
import 'package:timebalance/widgets/animatedLoadingLine.dart';
import 'package:video_player/video_player.dart';

class VideoWallpaperWidget extends ConsumerStatefulWidget {
  final Widget child;
  const VideoWallpaperWidget({super.key, required this.child});

  @override
  _VideoWallpaperWidgetState createState() => _VideoWallpaperWidgetState();
}

class _VideoWallpaperWidgetState extends ConsumerState<VideoWallpaperWidget> {
  double? imageWidth;
  double? imageHeight;
  bool isLoadingNewWallpaper = false;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // ref.read(videoWallpaperManagerProvider.notifier).disposeController();
    super.dispose();
  }

  bool isVideoFile(String filePath) {
    return filePath.toLowerCase().endsWith('.mp4');
  }

  Future saveSelectedVideoWallpapers(
      UserAppSettingsModel appSettings, String selectedWallpapersName) async {
    appSettings = appSettings.copyWith(
        selectedVideoWallpapersName: selectedWallpapersName);
    await ref
        .read(userAppSettingsController.notifier)
        .saveUserAppSettings(appSettings);
    log("настройки приложения сохранены с новой url -> ${appSettings.selectedVideoWallpapersName}");
  }

  @override
  Widget build(BuildContext context) {
    final videoWallpaperState = ref.watch(videoWallpaperManagerProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var videoWallpaperState = ref.read(videoWallpaperManagerProvider);
      // logger.d(
      //     "PostFrameCallback ${videoWallpaperState.oldPathToCurrentWallpapers}=old path, ${videoWallpaperState.fullPathToCurrentWallpapers}=current path");

      if (videoWallpaperState.oldPathToCurrentWallpapers !=
          videoWallpaperState.fullPathToCurrentWallpapers) {
        // logger.d(
        //     "обнаружены - новые обои ${videoWallpaperState.fullPathToCurrentWallpapers} (${videoWallpaperState.isAnimate}=isAnimate)");
        if (videoWallpaperState.isAnimate && videoWallpaperState.canFadeIn) {
          logger.d(
              "создана задача для проигрывания анимации появления\n${videoWallpaperState.controller != null}=isInitialized, ${videoWallpaperState.isStaticWallpapers}=isStaticWallpapers");
          ref.read(videoWallpaperManagerProvider.notifier).startFadeInAnim();
          setState(() {});
        }
      }

      final appSettingsState = ref.watch(userAppSettingsController);

      if (!appSettingsState.animatedWallpapers &&
          !appSettingsState.uploadedWallpapers) {
        ref.read(videoWallpaperManagerProvider.notifier).setOpacity(0);
        isFirstLoad = true;
      } else if (isFirstLoad &&
          appSettingsState.animatedWallpapers &&
          appSettingsState.uploadedWallpapers &&
          videoWallpaperState.fullPathToCurrentWallpapers != "") {
        await ref
            .read(videoWallpaperManagerProvider.notifier)
            .setVideoWallpaper(videoWallpaperState.linkToCurrentWallpaper);
        await saveSelectedVideoWallpapers(
            appSettingsState, videoWallpaperState.linkToCurrentWallpaper);
      }
    });

    return Stack(
      children: [
        if (videoWallpaperState.state == WallpapersState.download ||
            (!File(videoWallpaperState.oldVideoPath).existsSync() &&
                videoWallpaperState.isStaticWallpapers))
          Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(),
              ),
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LinearProgressIndicator(
                        backgroundColor: AppThemeModel.glassSecondColor,
                        color: AppThemeModel.mainInfoColor,
                        value: videoWallpaperState.loadingProcent / 100.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        if ((videoWallpaperState.controller != null &&
                videoWallpaperState.controller!.value.isInitialized) ||
            videoWallpaperState.isStaticWallpapers)
          buildVideoPlayer(videoWallpaperState),
        widget.child
      ],
    );
  }

  Widget buildVideoPlayer(VideoWallpaperState videoWallpaperState) {
    // logger.d(
    //     'обновлено состояние обой - ${videoWallpaperState.state}=state, ${videoWallpaperState.opacity}=opacity, ${DateTime.now().millisecondsSinceEpoch}=time');

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: isVideoFile(videoWallpaperState.fullPathToCurrentWallpapers)
              ? videoWallpaperState.controller!.value.size.width
              : imageWidth ?? 1080,
          height: isVideoFile(videoWallpaperState.fullPathToCurrentWallpapers)
              ? videoWallpaperState.controller!.value.size.height
              : imageHeight ?? 1920,
          child: isVideoFile(videoWallpaperState.fullPathToCurrentWallpapers)
              ? AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: videoWallpaperState.opacity,
                  child: VideoPlayer(videoWallpaperState.controller!))
              : File(videoWallpaperState.fullPathToCurrentWallpapers)
                      .existsSync()
                  ? AnimatedOpacity(
                      duration: const Duration(seconds: 2),
                      opacity: videoWallpaperState.opacity,
                      child: Image.file(
                        File(videoWallpaperState.fullPathToCurrentWallpapers),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
