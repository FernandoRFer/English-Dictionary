import 'dart:convert';

import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';
import 'package:english_dictionary/repository/local_db/history/history_db.dart.dart';
import 'package:english_dictionary/repository/local_db/history/history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/router/routes.dart';
import '../view_state_entity.dart';

class WordListModelState extends ViewStateEntity {
  List<String> words;

  WordListModelState(
    super.state, {
    super.isLoading,
    this.words = const [],
  });
}

abstract class IHomeBloc {
  ///Principal controller do Home page
  Stream<WordListModelState> get onFetchingDataWordList;
  Stream<WordListModelState> get onFetchingDataHistory;
  Stream<WordListModelState> get onFetchingDataFavorites;
  Future<void> load();
  Future<void> getWordList();
  Future<void> wordDetails(String value);

  Future<void> deleteItemHistory(String value);

  void navigateHome();
  void navigatorPop();
  Future<void> dispose();
}

class HomeBloc extends ChangeNotifier implements IHomeBloc {
  final IGlobalError _globalError;
  final INavigatorApp _navigatorApp;

  final IDbHistory _dbHistory;

  HomeBloc(
    this._globalError,
    this._navigatorApp,
    this._dbHistory,
  );

  final _controllerWordList = BehaviorSubject<WordListModelState>();
  final _controllerHistory = BehaviorSubject<WordListModelState>();
  final _controllerFavorites = BehaviorSubject<WordListModelState>();

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
    } catch (e) {
      final error = await _globalError.errorHandling(
        "Um erro  ocorreu ao conectar, tente novamente",
        e,
      );
      _controllerWordList.addError(
        error.message,
      );
    }
  }

  @override
  Future<void> wordDetails(String word) async {
    try {
      await _dbHistory.insert(HistoryModel(
          searchWord: word, dateTime: DateTime.now().microsecondsSinceEpoch));
      await getHistory();
    } catch (e) {
      final error = await _globalError.errorHandling(
        "Um erro  ocorreu ao conectar, tente novamente",
        e,
      );
      _controllerWordList.addError(
        error.message,
      );
    }
  }

  @override
  Future<void> getWordList() async {
    try {
      _controllerWordList.add(
          WordListModelState("Loading", isLoading: true, words: _wordList));

      if (_wordList.isEmpty) {
        final String jsonString =
            await rootBundle.loadString('assets/words_dictionary.json');
        final Map<dynamic, dynamic> data = jsonDecode(jsonString);

        data.forEach((key, value) {
          _wordList.add(key);
        });
      }
      _controllerWordList
          .add(WordListModelState("Done", isLoading: false, words: _wordList));
    } catch (e) {
      final error = await _globalError.errorHandling(
        "Error when searching for available words",
        e,
      );
      _controllerWordList.addError(
        error.message,
      );
    }
  }

  Future<void> getHistory() async {
    try {
      _controllerHistory.add(WordListModelState(
        "Loading",
        isLoading: true,
      ));
      final result = await _dbHistory.get();

      _controllerHistory
          .add(WordListModelState("done", isLoading: false, words: result));
    } catch (e) {
      final error = await _globalError.errorHandling(
        "Um erro  ocorreu ao conectar, tente novamente",
        e,
      );
      _controllerHistory.addError(
        error.message,
      );
    }
  }

  @override
  Future<void> deleteItemHistory(String value) async {
    try {
      _controllerHistory.add(WordListModelState(
        "Loading",
        isLoading: true,
      ));
      await _dbHistory.remove(value);
      final result = await _dbHistory.get();

      _controllerHistory
          .add(WordListModelState("done", isLoading: false, words: result));
    } catch (e) {
      final error = await _globalError.errorHandling(
        "Um erro  ocorreu ao conectar, tente novamente",
        e,
      );
      _controllerHistory.addError(
        error.message,
      );
    }
  }

  void getFavorites(String word) {}

  @override
  void navigatorPop() {
    _navigatorApp.pop();
  }

  @override
  void navigateHome() {
    _navigatorApp.popUntil(AppRoutes.home);
  }

  @override
  Stream<WordListModelState> get onFetchingDataWordList =>
      _controllerWordList.stream;
  @override
  Stream<WordListModelState> get onFetchingDataHistory =>
      _controllerHistory.stream;
  @override
  Stream<WordListModelState> get onFetchingDataFavorites =>
      _controllerFavorites.stream;
}
