import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:timebalance/data/models/wallpapersControllerStateModel.dart';
import 'package:video_player/video_player.dart';
import 'package:timebalance/main.dart';

final videoWallpaperManagerProvider =
    StateNotifierProvider<VideoWallpaperManager, VideoWallpaperState>((ref) {
  return VideoWallpaperManager();
});

class VideoWallpaperState {
  final VideoPlayerController? controller;
  final String oldVideoPath;
  final double opacity;
  final int loadingProcent;
  final String fullPathToCurrentWallpapers;
  final String linkToCurrentWallpaper;
  final String oldPathToCurrentWallpapers;
  final WallpapersState state;
  final bool isStaticWallpapers;
  final bool isAnimate;
  final bool canFadeIn;
  final String oldVideoUrl;

  VideoWallpaperState({
    this.controller,
    this.oldVideoPath = "",
    this.oldVideoUrl = "",
    this.opacity = 0.0,
    this.loadingProcent = 0,
    this.oldPathToCurrentWallpapers = "",
    this.fullPathToCurrentWallpapers = "",
    this.linkToCurrentWallpaper = "",
    this.state = WallpapersState.off,
    this.isStaticWallpapers = false,
    this.isAnimate = false,
    this.canFadeIn = false,
  });

  VideoWallpaperState copyWith({
    bool? isStaticWallpapers,
    bool? isAnimate,
    bool? canFadeIn,
    VideoPlayerController? controller,
    String? oldPathToCurrentWallpapers,
    String? oldVideoPath,
    String? oldVideoUrl,
    double? opacity,
    int? loadingProcent,
    String? fullPathToCurrentWallpapers,
    String? linkToCurrentWallpaper,
    WallpapersState? state,
  }) {
    return VideoWallpaperState(
      oldPathToCurrentWallpapers:
          oldPathToCurrentWallpapers ?? this.oldPathToCurrentWallpapers,
      oldVideoUrl: oldVideoUrl ?? this.oldVideoUrl,
      isAnimate: isAnimate ?? this.isAnimate,
      canFadeIn: canFadeIn ?? this.canFadeIn,
      controller: controller ?? this.controller,
      isStaticWallpapers: isStaticWallpapers ?? this.isStaticWallpapers,
      oldVideoPath: oldVideoPath ?? this.oldVideoPath,
      opacity: opacity ?? this.opacity,
      loadingProcent: loadingProcent ?? this.loadingProcent,
      fullPathToCurrentWallpapers:
          fullPathToCurrentWallpapers ?? this.fullPathToCurrentWallpapers,
      linkToCurrentWallpaper:
          linkToCurrentWallpaper ?? this.linkToCurrentWallpaper,
      state: state ?? this.state,
    );
  }
}

class VideoWallpaperManager extends StateNotifier<VideoWallpaperState> {
  VideoWallpaperManager() : super(VideoWallpaperState());

  String oldPathToAnimate = "";

  Future animateWallpapersTransition(String wallpapersPathToUpdate) async {
    oldPathToAnimate = state.fullPathToCurrentWallpapers;
    state = state.copyWith(opacity: 0, isAnimate: true, canFadeIn: false);
    logger.d('начало анимации для $wallpapersPathToUpdate');
    await Future.delayed(const Duration(seconds: 2));
    logger
        .d("анимация исчезновения завершена. $wallpapersPathToUpdate=new path");
    await initializeVideoPlayer(wallpapersPathToUpdate);
    state = state.copyWith(
      fullPathToCurrentWallpapers: wallpapersPathToUpdate,
      oldPathToCurrentWallpapers: oldPathToAnimate,
      isAnimate: true,
      canFadeIn: true,
    );
    logger.d(
        "состояние обновлено - ${state.canFadeIn}=canFadeIn, ${state.isAnimate}=isAnimate");
  }

  Future startFadeInAnim() async {
    if (state.isAnimate && state.canFadeIn) {
      logger.d('анимация появления для ${state.fullPathToCurrentWallpapers}');
      state = state.copyWith(opacity: 1);
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(isAnimate: false, canFadeIn: false);
    }
  }

  bool isVideoFile(String filePath) {
    return filePath.toLowerCase().endsWith('.mp4');
  }

  Future<bool> checkLocalJPGExists(String url) async {
    final localPath = await _getLocalPath();
    final filePath = '$localPath/${url.hashCode}.jpg';
    return File(filePath).existsSync();
  }

