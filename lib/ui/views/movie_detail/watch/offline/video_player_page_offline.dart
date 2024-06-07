import 'dart:async';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:blur/blur.dart';
import 'package:cast/cast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_prevent_screen_capture/flutter_prevent_screen_capture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:video_player/video_player.dart';
import 'package:yangi_tv_new/database/episode_db.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../../helpers/video_player_manager.dart';
import '../../../../../models/profile.dart';

class VideoPlayerPageOffline extends StatefulWidget {
  static const routeName = '/video-player-offline';

  @override
  State<VideoPlayerPageOffline> createState() => _VideoPlayerPageOfflineState();
}

enum UIState {
  NONE,
  BASIC,
  LOCKED,
  LOCKED_INVISIBLE,
  SPEED,
  VIDEO_RECORDING,
}

class _VideoPlayerPageOfflineState extends State<VideoPlayerPageOffline> {
  //lastDuration
  int lastDurationSeconds = 0;
  late Profile profile;

  //name
  String movie_name = '';

  //url
  String videoUrl = '';

  UIState uiState = UIState.NONE;
  late VideoPlayerController _controller;
  Timer? _timer;
  int secondFadeOut = 8;

  FlutterPreventScreenCapture preventScreenCapture =
      FlutterPreventScreenCapture();

  Future<void> checkScreenRecord() async {
    final recordStatus = await preventScreenCapture.checkScreenRecord();
    if (recordStatus == true) {
      if (_controller.value.isInitialized) {
        _controller.pause();
      }
      if (_timer != null) _timer!.cancel();
      setState(() {
        uiState = UIState.VIDEO_RECORDING;
      });
      changeUItoNone();
    } else {
      if (uiState == UIState.VIDEO_RECORDING) {
        setState(() {
          uiState = UIState.BASIC;
        });
        _controller.play();
      }
    }
    await Future.delayed(Duration(milliseconds: 1000));
    checkScreenRecord();
  }

  void preventRecording() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void removePreventRecording() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    super.initState();
    KeepScreenOn.turnOn();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (Platform.isAndroid) {
      preventRecording();
    }
    if (Platform.isIOS) {
      checkScreenRecord();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (videoUrl != '') return;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    movie_name = args['movie_name'];
    videoUrl = args['videoUrl'];
    profile = args['profile'];
    prepareAudio();
    _controller = VideoPlayerController.file(File(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: false,
          mixWithOthers: true,
        ))
      ..initialize().then((_) {
        if (mounted)
          setState(() {
            _controller.setLooping(false);
            _controller.play();
            _controller.seekTo(Duration(seconds: lastDurationSeconds));
          });
      });
    _controller.addListener(() async {
      if (mounted) setState(() {});
      if (_controller.value.position.inSeconds % 600 == 0 &&
          _controller.value.position.inSeconds >= 10) {
        videoPlayerManager.play();
      }
    });
  }

  VideoPlayerManager videoPlayerManager = VideoPlayerManager([]);

  void prepareAudio() async {
    List<String> numbers = [];
    for (var i = 0; i < profile.id.toString().length; i++) {
      numbers.add("assets/numbers/${profile.id.toString()[i]}.mp4");
    }
    videoPlayerManager = VideoPlayerManager(numbers);
    await videoPlayerManager.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer!.cancel();
    _timer = null;
    _controller.pause();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    KeepScreenOn.turnOff();
    if (Platform.isAndroid) {
      removePreventRecording();
    }
    videoPlayerManager.dispose();
  }

  void changeUItoNone() {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(Duration(seconds: secondFadeOut), () {
      if (uiState == UIState.BASIC) {
        if (mounted)
          setState(() {
            uiState = UIState.NONE;
          });
      }
    });
  }

  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          if (uiState == UIState.BASIC) {
            if (mounted)
              setState(() {
                uiState = UIState.NONE;
              });
            return false;
          }

          if (uiState == UIState.NONE) {
            return true;
          }

