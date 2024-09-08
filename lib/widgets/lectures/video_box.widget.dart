import 'package:edu_vista/utils/images_utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoBoxWidget extends StatefulWidget {
  final String? url; // Nullable URL
  final String lectureId; // New field to identify the lecture
  final void Function(String lectureId) onLectureWatched; // Callback

  const VideoBoxWidget({
    required this.url,
    required this.lectureId,
    required this.onLectureWatched,
    super.key,
  });

  @override
  State<VideoBoxWidget> createState() => _VideoBoxWidgetState();
}

class _VideoBoxWidgetState extends State<VideoBoxWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String _errorMessage = '';

  @override
  void didUpdateWidget(covariant VideoBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset video if URL changes
    if (oldWidget.url != widget.url) {
      _resetVideo();
    }
  }

  Future<void> _initializeVideo() async {
    if (widget.url == null || widget.url!.isEmpty) {
      setState(() {
        _errorMessage = 'Invalid URL';
        _isInitialized = true; // Ensure the error message is displayed
      });
      return;
    }

    try {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.url!));

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
          _errorMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load video: $e';
        _isInitialized = true; // Ensure the error message is displayed
      });
    }
  }

  Future<void> _resetVideo() async {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
    _isInitialized = false;
    _errorMessage = '';

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

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // Call the onLectureWatched callback when video is watched
    _videoPlayerController?.addListener(() {
      if (_videoPlayerController!.value.isInitialized &&
          _videoPlayerController!.value.position ==
              _videoPlayerController!.value.duration) {
        widget.onLectureWatched(widget.lectureId);
        // Optionally reset the widget after video ends
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _initializeVideo();
          }
        });
      }
    });

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
