import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path
  });

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }
  bool isReady = false;
  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path,
    shouldExtractWaveform: true,
    );
    playerController.setFinishMode(finishMode: FinishMode.stop);
    setState(() {
      isReady = true;
    });
  }

  void playAndPause() async {
    if (playerController.playerState.isPlaying) {
      await playerController.pausePlayer();
    } else {
      await playerController.startPlayer();
    }
    setState(() {});
  }

  @override
  void dispose(){
    playerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AudioFileWaveforms(
          backgroundColor: AColorTheme.card,
            size: Size(MediaQuery.of(context).size.width * 0.75, 50,),
            playerController: playerController,
            playerWaveStyle: PlayerWaveStyle(
            fixedWaveColor: AColorTheme.gradient3,
            liveWaveColor: AColorTheme.gradient1,
              waveCap: StrokeCap.round,
              spacing: 6,
              showSeekLine: false,

          ),
        ),
          IconButton(
            onPressed:isReady ? playAndPause : null,
            icon: playerController.playerState.isPlaying
                ? Icon(CupertinoIcons.pause_solid)
                : Icon(CupertinoIcons.play_arrow_solid))
      ],
    );
  }
}
