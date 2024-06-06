import 'package:video_player/video_player.dart';

class VideoPlayerManager {
  VideoPlayerController? _controller;
  final List<String> _videoAssets;
  int _currentVideoIndex = 0;
  bool _isInitialized = false;

  VideoPlayerManager(this._videoAssets);

  Future<void> initialize() async {
    if (_videoAssets.isEmpty) return;
    if (_controller != null && _controller!.value.isPlaying) return;

    _controller = VideoPlayerController.asset(_videoAssets[_currentVideoIndex],
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ));
    await _controller!.initialize();
    await _controller!.setPlaybackSpeed(1);
    await _controller!.setVolume(1);
    _isInitialized = true;
    _controller!.addListener(_videoListener);
  }

  void _videoListener() {
    if (_controller!.value.position == _controller!.value.duration) {
      _playNextVideo();
    }
  }

  Future<void> play() async {
    if (!_isInitialized) {
      await initialize();
    }
    if (_isInitialized &&
        _controller != null &&
        !_controller!.value.isPlaying) {
      await _controller!.play();
    }
  }

  Future<void> dispose() async {
    if (_isInitialized && _controller != null) {
      _controller!.pause();
      await _controller!.dispose();
      _isInitialized = false;
    }
    _controller = null;
  }

  Future<void> _playNextVideo() async {
    await dispose();
    _currentVideoIndex++;
    if (_currentVideoIndex < _videoAssets.length) {
      await initialize();
      await play();
    } else {
      _currentVideoIndex = 0;
    }
  }
}