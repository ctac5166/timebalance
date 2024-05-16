// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AnalyticsSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AnalyticsSettingsPage(),
      );
    },
    AppGuideRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppGuidePage(),
      );
    },
    AppSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppSettingsPage(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    TimerSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TimerSettingsPage(),
      );
    },
  };
}

/// generated route for
/// [AnalyticsSettingsPage]
class AnalyticsSettingsRoute extends PageRouteInfo<void> {
  const AnalyticsSettingsRoute({List<PageRouteInfo>? children})
      : super(
          AnalyticsSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AnalyticsSettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AppGuidePage]
class AppGuideRoute extends PageRouteInfo<void> {
  const AppGuideRoute({List<PageRouteInfo>? children})
      : super(
          AppGuideRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppGuideRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AppSettingsPage]
class AppSettingsRoute extends PageRouteInfo<void> {
  const AppSettingsRoute({List<PageRouteInfo>? children})
      : super(
          AppSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppSettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TimerSettingsPage]
class TimerSettingsRoute extends PageRouteInfo<void> {
  const TimerSettingsRoute({List<PageRouteInfo>? children})
      : super(
          TimerSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TimerSettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
