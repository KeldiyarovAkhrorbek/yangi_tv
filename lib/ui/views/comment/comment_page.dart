import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/widgets/comment/comment_item.dart';

import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';

class CommentPage extends StatefulWidget {
  static const routeName = '/comment-page';

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String movie_name = '';
  int content_id = 0;
  bool is_comments = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    content_id = args['content_id'] as int;
    movie_name = args['movie_name'] as String;
    is_comments = args['is_comments'] as bool;
  }

  ScrollController scrollController = ScrollController();
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();
  bool canSendComment = false;

  @override
  void dispose() {
    super.dispose();
    commentFocusNode.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      CommentBloc(RepositoryProvider.of<MainRepository>(context))
        ..add(GetCommentEvent(content_id)),
      child: BlocConsumer<CommentBloc, CommentState>(
        listener: (context, state) {
          if (state is CommentSuccessState && state.newComment) {
            commentFocusNode.unfocus();
            commentController.text = '';
            scrollController.jumpTo(0);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  backgroundColor: Colors.black,
                  centerTitle: true,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  title: Column(
                    children: [
                      Text(
                        movie_name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Text(
                        "Izohlar bo'limi",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Builder(
                builder: (_) {
                  scrollController.addListener(
                        () async {
                      if (state is CommentSuccessState && !state.isPaginating) {
                        if (scrollController.position.pixels ==
                            scrollController.position.maxScrollExtent) {
                          BlocProvider.of<CommentBloc>(context).add(
                            PaginateCommentEvent(),
                          );
                        }
                      }
                    },
                  );
                  if (state is CommentLoadingState)
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  if (state is CommentSuccessState) {
                    return Stack(
                      children: [
                        if (state.comments.isNotEmpty)
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                ListView.builder(
                                  physics: PageScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      CommentItem(state.comments[index]),
                                  itemCount: state.comments.length,
                                ),
                                if (state.isPaginating)
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (state.isPaginating)
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                SizedBox(
                                  height: 150,
                                ),
                              ],
                            ),
                          ),
                        if (state.comments.isEmpty)
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/comment/ic_no_comment.svg',
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "Hali hech kim izoh yozmadi,\nsiz birinchi bo'lishingiz mumkin!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        Visibility(
                          visible: is_comments,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, left: 8),
                                        child: CustomPaint(
                                          painter: ChatShape(),
                                          child: Container(
                                            width: double.infinity,
                                            height: 100,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10.0, left: 8),
                                        child: Container(
                                          width:
                                          MediaQuery.of(context).size.width *
                                              .84,
                                          height: 100,
                                          padding: EdgeInsets.only(
                                            left: 13,
                                            right: 13,
                                            top: 18,
                                          ),
                                          child: TextField(
                                            controller: commentController,
                                            focusNode: commentFocusNode,
                                            minLines: 3,
                                            maxLines: 3,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                            onChanged: (value) {
                                              if (value.trim().length > 0) {
                                                setState(() {
                                                  canSendComment = true;
                                                });
                                              } else {
                                                setState(() {
                                                  canSendComment = false;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintText: "Izoh kiriting...",
                                              hintStyle: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 100,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                onPressed: canSendComment
                                                    ? () {
                                                  BlocProvider.of<
                                                      CommentBloc>(context)
                                                    ..add(
                                                      AddCommentEvent(
                                                        content_id,
                                                        commentController
                                                            .text
                                                            .trim(),
                                                      ),
                                                    );
                                                }
                                                    : null,
                                                icon: SvgPicture.asset(
                                                  'assets/icons/comment/ic_send.svg',
                                                  color: canSendComment
                                                      ? Colors.white
                                                      : Colors.white
                                                      .withOpacity(0.6),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  width: double.infinity,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: [
                                        0,
                                        0.8,
                                        1,
                                      ],
                                      colors: [
                                        Colors.black,
                                        Colors.black,
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !is_comments,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Stack(
                                    children: [
                                      Blur(
                                        child: Container(
                                            width: double.infinity, height: 100),
                                        blurColor: Colors.black,
                                        blur: 10,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/comment/ic_forbidden.svg',
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Ushbu kontentga izoh qoldirish o'chirilgan.",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.inter(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  width: double.infinity,
                                  height: 100,
                                  color: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }

                  return Container();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_fill_0 = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.0750000, size.height);
    path_0.cubicTo(
        size.width * 0.0119500,
        size.height * 0.9971000,
        size.width * -0.0000500,
        size.height * 0.9715000,
        0,
        size.height * 0.8500000);
    path_0.cubicTo(
        size.width * 0.0002500,
        size.height * 0.6500000,
        size.width * -0.0002500,
        size.height * 0.5500000,
        0,
        size.height * 0.3500000);
    path_0.cubicTo(
        size.width * 0.0005000,
        size.height * 0.2258000,
        size.width * 0.0097000,
        size.height * 0.2010000,
        size.width * 0.0750000,
        size.height * 0.2000000);
    path_0.cubicTo(
        size.width * 0.2620000,
        size.height * 0.2000000,
        size.width * 0.6130000,
        size.height * 0.2000000,
        size.width * 0.8000000,
        size.height * 0.2000000);
    path_0.cubicTo(
        size.width * 0.8796500,
        size.height * 0.1989000,
        size.width * 0.8997500,
        size.height * 0.2311000,
        size.width * 0.9010000,
        size.height * 0.3500000);
    path_0.quadraticBezierTo(size.width * 0.9007500, size.height * 0.4755000,
        size.width * 0.9002000, size.height * 0.5016000);
    path_0.quadraticBezierTo(size.width * 0.8979000, size.height * 0.6614000,
        size.width * 0.9000000, size.height * 0.7008000);
    path_0.quadraticBezierTo(size.width * 0.9012500, size.height * 0.8025000,
        size.width * 1.0010000, size.height * 0.9980000);
    path_0.quadraticBezierTo(size.width * 0.7882500, size.height * 0.9970000,
        size.width * 0.0750000, size.height);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    //added
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white;

    canvas.drawPath(path_0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}