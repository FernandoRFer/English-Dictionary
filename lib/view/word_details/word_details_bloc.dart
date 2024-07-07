// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:english_dictionary/core/helpers/global_error.dart';
import 'package:english_dictionary/core/navigator_app.dart';

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

  Future<bool> load();
  void navigateHome();
  void navigatorPop();
  Future<void> dispose();

  Future<void> play();
}

class WordDetailsBloc extends ChangeNotifier implements IWordDetailsBloc {
  final IGlobalError _globalError;
  final INavigatorApp _navigatorApp;

  WordDetailsBloc(
    this._globalError,
    this._navigatorApp,
  );

  final _controllerPlayer = BehaviorSubject<PlayerModel>();
  final _fetchingDataController = BehaviorSubject<WordDetailsModel>();

  PlayerModel _player = PlayerModel();
  AudioPlayer player = AudioPlayer();

  @override
  Future<void> dispose() async {
    await _controllerPlayer.close();
    super.dispose();
  }

  @override
  Future<bool> load() async {
    try {
      audioPlayer();
      return true;
    } catch (e) {
      final error = await _globalError.errorHandling(
        "",
        e,
      );
      _controllerPlayer.addError(
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

  @override
  Stream<PlayerModel> get onPlayerData => _controllerPlayer.stream;

  Future<void> audioPlayer() async {
    player.setSource(UrlSource(
        "https://api.dictionaryapi.dev/media/pronunciations/en/hello-au.mp3"));

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
