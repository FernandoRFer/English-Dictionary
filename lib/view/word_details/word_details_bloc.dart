import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/router/routes.dart';
import '../view_state_entity.dart';

class WordDetailsModel extends ViewStateEntity {
  bool success;

  WordDetailsModel(
    super.state, {
    super.isLoading,
    this.success = false,
  });
}

abstract class IWordDetailsBloc {
  Stream<WordDetailsModel> get onFetchingData;
  Future<bool> load();
  void navigateHome();
  void navigatorPop();
  Future<void> dispose();
}

class WordDetailsBloc extends ChangeNotifier implements IWordDetailsBloc {
  final IGlobalError _globalError;
  final INavigatorApp _navigatorApp;

  WordDetailsBloc(
    this._globalError,
    this._navigatorApp,
  );

  final _fetchingDataController = BehaviorSubject<WordDetailsModel>();

  @override
  Future<void> dispose() async {
    await _fetchingDataController.close();
    super.dispose();
  }

  @override
  Future<bool> load() async {
    try {
      // implement function

      _fetchingDataController
          .add(WordDetailsModel("Loading", isLoading: false));
      return true;
    } catch (e) {
      final error = await _globalError.errorHandling(
        "",
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
  Stream<WordDetailsModel> get onFetchingData => _fetchingDataController.stream;
}
