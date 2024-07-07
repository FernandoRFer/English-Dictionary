import 'dart:convert';
import 'dart:developer';

import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';
import 'package:english_dictionary/repository/local_db/History/History_model.dart';
import 'package:english_dictionary/repository/favorites_db.dart.dart';
import 'package:english_dictionary/repository/history_db.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import '../view_state_entity.dart';

class HomeModelState extends ViewStateEntity {
  List<String> words;

  HomeModelState(
    super.state, {
    super.isLoading,
    this.words = const [],
  });
}

abstract class IHomeBloc {
  ///Principal controller do Home page
  Stream<HomeModelState> get onFetchingDataWordList;
  Stream<HomeModelState> get onFetchingDataHistory;
  Stream<HomeModelState> get onFetchingDataFavorites;
  Future<void> load();
  Future<void> getWordList();
  Future<void> wordDetails(String value);

  Future<void> deleteItemHistory(String value);

  Future<void> getFavorites();
  Future<void> deleteItemFavorites(String value);

  void navigatorPop();
  Future<void> dispose();
}

class HomeBloc extends ChangeNotifier implements IHomeBloc {
  final IGlobalError _globalError;
  final INavigatorApp _navigatorApp;

  final IDbHistory _dbHistory;
  final IDbFavorites _dbFavorites;

  HomeBloc(
    this._globalError,
    this._navigatorApp,
    this._dbHistory,
    this._dbFavorites,
  );

  final _controllerWordList = BehaviorSubject<HomeModelState>();
  final _controllerHistory = BehaviorSubject<HomeModelState>();
  final _controllerFavorites = BehaviorSubject<HomeModelState>();

  final List<String> _wordList = [];

  @override
  Future<void> dispose() async {
    await _controllerWordList.close();
    await _controllerHistory.close();
    await _controllerFavorites.close();
    super.dispose();
  }

  @override
  Future<void> load() async {
    try {
      await getWordList();
      await getHistory();
      await getFavorites();
    } catch (e) {
      final error = await _globalError.errorHandling(
          "Um erro  ocorreu ao conectar, tente novamente", e);
      _controllerWordList.addError(error.message);
    }
  }

  @override
  Future<void> wordDetails(String word) async {
    try {
      await _dbHistory.insert(HistoryModel(
          word: word, dateTime: DateTime.now().microsecondsSinceEpoch));
      await getHistory();
    } catch (e) {
      final error = await _globalError.errorHandling(
          "Um erro  ocorreu ao conectar, tente novamente", e);
      _controllerWordList.addError(error.message);
    }
  }

  @override
  Future<void> getWordList() async {
    try {
      _controllerWordList
          .add(HomeModelState("Loading", isLoading: true, words: _wordList));

      if (_wordList.isEmpty) {
        final String jsonString =
            await rootBundle.loadString('assets/words_dictionary.json');
        final Map<dynamic, dynamic> data = jsonDecode(jsonString);

        data.forEach((key, value) {
          _wordList.add(key);
        });
      }
      _controllerWordList
          .add(HomeModelState("Done", isLoading: false, words: _wordList));
    } catch (e) {
      final error = await _globalError.errorHandling(
          "Error when searching for available words", e);
      _controllerWordList.addError(error.message);
    }
  }

  Future<void> getHistory() async {
    try {
      _controllerHistory.add(HomeModelState(
        "Loading",
        isLoading: true,
      ));
      final result = await _dbHistory.get();

      _controllerHistory
          .add(HomeModelState("done", isLoading: false, words: result));
    } catch (e) {
      final error = await _globalError.errorHandling(
          "Um erro  ocorreu ao conectar, tente novamente", e);
      _controllerHistory.addError(error.message);
    }
  }

  @override
  Future<void> deleteItemHistory(String value) async {
    try {
      _controllerHistory.add(HomeModelState(
        "Loading",
        isLoading: true,
      ));
      await _dbHistory.remove(value);
      final result = await _dbHistory.get();

      _controllerHistory
          .add(HomeModelState("done", isLoading: false, words: result));
    } catch (e) {
      final error = await _globalError.errorHandling(
          "Um erro  ocorreu ao conectar, tente novamente", e);
      _controllerHistory.addError(error.message);
    }
  }

  @override
  Future<void> getFavorites() async {
    try {
      _controllerFavorites.add(HomeModelState(
        "Loading",
        isLoading: true,
      ));
      final result = await _dbFavorites.get();

      _controllerFavorites
          .add(HomeModelState("done", isLoading: false, words: result));
    } catch (e) {
      final error = await _globalError.errorHandling(
          "Um erro  ocorreu ao conectar, tente novamente", e);
      log(error.message);
      _controllerFavorites.addError(error.message);
    }
  }

  @override
  Future<void> deleteItemFavorites(String value) async {
    try {
      _controllerFavorites.add(HomeModelState(
        "Loading",
        isLoading: true,
      ));
      await _dbHistory.remove(value);
      final result = await _dbHistory.get();

      _controllerFavorites
          .add(HomeModelState("done", isLoading: false, words: result));
    } catch (e) {
      final error = await _globalError.errorHandling(
          "Um erro  ocorreu ao conectar, tente novamente", e);
      _controllerFavorites.addError(error.message);
    }
  }

  @override
  void navigatorPop() {
    _navigatorApp.pop();
  }

  @override
  Stream<HomeModelState> get onFetchingDataWordList =>
      _controllerWordList.stream;
  @override
  Stream<HomeModelState> get onFetchingDataHistory => _controllerHistory.stream;

  @override
  Stream<HomeModelState> get onFetchingDataFavorites =>
      _controllerFavorites.stream;
}
