import 'package:auto_route/auto_route.dart';
import 'package:timebalance/pages/analyticsSettingsPage.dart';
import 'package:timebalance/pages/appGuidePage.dart';
import 'package:timebalance/pages/appSettingsPage.dart';
import 'package:timebalance/pages/mainPage.dart';
import 'package:timebalance/pages/settingsPage.dart';
import 'package:timebalance/pages/timerSettingsPage.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
            page: MainRoute.page,
            initial: true,
            path: "/main",
            transitionsBuilder: TransitionsBuilders.fadeIn),
        CustomRoute(
            page: AppGuideRoute.page,
            path: "/guide",
            transitionsBuilder: TransitionsBuilders.fadeIn),
        CustomRoute(
            page: SettingsRoute.page,
            path: "/settings",
            transitionsBuilder: TransitionsBuilders.fadeIn,
            children: [
              CustomRoute(
                path: "timer",
                page: TimerSettingsRoute.page,
                transitionsBuilder: TransitionsBuilders.fadeIn,
              ),
              CustomRoute(
                  path: "app",
                  page: AppSettingsRoute.page,
                  transitionsBuilder: TransitionsBuilders.fadeIn),
              CustomRoute(
                  path: "analytics",
                  page: AnalyticsSettingsRoute.page,
                  transitionsBuilder: TransitionsBuilders.fadeIn),
            ]),
      ];
}
