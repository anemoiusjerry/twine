import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';

// This widget is copied directly from "audio_waveforms" GitHub.
class WaveBubble extends StatefulWidget {
  const WaveBubble({super.key,required this.url, required this.width});

  final String url;
  final double width;
  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  final AudioPlayer player = AudioPlayer();
  final PlayerController waveController = PlayerController();
  String? cachedFilePath;
  bool playing = false;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white54,
    liveWaveColor: Colors.white,
    spacing: 6,
  );

  @override
  void initState() {
    super.initState();
    _preparePlayer();
  }

  void _preparePlayer() async {
    // get cached file or cache it
    final file = await DefaultCacheManager().getSingleFile(widget.url);
    cachedFilePath = file.path;
    // setup player and waveforms
    await player.setFilePath(cachedFilePath!);
    waveController.preparePlayer(
      path: cachedFilePath!, 
      noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width)
    );
    waveController.setFinishMode(finishMode: FinishMode.loop);
    // // Extracting waveform separately if index is odd.
    // if (widget.index?.isOdd ?? false) {
    //   controller
    //       .extractWaveformData(
    //         path: widget.path ?? file!.path,
    //         noOfSamples:
    //             playerWaveStyle.getSamplesForWidth(widget.width ?? 200),
    //       )
    //       .then((waveformData) => debugPrint(waveformData.toString()));
    // }
  }

  @override
  void dispose() {
    //playerStateSubscription.cancel();
    player.dispose();
    waveController.dispose();
    super.dispose();
  }

  void togglePlay() async {
    if (playing) {
      await waveController.pausePlayer();
    } else {
      await waveController.startPlayer();
    }
    setState(() {
      playing = !playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 6, top: 6,),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.colorScheme.primary
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: togglePlay,
            icon: Icon(playing ? Icons.pause : Icons.play_arrow,),
            color: Colors.white,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          // display waveforms using "audio_waveforms"
          AudioFileWaveforms(
            size: Size(widget.width, 70),
            playerController: waveController,
            waveformType: WaveformType.fitWidth,
            playerWaveStyle: playerWaveStyle,
          ),
        ],
      ),
    );
  }
}