import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:yangi_tv_new/models/story.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/movie_detail_page.dart';

import '../../helpers/color_changer.dart';

class StoryWatchItem extends StatefulWidget {
  Story story;
  final VoidCallback onEntered;

  StoryWatchItem(this.story, this.onEntered);

  @override
  State<StoryWatchItem> createState() => _StoryWatchItemState();
}

class _StoryWatchItemState extends State<StoryWatchItem> {
  late VideoPlayerController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onEntered();
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(
        widget.story.video ?? '',
      ))
        ..initialize().then((_) {
          if (mounted)
            setState(() {
              _controller.setLooping(true);
              _controller.play();
            });
        });

      _controller.addListener(() {
        if (mounted) setState(() {});
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
            if (mounted) setState(() {});
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: _controller.value.isInitialized
                      ? Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                      : Container(
                    color: Colors.black,
                    child: Center(
                      child: SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: !_controller.value.isPlaying &&
                      _controller.value.isInitialized
                      ? Center(
                    child: IconButton(
                      onPressed: () {
                        _controller.play();
                        if (mounted) setState(() {});
                      },
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  )
                      : Container(),
                ),
                //name
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.only(top: 27, left: 10),
                  child: Text(
                    widget.story.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: true,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        ProgressBar(
                          progress: _controller.value.position,
                          total: _controller.value.duration,
                          progressBarColor: Colors.red,
                          baseBarColor: Colors.white.withOpacity(0.24),
                          bufferedBarColor: Colors.white.withOpacity(0.24),
                          thumbColor: Colors.white,
                          barHeight: 3.0,
                          thumbGlowRadius: 0,
                          thumbRadius: 0,
                          timeLabelLocation: TimeLabelLocation.none,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            onTap: () {
                              Navigator.of(context).maybePop();
                            },
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        //watch button
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 30,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#E82C2A'),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                width: 200,
                height: 45,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    onTap: () {
                      _controller.pause();
                      Navigator.of(context)
                          .pushNamed(MovieDetailPage.routeName, arguments: {
                        'content_id': widget.story.contentId,
                        'movie_name': widget.story.name,
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Tomosha qilish",
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
            ),
          ),
        ),
      ],
    );
  }
}