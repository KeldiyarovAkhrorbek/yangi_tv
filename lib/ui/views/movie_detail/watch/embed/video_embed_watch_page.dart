import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_prevent_screen_capture/flutter_prevent_screen_capture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../../helpers/video_player_manager.dart';

class VideoPlayerPageEmbed extends StatefulWidget {
  static const routeName = '/video-embed-page';

  @override
  State<VideoPlayerPageEmbed> createState() => _VideoPlayerPageEmbedState();
}

enum UIState {
  NONE,
  BASIC,
  VIDEO_RECORDING,
}

class _VideoPlayerPageEmbedState extends State<VideoPlayerPageEmbed> {
  UIState uiState = UIState.NONE;
  Timer? _timer;
  int secondFadeOut = 5;
  bool isInit = false;
  String movieName = '';
  String videoUrl = '';
  static const platform = MethodChannel('screen_protection');
  bool isPageLoading = true;

  FlutterPreventScreenCapture preventScreenCapture =
      FlutterPreventScreenCapture();

  late InAppWebViewController webViewController;

  Future<void> checkScreenRecord() async {
    final recordStatus = await preventScreenCapture.checkScreenRecord();
    if (recordStatus == true) {
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
    if (Platform.isAndroid) {
      _enableSecure();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) return;

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    videoUrl = arguments['url'];
    movieName = arguments['name'] ?? '';
    if(!videoUrl.contains('?autoplay=1')) {
      videoUrl = videoUrl + '?autoplay=1';
    }

    isInit = true;
  }

  void _enableSecure() async {
    try {
      await platform.invokeMethod('enableSecure');
    } on PlatformException catch (e) {
      log("Failed to enable secure screen: ${e.message}");
    }
  }

  void _disableSecure() async {
    try {
      await platform.invokeMethod('disableSecure');
    } on PlatformException catch (e) {
      log("Failed to disable secure screen: ${e.message}");
    }
  }

  VideoPlayerManager videoPlayerManager = VideoPlayerManager([]);

  void changeUItoNone() {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(Duration(seconds: secondFadeOut), () {
      if (uiState == UIState.BASIC) {
        if (mounted) {
          setState(() {
            uiState = UIState.NONE;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: WillPopScope(
          onWillPop: () async {
            if (uiState == UIState.BASIC) {
              if (mounted) {
                setState(() {
                  uiState = UIState.NONE;
                });
              }
              return false;
            }
      
            if (uiState == UIState.NONE) {
              return true;
            }
      
            if (mounted) {
              setState(() {
                uiState = UIState.BASIC;
              });
            }
            changeUItoNone();
            return false;
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                if (uiState != UIState.VIDEO_RECORDING)
                  InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(videoUrl),
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      transparentBackground: true,
                      allowsInlineMediaPlayback: true,
                      builtInZoomControls: false,
                      overScrollMode: OverScrollMode.NEVER,
                      displayZoomControls: false,
                      allowBackgroundAudioPlaying: false,
                      allowsLinkPreview: false,
                      disableContextMenu: true,
                      disableLongPressContextMenuOnLinks: true,
                      mediaPlaybackRequiresUserGesture: false,
                    ),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        isPageLoading = false;
                      });
                      // Inject JavaScript to handle custom elements or remove controls
                      await webViewController.evaluateJavascript(source: '''
                       //   // Disable context menu
                                document.addEventListener('contextmenu', event => event.preventDefault());
                  
                                // Remove placeholder and fullscreen control button
                                const removeElements = () => {
                  // Example: Find and hide the play button or overlay
                  const placeholder = document.querySelector('.vjs-big-play-button');
                  if (placeholder) {
                    placeholder.style.display = 'none'; // Hide the element
                  }
                  
                  // Remove fullscreen control button
                  const fullscreenControl = document.querySelector('.vjs-fullscreen-control');
                  if (fullscreenControl) {
                    fullscreenControl.remove(); // Completely remove the fullscreen control button
                  }
                                };
                  
                                // Observe DOM for changes
                                const observer = new MutationObserver(mutations => {
                  mutations.forEach(mutation => {
                    mutation.addedNodes.forEach(node => {
                      // Check if the added node is the context menu
                      if (node.classList && node.classList.contains('vjs-contextmenu-ui-menu')) {
                        node.remove(); // Remove the context menu
                      }
                      // Check if the added node is the fullscreen control button
                      if (node.classList && node.classList.contains('vjs-fullscreen-control')) {
                        node.remove(); // Remove fullscreen control button
                      }
                  
                      if (node.classList && node.classList.contains('peertube-dock')) {
                        node.remove(); // Remove fullscreen control button
                      }
                    });
                  });
                  // Remove placeholder elements and fullscreen control
                  removeElements();
                                });
                  
                                // Start observing the body for changes
                                observer.observe(document.body, { childList: true, subtree: true });
                  
                                // Initial call to remove the elements
                                removeElements();
                      ''');
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      if (navigationAction.request.url
                          .toString()
                          .contains('videos/embed')) {
                        return NavigationActionPolicy.ALLOW;
                      }
                  
                      return NavigationActionPolicy.CANCEL;
                    },
                  ),
                if (isPageLoading) ...{
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                },
                Positioned.fill(
                  child: Listener(
                    behavior: HitTestBehavior.translucent,
                    onPointerDown: (event) {
                      if (event.kind == PointerDeviceKind.touch) {
                        if (_timer != null) _timer!.cancel();
      
                        if (uiState == UIState.NONE) {
                          if (mounted) {
                            setState(() {
                              uiState = UIState.BASIC;
                            });
                          }
                          changeUItoNone();
                          return;
                        }
                        if (uiState == UIState.BASIC) {
                          if (_timer != null) _timer!.cancel();
                          if (mounted) {
                            setState(() {
                              uiState = UIState.NONE;
                            });
                          }
                          return;
                        }
                      }
                    },
                  ),
                ),
                AnimatedOpacity(
                  opacity: uiState == UIState.BASIC ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: AnimatedContainer(
                    width: double.infinity,
                    duration: Duration(milliseconds: 200),
                    height: uiState == UIState.BASIC ? 50 : 0,
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            movieName,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                videoRecording(),
              ],
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
                      borderRadius: BorderRadius.circular(10),
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

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer!.cancel();
    _timer = null;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    KeepScreenOn.turnOff();
    videoPlayerManager.dispose();
    if (Platform.isAndroid) {
      _disableSecure();
    }
  }
}
