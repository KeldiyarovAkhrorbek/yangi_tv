import 'dart:async';
import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:blur/blur.dart';
import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_prevent_screen_capture/flutter_prevent_screen_capture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:video_player/video_player.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_events.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/database/movie_db.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:yangi_tv_new/helpers/decryptor.dart';
import 'package:yangi_tv_new/models/single_movie_url.dart';

import '../../../../../helpers/video_player_manager.dart';

class VideoPlayerPageSingle extends StatefulWidget {
  static const routeName = '/video-player-single';

  @override
  State<VideoPlayerPageSingle> createState() => _VideoPlayerPageSingleState();
}

enum UIState {
  NONE,
  BASIC,
  LOCKED,
  LOCKED_INVISIBLE,
  QUALITY,
  SPEED,
  CAST,
  VIDEO_RECORDING,
}

class _VideoPlayerPageSingleState extends State<VideoPlayerPageSingle> {
  String movie_name = '';
  SingleMovieUrl? singleMovieUrl;
  int? profile_id;

  //id
  int movieID = 0;

  //last duration
  int lastDurationSeconds = 0;

  //quality
  String quality = '';

  //videourl
  String videoUrl = '';

  //position
  Duration currentPosition = Duration.zero;
  String image = '';
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

  @override
  void initState() {
    super.initState();
    KeepScreenOn.turnOn();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (Platform.isIOS) {
      checkScreenRecord();
    }
    if(Platform.isAndroid) {
      _enableSecure();
    }
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (singleMovieUrl != null) return;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    movie_name = args['movie_name'];
    singleMovieUrl = args['url'];
    image = args['image'];
    movieID = args['movieID'];
    profile_id = args['profile_id'];
    prepareAudio();
    if (singleMovieUrl!.resolution360A != null) {
      quality = '360p';
      videoUrl = decryptArray(singleMovieUrl!.resolution360A!);
    } else if (singleMovieUrl!.resolution480A != null) {
      quality = '480p';
      videoUrl = decryptArray(singleMovieUrl!.resolution480A!);
    } else if (singleMovieUrl!.resolution720A != null) {
      quality = 'HD';
      videoUrl = decryptArray(singleMovieUrl!.resolution720A!);
    } else if (singleMovieUrl!.resolution1080A != null) {
      quality = 'FHD';
      videoUrl = decryptArray(singleMovieUrl!.resolution1080A!);
    } else if (singleMovieUrl!.resolution1080A != null) {
      quality = '4K';
      videoUrl = decryptArray(singleMovieUrl!.resolution2160A!);
    }
    getVideoTime();
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl),
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
      await MovieDB()
          .create(id: movieID, time: _controller.value.position.inSeconds);
      if (mounted) setState(() {});
      if (profile_id != null) if (_controller.value.position.inSeconds % 600 ==
              0 &&
          _controller.value.position.inSeconds >= 10) {
        videoPlayerManager.play();
      }
    });
  }


  static const platform = MethodChannel('screen_protection');

  void _enableSecure() async {
    try {
      await platform.invokeMethod('enableSecure');
    } on PlatformException catch (e) {
      // print("Failed to enable secure screen: ${e.message}");
    }
  }

  void _disableSecure() async {
    try {
      await platform.invokeMethod('disableSecure');
    } on PlatformException catch (e) {
      // print("Failed to disable secure screen: ${e.message}");
    }
  }

  VideoPlayerManager videoPlayerManager = VideoPlayerManager([]);

  void prepareAudio() async {
    if (profile_id == null) return;
    List<String> numbers = [];
    for (var i = 0; i < profile_id!.toString().length; i++) {
      numbers.add("assets/numbers/${profile_id!.toString()[i]}.mp4");
    }
    videoPlayerManager = VideoPlayerManager(numbers);
    await videoPlayerManager.initialize();
  }

  void getVideoTime() async {
    lastDurationSeconds = await MovieDB().fetchWatchedMovieTime(movieID);
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

                  cast(context),

                  //video recording
                  videoRecording(),

                  //quality
                  qualityControls(),
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
          uiState != UIState.VIDEO_RECORDING &&
          uiState != UIState.CAST &&
          uiState != UIState.QUALITY,
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
                uiState != UIState.VIDEO_RECORDING &&
                uiState != UIState.CAST
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
                        Text(
                          movie_name,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              uiState = UIState.CAST;
                              BlocProvider.of<CastBloc>(context)
                                ..add(GetCastDevicesEvent());
                            });
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/player/ic_cast.svg',
                            width: 30,
                            height: 30,
                          ),
                        ),
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
                              if (_timer != null) _timer!.cancel();
                              setState(() {
                                uiState = UIState.QUALITY;
                              });
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/player/quality/${quality}.svg',
                              width: 40,
                              height: 40,
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

  Widget cast(BuildContext context) {
    return Visibility(
      visible: uiState == UIState.CAST,
      maintainAnimation: true,
      maintainState: true,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: uiState == UIState.CAST ? 1 : 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              height: 300,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: HexColor(
                  '#4D4D4D',
                )),
              ),
              child: Stack(
                children: [
                  Blur(
                    child: Container(width: 400, height: 300),
                    blur: 20,
                    blurColor: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              uiState = UIState.BASIC;
                            });
                            changeUItoNone();
                          },
                          icon: SvgPicture.asset(
                              'assets/icons/player/ic_close.svg'),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    width: 400,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: BlocConsumer<CastBloc, CastState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: SvgPicture.asset(
                                      'assets/icons/player/ic_cast.svg',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Chromecast",
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Builder(
                                builder: (_) {
                                  if (state is CastLoadingState) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    );
                                  }

                                  if (state is CastSuccessState &&
                                      state.devices.isNotEmpty)
                                    return Container(
                                      height: 150,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: state.devices.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(bottom: 5),
                                            decoration: BoxDecoration(
                                              color: HexColor('#959595')
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                                onTap: () {
                                                  _connectAndPlayMedia(context,
                                                      state.devices[index]);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/icons/player/ic_tv.svg'),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          state.devices[index]
                                                              .name,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );

                                  return Text(
                                    "Chromecast qurilmalari topilmadi!",
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: HexColor('#FF0000'),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Muhim!",
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: HexColor('#FF0000'),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          " Mobil qurilma va Smart TV\nbitta Wi-Fi modemiga ulangan bo’lishi kerak!",
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
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

  Widget qualityControls() {
    return Visibility(
      visible: uiState == UIState.QUALITY,
      maintainAnimation: true,
      maintainState: true,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(1),
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
                              setState(() {
                                uiState = UIState.BASIC;
                              });
                              changeUItoNone();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Film sifatini tanlang:",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                    child: GridView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        if (singleMovieUrl!.resolution360A != null)
                          qualityItem('360p', quality, "360p"),
                        if (singleMovieUrl!.resolution480A != null)
                          qualityItem('480p', quality, "480p"),
                        if (singleMovieUrl!.resolution720A != null)
                          qualityItem('720p', quality, "HD"),
                        if (singleMovieUrl!.resolution1080A != null)
                          qualityItem('1080p', quality, "FHD"),
                        if (singleMovieUrl!.resolution2160A != null)
                          qualityItem('4K', quality, "4K"),
                      ],
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 70,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget qualityItem(String text, String currentQuality, String slug) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        color:
            slug == currentQuality ? HexColor('#FF0000') : HexColor('#1E1E34'),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            5,
          ),
          onTap: () {
            if (slug == currentQuality) return;
            if (_controller.value.position != Duration.zero) {
              currentPosition = _controller.value.position;
            }
            if (text == '360p') {
              videoUrl = decryptArray(singleMovieUrl!.resolution360A!);
            } else if (text == '480p') {
              videoUrl = decryptArray(singleMovieUrl!.resolution480A!);
            } else if (text == '720p') {
              videoUrl = decryptArray(singleMovieUrl!.resolution720A!);
            } else if (text == '1080p') {
              videoUrl = decryptArray(singleMovieUrl!.resolution1080A!);
            } else {
              videoUrl = decryptArray(singleMovieUrl!.resolution2160A!);
            }
            setState(() {
              quality = slug;
            });
            _controller.dispose();
            _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
              ..initialize().then((_) {
                _controller.seekTo(currentPosition);
                if (mounted)
                  setState(() {
                    _controller.setLooping(false);
                    _controller.play();
                  });
              });
            _controller.addListener(() {
              if (mounted) setState(() {});
              if (_controller.value.position.inSeconds % 600 == 0 &&
                  _controller.value.position.inSeconds >= 10) {
                videoPlayerManager.play();
              }
            });
            setState(() {
              uiState = UIState.BASIC;
            });
            changeUItoNone();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _connectAndPlayMedia(
      BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        final snackBar =
            SnackBar(content: Text('${object.name} qurilmaga ulandi!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          uiState = UIState.BASIC;
        });
        changeUItoNone();
      }
    });

    var index = 0;

    session.messageStream.listen((message) {
      index += 1;

      if (index == 2) {
        Future.delayed(Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session);
        });
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845',
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    var message = {
      'contentId': videoUrl,
      'contentType': 'video/mp4',
      'streamType': 'BUFFERED',
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': movie_name + " " + quality,
        'images': [
          {
            'url': image,
          }
        ]
      }
    };

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
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
    videoPlayerManager.dispose();
    if(Platform.isAndroid) {
      _disableSecure();
    }
  }
}