  Future<bool> checkLocalVideoExists(String url) async {
    final localPath = await _getLocalPath();
    final filePath = '$localPath/${url.hashCode}.mp4';
    return File(filePath).existsSync();
  }

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> downloadJPG(String url) async {
    if (state.oldVideoUrl == url) {
      return state.fullPathToCurrentWallpapers;
    }
    final localPath = await _getLocalPath();
    final filePath = '$localPath/${url.hashCode}.jpg';
    final file = File(filePath);

    state =
        state.copyWith(linkToCurrentWallpaper: url, isStaticWallpapers: true);

    if (!file.existsSync()) {
      try {
        final client = http.Client();
        final request = http.Request('GET', Uri.parse(url));
        final response = await client.send(request);

        if (response.statusCode == 200) {
          final contentLength = response.contentLength ?? 0;
          int downloadedLength = 0;

          state = state.copyWith(
            loadingProcent: 0,
            state: WallpapersState.download,
          );

          final bytes = <int>[];
          await for (final chunk in response.stream) {
            bytes.addAll(chunk);
            downloadedLength += chunk.length;

            final percent = (downloadedLength / contentLength * 100).toInt();
            state = state.copyWith(loadingProcent: percent);
          }

          await file.writeAsBytes(bytes);

          var oldVideoUrl = state.linkToCurrentWallpaper;

          state = state.copyWith(
            loadingProcent: 100,
            state: WallpapersState.appearing,
            linkToCurrentWallpaper: url,
            oldVideoUrl: oldVideoUrl,
          );

          animateWallpapersTransition(filePath);
        } else {
          logger.e("Failed to download the image");
          throw Exception('Failed to download the image');
        }
      } catch (e) {
        logger.e(e);
        state = state.copyWith(
          loadingProcent: 0,
          state: WallpapersState.off,
          fullPathToCurrentWallpapers: "",
        );
      }
    } else {
      state = state.copyWith(
        loadingProcent: 100,
        state: WallpapersState.appearing,
      );
      logger.d("найдено уже загруженные обои - $filePath");
      animateWallpapersTransition(filePath);
    }
    return filePath;
  }

  Future<String> setVideoWallpaper(String url) async {
    if (state.oldVideoUrl == url) {
      return state.fullPathToCurrentWallpapers;
    }

    final localPath = await _getLocalPath();
    final filePath = '$localPath/${url.hashCode}.mp4';
    logger.d("получен локальный путь к файлу $filePath - setVideoWallpaper");
    final file = File(filePath);

    state =
        state.copyWith(linkToCurrentWallpaper: url, isStaticWallpapers: false);

    if (!file.existsSync()) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        var streamedResponse = await request.send();

        if (streamedResponse.statusCode == 200) {
          List<int> bytes = [];
          final contentLength = streamedResponse.contentLength ?? 0;
          int currentLength = 0;

          state = state.copyWith(
            loadingProcent: 0,
            state: WallpapersState.download,
          );

          streamedResponse.stream.listen(
            (List<int> chunk) {
              currentLength += chunk.length;
              bytes.addAll(chunk);
              final progress = ((currentLength / contentLength) * 100).toInt();
              state = state.copyWith(loadingProcent: progress);
            },
            onDone: () async {
              await File(filePath).writeAsBytes(bytes);
              var oldVideoUrl = state.linkToCurrentWallpaper;
              state = state.copyWith(
                loadingProcent: 100,
                state: WallpapersState.appearing,
                linkToCurrentWallpaper: url,
                oldVideoUrl: oldVideoUrl,
              );

              animateWallpapersTransition(filePath);
            },
            onError: (e) {
              state = state.copyWith(
                loadingProcent: 0,
                state: WallpapersState.off,
                fullPathToCurrentWallpapers: "",
              );
            },
            cancelOnError: true,
          );
        } else {
          logger.e(
              "${streamedResponse.statusCode}=statusCode, ${streamedResponse.reasonPhrase}=reasonPhrase");
          state = state.copyWith(
            loadingProcent: 0,
            state: WallpapersState.off,
            fullPathToCurrentWallpapers: "",
          );
        }
      } catch (e) {
        logger.e(e);
        state = state.copyWith(
          loadingProcent: 0,
          state: WallpapersState.off,
          fullPathToCurrentWallpapers: "",
        );
      }
    } else {
      state = state.copyWith(
        loadingProcent: 100,
        state: WallpapersState.appearing,
      );
      logger.d("найдено уже загруженные обои - $filePath");
      animateWallpapersTransition(filePath);
    }
    return filePath;
  }

  Future<void> deleteVideoWallpaper(String url) async {
    final localPath = await _getLocalPath();
    final filePath = '$localPath/${url.hashCode}.mp4';
    final file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
      state = state.copyWith(
        loadingProcent: 0,
        fullPathToCurrentWallpapers: "",
        linkToCurrentWallpaper: "",
        state: WallpapersState.off,
      );
    }
  }

  Future<void> initializeVideoPlayer(String videoPath) async {
    if (isVideoFile(videoPath)) {
      logger.d("контроллер видео - попытка инициализации!");
      if (!File(videoPath).existsSync()) {
        logger.e("File does not exist: $videoPath");
        state = state.copyWith(
          state: WallpapersState.off,
          fullPathToCurrentWallpapers: "",
        );
        return;
      }

      state.controller?.dispose();
      final controller = VideoPlayerController.file(
        File(videoPath),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      state = state.copyWith(controller: controller);

      try {
        await controller.initialize();
        controller.setLooping(true);
        controller.setVolume(0.0);
        await controller.play();
        state = state.copyWith(controller: controller);
        logger.d("контроллер видео - инициализирован!");
      } catch (e) {
        logger.e("Error initializing video: $e");
        state = state.copyWith(
          state: WallpapersState.off,
          fullPathToCurrentWallpapers: "",
        );
      }
    }
  }

  void updateOldVideoPath(String path) {
    state = state.copyWith(oldVideoPath: path);
  }

  void setOpacity(double opacity) {
    state = state.copyWith(opacity: opacity);
  }

  void disposeController() {
    state.controller?.dispose();
  }
}
