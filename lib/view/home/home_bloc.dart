import 'dart:convert';
import 'dart:developer';

import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';
import 'package:english_dictionary/core/router/routes.dart';
import 'package:english_dictionary/repository/local_db/favorites_db.dart.dart';
import 'package:english_dictionary/repository/local_db/history_db.dart.dart';
import 'package:english_dictionary/repository/local%20_file/word_list.dart';
import 'package:english_dictionary/repository/model/history_model.dart';
import 'package:english_dictionary/repository/model/word_model.dart';
import 'package:english_dictionary/view/word_details/word_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import '../view_state_entity.dart';

class HomeModelState extends ViewStateEntity {
  List<WordModel> words;

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
  Future<void> wordDetails(WordModel value);

  Future<void> deleteItemHistory(String value);

  Future<void> getFavorites();
  Future<void> deleteItemFavorites(String value);

  void navigatorPop();
  Future<void> dispose();

  Future<void> search(String? search);
}

class HomeBloc extends ChangeNotifier implements IHomeBloc {
  final IGlobalError _globalError;
  final INavigatorApp _navigatorApp;

  final IDbHistory _dbHistory;
  final IDbFavorites _dbFavorites;
  final IWordListFile _wordListFile;

  HomeBloc(
    this._globalError,
    this._navigatorApp,
    this._dbHistory,
    this._dbFavorites,
    this._wordListFile,
  );

  final _controllerWordList = BehaviorSubject<HomeModelState>();
  final _controllerHistory = BehaviorSubject<HomeModelState>();
  final _controllerFavorites = BehaviorSubject<HomeModelState>();

  List<WordModel> _wordList = [];
  List<WordModel> _wordFavorites = [];
  List<WordModel> _wordHisotry = [];

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
      final error = await _globalError.errorHandling("", e);
      _controllerWordList.addError(error.message);
    }
  }

  @override
  Future<void> search(String? search) async {
    if (search != null) {
      final result = _wordList
          .where((e) => e.word.toLowerCase().contains(search))
          .toList();
      _controllerWordList
          .add(HomeModelState("Done", isLoading: false, words: result));
    } else {
      _controllerWordList
          .add(HomeModelState("Done", isLoading: false, words: _wordList));
    }
  }

  @override
  Future<void> wordDetails(WordModel word) async {
    try {
      await _navigatorApp.pushNamed(AppRoutes.wordDetails,
          arguments: ArgsWordDetails(wordSelect: word));
      await setHistoryWord(HistoryModel(
          id: word.id,
          word: word.word,
          dateTime: DateTime.now().microsecondsSinceEpoch));
      await getHistory();
      await getFavorites();
    } catch (e) {
      final error = await _globalError.errorHandling("", e);
      _controllerWordList.addError(error.message);
    }
  }

  Future<void> setHistoryWord(HistoryModel historyModel) async {
    try {
      _controllerHistory
          .add(HomeModelState("Loading", isLoading: true, words: _wordList));

      await _dbHistory.insert(historyModel);

      _controllerHistory
          .add(HomeModelState("Done", isLoading: false, words: _wordList));
    } catch (e) {
      final error = await _globalError.errorHandling("Error salve hisotoy", e);
      _controllerHistory.addError(error.message);
    }
  }

  @override
  Future<void> getWordList() async {
    try {
      _controllerWordList
          .add(HomeModelState("Loading", isLoading: true, words: _wordList));

      _wordList = await _wordListFile.wordList;

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
      // _controllerHistory.add(
      //     HomeModelState("Loading", isLoading: false, words: _wordHisotry));
      await _dbHistory.remove(value);
      _wordHisotry = await _dbHistory.get();

      // _controllerHistory
      //     .add(HomeModelState("done", isLoading: false, words: _wordHisotry));
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
      final result = await _dbFavorites.getAll();

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
      // _controllerFavorites.add(
      //     HomeModelState("Loading", isLoading: false, words: _wordFavorites));
      await _dbFavorites.remove(value);
      _wordFavorites = await _dbFavorites.getAll();

      // _controllerFavorites
      //     .add(HomeModelState("done", isLoading: false, words: _wordFavorites));
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
