import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoId;

  const FullScreenVideoPlayer({super.key, required this.videoId});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();

    // Initialize YouTube Player Controller
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        enableCaption: false,
      ),
    );

    // Force landscape orientation and hide system UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Allow only back navigation
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // YouTube Player
            YoutubePlayer(
              controller: _youtubePlayerController,
              showVideoProgressIndicator: true,
            ),
          ],
        ),
      ),
    );
  }



  @override
  void dispose() {
    _youtubePlayerController.dispose();

    // Reset orientation and system UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }
}