          if (mounted)
            setState(() {
              uiState = UIState.BASIC;
            });
          changeUItoNone();
          return false;
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () {
              if (_timer != null) _timer!.cancel();

              if (uiState == UIState.SPEED) {
                setState(
                  () {
                    uiState = UIState.BASIC;
                  },
                );
                changeUItoNone();
                return;
              }

              if (uiState == UIState.LOCKED) {
                _timer = Timer(Duration(seconds: secondFadeOut), () {
                  if (uiState == UIState.LOCKED) {
                    if (mounted)
                      setState(
                        () {
                          uiState = UIState.LOCKED_INVISIBLE;
                        },
                      );
                  }
                });
                return;
              }

              if (uiState == UIState.LOCKED_INVISIBLE) {
                if (mounted)
                  setState(() {
                    uiState = UIState.LOCKED;
                  });
                _timer = Timer(Duration(seconds: secondFadeOut), () {
                  if (uiState == UIState.LOCKED) {
                    if (mounted)
                      setState(
                        () {
                          uiState = UIState.LOCKED_INVISIBLE;
                        },
                      );
                  }
                });
                return;
              }

              if (uiState == UIState.NONE) {
                if (mounted)
                  setState(() {
                    uiState = UIState.BASIC;
                  });
                changeUItoNone();
                return;
              }
              if (uiState == UIState.BASIC) {
                if (_timer != null) _timer!.cancel();
                if (mounted)
                  setState(() {
                    uiState = UIState.NONE;
                  });
                return;
              }
            },
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Builder(
                    builder: (_) {
                      if (!_controller.value.isInitialized)
                        return Visibility(
                          visible: uiState == UIState.NONE,
                          child: Container(
                            color: Colors.black,
                            child: Center(
                              child: SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );

                      return Center(
                        child: Transform.scale(
                          scale: scale,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                //basic
                basicControls(),

                //locked
                locked(),

                //speed
                speed(),

                //video recording
                videoRecording(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget basicControls() {
    return Visibility(
      visible: (uiState == UIState.BASIC ||
              (_controller.value.isInitialized &&
                  !_controller.value.isBuffering &&
                  !_controller.value.isPlaying)) &&
          uiState != UIState.LOCKED_INVISIBLE &&
          uiState != UIState.LOCKED &&
          uiState != UIState.VIDEO_RECORDING,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: (uiState == UIState.BASIC ||
                    (_controller.value.isInitialized &&
                        !_controller.value.isBuffering &&
                        !_controller.value.isPlaying)) &&
                uiState != UIState.LOCKED_INVISIBLE &&
                uiState != UIState.LOCKED &&
                uiState != UIState.VIDEO_RECORDING
            ? 1
            : 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.6),
          padding: EdgeInsets.only(
            left: Platform.isIOS ? 40 : 10,
            right: 10,
            top: 20,
            bottom: 10,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          width: 35,
                          height: 35,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              movie_name,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Builder(
                    builder: (_) {
                      if (!_controller.value.isInitialized)
                        return Container(
                          width: double.infinity,
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _controller.seekTo(_controller.value.position -
                                  Duration(seconds: 5));
                              changeUItoNone();
                            },
                            icon: SvgPicture.asset(
                                'assets/icons/player/ic_backward.svg'),
                          ),
                          SizedBox(
                            width: 150,
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            child: Builder(
                              builder: (_) {
                                if (_controller.value.isBuffering)
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );

                                return IconButton(
                                  onPressed: () {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                      if (_timer != null) _timer!.cancel();
                                    } else {
                                      _controller.play();
                                      if (mounted)
                                        setState(() {
                                          uiState = UIState.BASIC;
                                        });
                                      changeUItoNone();
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                    _controller.value.isPlaying
                                        ? 'assets/icons/player/ic_pause.svg'
                                        : 'assets/icons/player/ic_play.svg',
                                    width: 80,
                                    height: 80,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 150,
                          ),
                          IconButton(
                            onPressed: () {
                              _controller.seekTo(_controller.value.position +
                                  Duration(seconds: 5));
                            },
                            icon: SvgPicture.asset(
                                'assets/icons/player/ic_forward.svg'),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ProgressBar(
                    timeLabelTextStyle: TextStyle(
                      color: HexColor('#7C7C99'),
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                    barHeight: 11,
                    timeLabelLocation: TimeLabelLocation.above,
                    barCapShape: BarCapShape.square,
                    baseBarColor: Colors.white.withOpacity(.1),
                    progressBarColor: HexColor('#FF0000'),
                    thumbColor: HexColor('#FF0000'),
                    bufferedBarColor: HexColor('#FF0000').withOpacity(0.3),
                    progress: _controller.value.position,
                    thumbRadius: 10,
                    onDragStart: (details) {
                      if (_timer != null) _timer!.cancel();
                    },
                    buffered: _controller.value.buffered.isEmpty
                        ? Duration(seconds: 0)
                        : _controller.value.buffered.last.end,
                    total: _controller.value.duration,
                    onSeek: (value) {
                      _controller.seekTo(value);
                      changeUItoNone();
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Row(
                        children: [
                          IconButton(
                            splashRadius: 20,
                            highlightColor: Colors.grey,
                            onPressed: () {
                              if (_timer != null) _timer!.cancel();
                              if (mounted)
                                setState(() {
                                  uiState = UIState.LOCKED;
                                });
                              _timer =
                                  Timer(Duration(seconds: secondFadeOut), () {
                                if (uiState == UIState.LOCKED) {
                                  if (mounted)
                                    setState(
                                      () {
                                        uiState = UIState.LOCKED_INVISIBLE;
                                      },
                                    );
                                }
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/player/ic_lock.svg',
                              width: 30,
                              height: 30,
                            ),
                          ),
                          IconButton(
                            splashRadius: 20,
                            highlightColor: Colors.grey,
                            onPressed: () {
                              if (mounted)
                                setState(() {
                                  uiState = UIState.SPEED;
                                });
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/player/ic_time.svg',
                              width: 30,
                              height: 30,
                            ),
                          ),
                          IconButton(
                            splashRadius: 20,
                            highlightColor: Colors.grey,
                            onPressed: () {
                              if (_controller.value.isInitialized) {
                                if (scale == 1) {
                                  scale = (MediaQuery.of(context).size.width /
                                          MediaQuery.of(context).size.height) /
                                      _controller.value.aspectRatio;
                                } else {
                                  scale = 1;
                                }
                                if (mounted) setState(() {});
                              }
                              changeUItoNone();
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/player/ic_fullscreen.svg',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget locked() {
    return Visibility(
      visible: uiState == UIState.LOCKED,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: uiState == UIState.LOCKED ? 1 : 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  if (_timer != null) _timer!.cancel();
                  if (mounted)
                    setState(() {
                      uiState = UIState.BASIC;
                    });
                  changeUItoNone();
                },
                icon: SvgPicture.asset(
                  'assets/icons/player/ic_locked.svg',
                  width: 30,
                  height: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double controller_speed = 1;

  Widget speed() {
    return Visibility(
      visible: uiState == UIState.SPEED,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: uiState == UIState.SPEED ? 1 : 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .7,
                    height: 170,
                    child: Blur(
                      blur: 10,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      blurColor: Colors.black,
                      child: Container(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .7,
                    height: 170,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (controller_speed > 0.1) {
                                  setState(() {
                                    controller_speed -= 0.1;
                                  });
                                }
                                _controller.setPlaybackSpeed(controller_speed);
                              },
                              icon: SvgPicture.asset(
                                  'assets/icons/player/ic_minus.svg'),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor('#959595').withOpacity(0.2),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                "Ijro tezligi: ${controller_speed.toStringAsFixed(1)}x",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (controller_speed < 3) {
                                  setState(() {
                                    controller_speed += 0.1;
                                  });
                                }
                                _controller.setPlaybackSpeed(controller_speed);
                              },
                              icon: SvgPicture.asset(
                                  'assets/icons/player/ic_plus.svg'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SfSlider(
                          value: controller_speed,
                          min: 0.5,
                          max: 3,
                          showDividers: true,
                          showLabels: true,
                          stepSize: 0.5,
                          interval: 0.5,
                          labelFormatterCallback: (actualValue, formattedText) {
                            return actualValue.toString() + 'x';
                          },
                          tickShape: SfTickShape(),
                          activeColor: HexColor('#FF0000'),
                          inactiveColor: Colors.white.withOpacity(.1),
                          enableTooltip: true,
                          labelPlacement: LabelPlacement.onTicks,
                          onChanged: (value) {
                            setState(() {
                              controller_speed = value;
                            });
                            _controller.setPlaybackSpeed(controller_speed);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget videoRecording() {
    return Visibility(
      visible: uiState == UIState.VIDEO_RECORDING,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: uiState == UIState.VIDEO_RECORDING ? 1 : 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .7,
                    height: 170,
                    child: Blur(
                      blur: 10,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      blurColor: Colors.black,
                      child: Container(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .7,
                    height: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white)),
                    child: Center(
                      child: Text(
                        "Ekran yozib olinishi aniqlandi!\nBu bizning ilovamizda ta'qiqlangan!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
