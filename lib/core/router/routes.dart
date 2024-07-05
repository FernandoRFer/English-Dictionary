import 'package:english_dictionary/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'custon_page_router.dart';

class AppRoutes {
  static const String initial = home;
  static const String home = "/home";
  static const String splash = "/splash";
  static const String search = "/search";

  static GetIt getIt = GetIt.I;

  static Map<String, WidgetBuilder> get routes => {
        // splash: (_) => SplashView(getIt.get<ISplashBloc>()),
        home: (_) => getIt.get<HomeView>(),
      };

  static Route? onGenerateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      default:
        return null;
    }
  }
}
