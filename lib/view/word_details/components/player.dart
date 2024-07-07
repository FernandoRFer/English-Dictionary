import 'package:audioplayers/audioplayers.dart';
import 'package:english_dictionary/view/word_details/word_details_bloc.dart';
import 'package:flutter/material.dart';

import 'package:english_dictionary/view/word_details/word_details_view.dart';

class PlayerWidget extends StatelessWidget {
  final WordDetailsView widget;

  const PlayerWidget({
    super.key,
    required this.widget,
  });

  // PlayerState? _playerState;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return StreamBuilder<PlayerModel>(
        stream: widget.bloc.onPlayerData,
        initialData: PlayerModel(),
        builder: (context, snapshot) {
          bool isPlaying = snapshot.data!.playerState == PlayerState.playing;

          bool isPaused = snapshot.data!.playerState == PlayerState.paused;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const Key('play_button'),
                    onPressed: widget.bloc.play,
                    iconSize: 48.0,
                    icon: const Icon(Icons.play_arrow),
                    color: color,
                  ),
                  IconButton(
                    key: const Key('pause_button'),
                    onPressed: isPlaying ? () {} : null,
                    iconSize: 48.0,
                    icon: const Icon(Icons.pause),
                    color: color,
                  ),
                  IconButton(
                    key: const Key('stop_button'),
                    onPressed: isPlaying || isPaused ? () {} : null,
                    iconSize: 48.0,
                    icon: const Icon(Icons.stop),
                    color: color,
                  ),
                ],
              ),
              Slider(
                onChanged: (value) {
                  final duration = snapshot.data!.duration;
                  if (duration == null) {
                    return;
                  }
                  final position = value * duration.inMilliseconds;
                  // player.seek(Duration(milliseconds: position.round()));
                },
                value: (snapshot.data!.position != null &&
                        snapshot.data!.duration != null &&
                        snapshot.data!.position!.inMilliseconds > 0 &&
                        snapshot.data!.position!.inMilliseconds <
                            snapshot.data!.duration!.inMilliseconds)
                    ? snapshot.data!.position!.inMilliseconds /
                        snapshot.data!.duration!.inMilliseconds
                    : 0.0,
              ),
              Text(
                snapshot.data!.position != null
                    ? '${snapshot.data!.position.toString().split('.').first ?? ''} / ${snapshot.data!.duration.toString().split('.').first ?? ''}'
                    : {snapshot.data!.duration} != null
                        ? snapshot.data!.duration.toString().split('.').first ??
                            ''
                        : '',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          );
        });
  }
}
