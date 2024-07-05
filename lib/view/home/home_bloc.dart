import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/router/routes.dart';
import '../view_state_entity.dart';

class HomeModelBloc extends ViewStateEntity {
  bool success;

  HomeModelBloc(
    super.state, {
    super.isLoading,
    this.success = false,
  });
}

abstract class IHomeBloc {
  Stream<HomeModelBloc> get onFetchingData;
  Future<bool> load();
  void navigateHome();
  void navigatorPop();
  Future<void> dispose();
}

class HomeBloc extends ChangeNotifier implements IHomeBloc {
  final IGlobalError _globalError;
  final INavigatorApp _navigatorApp;

  HomeBloc(
    this._globalError,
    this._navigatorApp,
  );

  final _fetchingDataController = BehaviorSubject<HomeModelBloc>();

  @override
  Future<void> dispose() async {
    await _fetchingDataController.close();
    super.dispose();
  }

  @override
  Future<bool> load() async {
    try {
      // implement function

      _fetchingDataController.add(HomeModelBloc("Loading", isLoading: false));
      return true;
    } catch (e) {
      final error = await _globalError.errorHandling(
        "Um erro  ocorreu ao conectar, tente novamente",
        e,
      );
      _fetchingDataController.addError(
        error.message,
      );
      return false;
    }
  }

  @override
  void navigatorPop() {
    _navigatorApp.pop();
  }

  @override
  void navigateHome() {
    _navigatorApp.popUntil(AppRoutes.home);
  }

  @override
  Stream<HomeModelBloc> get onFetchingData => _fetchingDataController.stream;
}
