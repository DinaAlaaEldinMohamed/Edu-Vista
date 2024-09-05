import 'package:edu_vista/utils/images_utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoBoxWidget extends StatefulWidget {
  final String url;

  const VideoBoxWidget({required this.url, super.key});

  @override
  State<VideoBoxWidget> createState() => _VideoBoxWidgetState();
}

class _VideoBoxWidgetState extends State<VideoBoxWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void didUpdateWidget(covariant VideoBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _resetVideo();
    }
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));

    await Future.wait([
      _videoPlayerController!.initialize(),
    ]);

    _chewieController = ChewieController(
      placeholder: Image.asset(ImagesUtils.logo),
      videoPlayerController: _videoPlayerController!,
      autoInitialize: true,
      autoPlay: false,
      showOptions: false,
      showControls: true,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      draggableProgressBar: true, // Enable dragging on progress bar
      controlsSafeAreaMinimum: EdgeInsets.zero,
      materialProgressColors: ChewieProgressColors(
        bufferedColor: Colors.white,
        playedColor: Colors.red,
        handleColor: Colors.red, // Custom color for the progress handle
        backgroundColor: Colors.grey, // Custom color for the inactive track
      ),
      customControls: CustomControls(), // Use custom controls
    );

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _resetVideo() async {
    _chewieController?.dispose(); // Dispose controllers
    _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
    _isInitialized = false;

    // Reinitialize the video player and controller
    await _initializeVideo();
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Chewie(
      controller: _chewieController!,
    );
  }
}

// Custom Controls Widget
class CustomControls extends StatelessWidget {
  const CustomControls({super.key});

  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController.of(context);
    final videoPlayerController = chewieController.videoPlayerController;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Custom Play/Pause Button
        Center(
          child: IconButton(
            icon: Icon(
              videoPlayerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_circle_outline_outlined,
              color: Colors.white,
              size: 50.0,
            ),
            onPressed: () {
              if (videoPlayerController.value.isPlaying) {
                videoPlayerController.pause();
              } else {
                videoPlayerController.play();
              }
            },
          ),
        ),
        // Custom Progress Bar
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: VideoProgressIndicator(
            videoPlayerController,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.red, // Custom active track color
              bufferedColor: Colors.white,
              backgroundColor: Colors.grey, // Custom inactive track color
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10.0), // Adjust thickness by padding
          ),
        ),
        // Fullscreen Button
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: () {
              chewieController.enterFullScreen();
            },
          ),
        ),
      ],
    );
  }
}
