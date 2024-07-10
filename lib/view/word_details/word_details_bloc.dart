import 'package:audioplayers/audioplayers.dart';
import 'package:english_dictionary/repository/loca_storage/history_details_word.dart';
import 'package:english_dictionary/repository/local%20_file/word_list.dart';
import 'package:english_dictionary/repository/local_db/favorites_db.dart.dart';
import 'package:english_dictionary/repository/model/favorites_model.dart';
import 'package:english_dictionary/repository/model/word_details_entity.dart';
import 'package:english_dictionary/repository/word_rest/word_rest.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';
import 'package:english_dictionary/repository/model/word_model.dart';

import '../../core/router/routes.dart';
import '../view_state_entity.dart';

class ArgsWordDetails {
  // List<WordModel> wordList;
  WordModel wordSelect;
  ArgsWordDetails({
    // required this.wordList,
    required this.wordSelect,
  });
}

class WordDetailsModel extends ViewStateEntity {
  bool isAudioPlayer;
  WordDetailsEntity? wordDetail;
  WordDetailsModel(
    super.state, {
    super.isLoading,
    this.isAudioPlayer = false,
    this.wordDetail,
  });
}

class PlayerModel {
  final PlayerState? playerState;
  final Duration? duration;
  final Duration? position;
  PlayerModel({
    this.playerState,
    this.duration,
    this.position,
  });

  PlayerModel copyWith({
    PlayerState? playerState,
    Duration? duration,
    Duration? position,
  }) {
    return PlayerModel(
      playerState: playerState ?? this.playerState,
      duration: duration ?? this.duration,
      position: position ?? this.position,
    );
  }
}

abstract class IWordDetailsBloc {
  Stream<WordDetailsModel> get onFetchingData;
  Stream<PlayerModel> get onPlayerData;
  Stream<bool?> get onFavoriteData;

  Future<void> load(ArgsWordDetails args);

  Future<void> setfavoritos();
  Future<void> play();

  void navigateHome();
  void navigatorPop();

  Future<void> dispose();
}

class WordDetailsBloc extends ChangeNotifier implements IWordDetailsBloc {
  final IGlobalError _globalError;
  final INavigatorApp _navigatorApp;
  final IWordRepository _wordRepository;
  final IDbFavorites _dbFavorites;
  final IWordListFile _wordListFile;
  final IHistoryCache _historyCache;

  WordDetailsBloc(
    this._globalError,
    this._navigatorApp,
    this._wordRepository,
    this._dbFavorites,
    this._wordListFile,
    this._historyCache,
  );

  final _controllerPlayer = BehaviorSubject<PlayerModel>();
  final _fetchingDataController = BehaviorSubject<WordDetailsModel>();
  final _favoritesController = BehaviorSubject<bool?>();

  PlayerModel _player = PlayerModel();
  AudioPlayer player = AudioPlayer();
  WordDetailsEntity _wordDetails = WordDetailsEntity(
    phonetics: [],
    meanings: [],
    word: '',
    phonetic: '',
    origin: '',
  );
  bool _isAudioPlayer = false;

  bool? _isfavorites;

  @override
  Future<void> dispose() async {
    _controllerPlayer.close();
    _fetchingDataController.close();
    player.dispose();
    super.dispose();
  }

  @override
  Future<void> load(ArgsWordDetails args) async {
    try {
      _fetchingDataController.add(WordDetailsModel("Loading", isLoading: true));

      final detailsCache =
          await _historyCache.get(args.wordSelect.word.toLowerCase());
      if (detailsCache != null) {
        _wordDetails = detailsCache;
      } else {
        _wordDetails = await _wordRepository.getWord(args.wordSelect.word);
        await _historyCache.put(_wordDetails);
      }

      _isfavorites = await _dbFavorites.getWord(args.wordSelect.word) != null;

      String url = "";
      for (var phonetics in _wordDetails.phonetics) {
        if (phonetics.audio.isNotEmpty) {
          url = phonetics.audio;
          break;
        }
      }
      if (url.isNotEmpty) {
        _isAudioPlayer = url.isNotEmpty;
        await audioPlayer(url);
      }

      _favoritesController.add(_isfavorites);
      _fetchingDataController.add(WordDetailsModel("Done",
          isLoading: false,
          wordDetail: _wordDetails,
          isAudioPlayer: _isAudioPlayer));
    } catch (e, stackTrace) {
      final error = await _globalError.errorHandling("", e);
      _fetchingDataController.addError(error, stackTrace);
    }
  }

  @override
  Future<void> setfavoritos() async {
    try {
      final wordList = await _wordListFile.wordList;
      final wordModel = wordList.firstWhere(
          (e) => e.word.toLowerCase() == _wordDetails.word.toLowerCase());

      if (_isfavorites == null || _isfavorites == false) {
        await _dbFavorites.insert(FavoritesModel(
            dateTime: DateTime.now().microsecondsSinceEpoch,
            id: wordModel.id,
            word: wordModel.word));
        _isfavorites = true;
      } else {
        await _dbFavorites.remove(wordModel.word);
        _isfavorites = false;
      }
      _favoritesController.add(_isfavorites);
    } catch (e, stackTrace) {
      final error = await _globalError.errorHandling("", e);
      _fetchingDataController.addError(error, stackTrace);
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

  @override
  Stream<PlayerModel> get onPlayerData => _controllerPlayer.stream;

  @override
  Stream<bool?> get onFavoriteData => _favoritesController.stream;

  Future<void> audioPlayer(String url) async {
    player.setSource(UrlSource(url));
    _controllerPlayer.add(_player);
    player
      ..onDurationChanged.listen((duration) {
        _player = _player.copyWith(duration: duration);
        _controllerPlayer.add(_player);
      })
      ..onPositionChanged.listen((p) {
        _player = _player.copyWith(position: p);
        _controllerPlayer.add(_player);
      })
      ..onPlayerComplete.listen((event) {
        _player = _player.copyWith(
            playerState: PlayerState.stopped, position: Duration.zero);
        _controllerPlayer.add(_player);
      })
      ..onPlayerStateChanged.listen((state) {
        _player = _player.copyWith(
          playerState: state,
        );
        _controllerPlayer.add(_player);
      });
  }

  @override
  Future<void> play() async {
    await player.resume();
    _player = _player.copyWith(
        playerState: PlayerState.playing, position: Duration.zero);
    _controllerPlayer.add(_player);
  }

  Future<void> pause() async {
    await player.pause();
    _player = _player.copyWith(
        playerState: PlayerState.paused, position: Duration.zero);
    _controllerPlayer.add(_player);
  }

  Future<void> stop() async {
    await player.stop();
    _player = _player.copyWith(
        playerState: PlayerState.stopped, position: Duration.zero);
    _controllerPlayer.add(_player);
  }
}
