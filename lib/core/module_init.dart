import 'package:english_dictionary/core/navigator_app.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AppModule {
  final GlobalKey<NavigatorState> navigatorKey;
  AppModule(
    this.navigatorKey,
  );
  static GetIt getIt = GetIt.instance;

  void configure() {
    // ViewModule().configure();
    // HelpersModule().configure();
    // RepositoryModule().configure();

    getIt
        .registerLazySingleton<INavigatorApp>(() => NavigatorApp(navigatorKey));
  }
}
