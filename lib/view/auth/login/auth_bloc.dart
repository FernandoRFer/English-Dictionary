// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';
import 'package:english_dictionary/core/router/routes.dart';
import 'package:english_dictionary/repository/auth_repository/iuser_repository.dart';
import 'package:english_dictionary/view/view_state_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class AuthModelBloc extends ViewStateEntity {
  bool isStayConnected;

  AuthModelBloc(
    super.state, {
    super.isLoading,
    this.isStayConnected = false,
  });
}

abstract class IAuthBloc {
  Stream<AuthModelBloc> get onFetchingData;
  Future<void> login({required String eMail, required String password});

  Future<void> dispose();
  void stayConnected();

  void navigateToRegister();
  void navigatePop();
}

class AuthBloc extends ChangeNotifier implements IAuthBloc {
  final IGlobalError _globalError;
  final INavigatorApp _navigatorApp;
  final IUserRepository _userRepository;

  final _fetchingDataController = BehaviorSubject<AuthModelBloc>();
  bool _isStayConnected = false;

  AuthBloc(
    this._globalError,
    this._navigatorApp,
    this._userRepository,
  );

  @override
  Future<void> dispose() async {
    await _fetchingDataController.close();
    super.dispose();
  }

  @override
  Future<void> login({required String eMail, required String password}) async {
    try {
      _fetchingDataController.add(AuthModelBloc("Loading",
          isLoading: true, isStayConnected: _isStayConnected));
      String result =
          await _userRepository.login(eMail: eMail, password: password);

      _navigatorApp.pushNamed(AppRoutes.home);

      _fetchingDataController.add(AuthModelBloc("Done",
          isLoading: false, isStayConnected: _isStayConnected));
    } catch (e) {
      final error = await _globalError.errorHandling(
        "Um erro  ocorreu ao conectar, tente novamente",
        e,
      );
      _fetchingDataController.addError(
        error,
      );
    }
  }

  @override
  void navigatePop() {
    _fetchingDataController.add(AuthModelBloc("Loading",
        isLoading: false, isStayConnected: _isStayConnected));
    _navigatorApp.pop();
  }

  @override
  void navigateToRegister() {
    _navigatorApp.pushNamed(AppRoutes.register);
  }

  @override
  void stayConnected() {
    _isStayConnected = !_isStayConnected;
    _fetchingDataController.add(AuthModelBloc("done",
        isLoading: false, isStayConnected: _isStayConnected));
  }

  @override
  Stream<AuthModelBloc> get onFetchingData => _fetchingDataController.stream;
}
