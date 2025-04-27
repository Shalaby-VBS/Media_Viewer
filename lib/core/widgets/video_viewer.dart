// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_viewer/core/widgets/loader_widget.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  final String videoUrl;
  final bool isLocalFile;

  const VideoViewer({
    super.key,
    required this.videoUrl,
    this.isLocalFile = false,
  });

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _currentPosition = 0;
  double _totalDuration = 0;
  bool _isFullScreen = false;
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    if (widget.isLocalFile) {
      _controller = VideoPlayerController.file(File(widget.videoUrl));
    } else {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    }

    try {
      await _controller.initialize();

      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _currentPosition =
                _controller.value.position.inMilliseconds.toDouble();
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _totalDuration = _controller.value.duration.inMilliseconds.toDouble();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        // إذا كان وضع ملء الشاشة، اسمح بجميع الاتجاهات
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      }
    });
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel();
    setState(() {
      _controlsVisible = true;
    });
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _controlsVisible = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    if (_controlsVisible) {
      _resetHideControlsTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) const LoaderWidget();

    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        final iconSize = isLandscape ? 18.sp : 24.sp;
        final sliderHeight = isLandscape ? 12.h : 30.h;
        final controlPadding = isLandscape
            ? EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h)
            : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);

        return GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              if (_controlsVisible)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: controlPadding,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: sliderHeight,
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: isLandscape ? 2.h : 4.h,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: isLandscape ? 6.r : 10.r,
                              ),
                            ),
                            child: Slider(
                              value: _currentPosition,
                              min: 0,
                              max: _totalDuration,
                              activeColor: Colors.red,
                              inactiveColor: Colors.grey,
                              onChanged: (value) {
                                _resetHideControlsTimer();
                                setState(() {
                                  _currentPosition = value;
                                });
                                _controller.seekTo(
                                    Duration(milliseconds: value.toInt()));
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isLandscape ? 8.w : 16.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_formatDuration(Duration(milliseconds: _currentPosition.toInt()))} / ${_formatDuration(Duration(milliseconds: _totalDuration.toInt()))}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isLandscape ? 10.sp : 12.sp,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    iconSize: iconSize,
                                    padding:
                                        EdgeInsets.all(isLandscape ? 2.r : 8.r),
                                    constraints: BoxConstraints(
                                      minWidth: isLandscape ? 24.w : 40.w,
                                      minHeight: isLandscape ? 24.h : 40.h,
                                    ),
                                    icon: const Icon(Icons.replay_10,
                                        color: Colors.white),
                                    onPressed: () {
                                      _resetHideControlsTimer();
                                      final newPosition =
                                          _controller.value.position -
                                              const Duration(seconds: 10);
                                      _controller.seekTo(newPosition);
                                    },
                                  ),
                                  IconButton(
                                    iconSize: isLandscape ? 24.sp : 36.sp,
                                    padding:
                                        EdgeInsets.all(isLandscape ? 2.r : 8.r),
                                    constraints: BoxConstraints(
                                      minWidth: isLandscape ? 24.w : 40.w,
                                      minHeight: isLandscape ? 24.h : 40.h,
                                    ),
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _resetHideControlsTimer();
                                      setState(() {
                                        _isPlaying = !_isPlaying;
                                        _isPlaying
                                            ? _controller.play()
                                            : _controller.pause();
                                      });
                                      if (_isPlaying) {
                                        _resetHideControlsTimer();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    iconSize: iconSize,
                                    padding:
                                        EdgeInsets.all(isLandscape ? 2.r : 8.r),
                                    constraints: BoxConstraints(
                                      minWidth: isLandscape ? 24.w : 40.w,
                                      minHeight: isLandscape ? 24.h : 40.h,
                                    ),
                                    icon: const Icon(Icons.forward_10,
                                        color: Colors.white),
                                    onPressed: () {
                                      _resetHideControlsTimer();
                                      final newPosition =
                                          _controller.value.position +
                                              const Duration(seconds: 10);
                                      _controller.seekTo(newPosition);
                                    },
                                  ),
                                  IconButton(
                                    iconSize: iconSize,
                                    padding:
                                        EdgeInsets.all(isLandscape ? 2.r : 8.r),
                                    constraints: BoxConstraints(
                                      minWidth: isLandscape ? 24.w : 40.w,
                                      minHeight: isLandscape ? 24.h : 40.h,
                                    ),
                                    icon: Icon(
                                      _isFullScreen
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _resetHideControlsTimer();
                                      _toggleFullScreen();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
