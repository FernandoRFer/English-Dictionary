import 'package:english_dictionary/view/auth/login/auth_view.dart';
import 'package:english_dictionary/view/auth/register/register_view.dart';
import 'package:english_dictionary/view/home/home_view.dart';
import 'package:english_dictionary/view/word_details/word_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppRoutes {
  static const String initial = auth;
  static const String home = "/home";

  static const String auth = "/auth";
  static const String register = "/register";
  static const String splash = "/splash";
  static const String wordDetails = "/wordDetails";

  static GetIt getIt = GetIt.I;

  static Map<String, WidgetBuilder> get routes => {
        // splash: (_) => SplashView(getIt.get<ISplashBloc>()),
        home: (_) => getIt.get<HomeView>(),
        wordDetails: (_) => getIt.get<WordDetailsView>(),
        auth: (_) => getIt.get<AuthView>(),
        register: (_) => getIt.get<RegisterView>(),
      };

  static Route? onGenerateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      default:
        return null;
    }
  }
}
