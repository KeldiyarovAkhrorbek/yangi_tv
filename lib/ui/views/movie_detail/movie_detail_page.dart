import 'dart:ui';
import 'package:blur/blur.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/helpers/custom_image_loader.dart';
import 'package:yangi_tv_new/models/movie_full.dart';
import 'package:yangi_tv_new/ui/views/comment/comment_page.dart';
import 'package:yangi_tv_new/ui/views/genre_detail/genre_detail_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/download/multi/multi_download_season_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/download/single/single_download_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/screenshot_page.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/youtube_player_page.dart';
import 'package:yangi_tv_new/ui/views/person_detail/person_detail_page.dart';
import 'package:yangi_tv_new/ui/views/profile/tariffs_page/tariffs_page.dart';
import 'package:yangi_tv_new/ui/widgets/detail/quality_episode.dart';
import 'package:yangi_tv_new/ui/widgets/loading/movie_item_loading.dart';
import 'package:yangi_tv_new/ui/widgets/movie_related_item.dart';

import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/translit.dart';
import '../../widgets/movie_item.dart';
import 'watch/multi/seasons_page.dart';
import 'watch/single/video_player_page_single.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/movie-detail-page';

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  String imageUrl = '';
  int content_id = 0;
  String movie_name = '';
  String? type;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (args['imageUrl'] != null) imageUrl = args['imageUrl'] as String;
    content_id = args['content_id'] as int;
    if (args['movie_name'] != null) movie_name = args['movie_name'] as String;
    if (args['type'] != null) type = args['type'];
  }

  Widget buildActor(Actor actor, VoidCallback pressed) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(PersonDetailPage.routeName, arguments: {
          'person_name': Translit().toTranslit(
              source: actor.name.replaceAll("Дж", "Ж").replaceAll("дж", "ж")),
          'person_id': actor.id,
          'person_image': actor.image,
        });
      },
      child: Container(
        width: 60,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CustomImageLoader(
                imageUrl: actor.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                borderRadius: 0,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              Translit().toTranslit(
                  source:
                      actor.name.replaceAll("Дж", "Ж").replaceAll("дж", "ж")),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final ScrollController scrollController = ScrollController();
  bool show = false;

  void openTryAgainDialog(VoidCallback tryAgainPressed) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Stack(
                  children: [
                    Blur(
                      blur: 7,
                      blurColor: HexColor('#4D4D4D').withOpacity(1),
                      child: Container(
                        width: double.infinity,
                        child: SizedBox(
                          height: 220,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SvgPicture.asset(
                            'assets/icons/auth/ic_dangerous.svg',
                            height: 50,
                            width: 50,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Ma'lumotni yuklab bo'lmadi,\niltimos, qayta urining.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: HexColor('#FF4747'),
                                  onPressed: () {
                                    tryAgainPressed();
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Qayta urinish',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  String proceedType = '';

  void openWarningDialog(BuildContext context, VoidCallback proceedPressed) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Stack(
                  children: [
                    Blur(
                      blur: 7,
                      blurColor: HexColor('#4D4D4D').withOpacity(1),
                      child: Container(
                        width: double.infinity,
                        child: SizedBox(
                          height: 250,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SvgPicture.asset(
                              'assets/icons/watch/ic_warning.svg'),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Ushbu kontent uchun yosh chegarasi 18+ deb belgilangan.\nSiz 18 yoshdan oshganmisiz?",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      "Yo'q",
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: HexColor('#FF4747'),
                                  onPressed: () async {
                                    Navigator.of(context).maybePop();
                                    await Future.delayed(
                                        Duration(milliseconds: 100));
                                    proceedPressed();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Ha',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MovieDetailBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(LoadMovieDetailEvent(content_id)),
      child: BlocConsumer<MovieDetailBloc, MovieDetailState>(
          listener: (context, state) {
        if (state is MovieDetailErrorState) {
          openTryAgainDialog(() {
            BlocProvider.of<MovieDetailBloc>(context)
              ..add(LoadMovieDetailEvent(content_id));
          });
        }

        if (state is MovieDetailLoadedState &&
            (state.isUrlWatchLoaded || state.isUrlDownloadLoaded) &&
            state.errorUrlText == 'socket') {
          openTryAgainDialog(() {
            BlocProvider.of<MovieDetailBloc>(context)
              ..add(LoadMovieUrlEvent(proceedType));
          });
        }
        if (state is MovieDetailLoadedState &&
            (state.isUrlWatchLoaded || state.isUrlDownloadLoaded) &&
            state.errorUrlText == 'notariff') {
          Navigator.of(context).pushNamed(TariffsPage.routeName, arguments: {
            'tariff_filter': state.movie.tariff,
          });
          return;
        }

        //watch single
        if (state is MovieDetailLoadedState &&
            state.isUrlWatchLoaded &&
            state.singleMovieURL != null) {
          if (state.movie.age != null && state.movie.age!.contains("18")) {
            openWarningDialog(
              context,
              () {
                Navigator.of(context)
                    .pushNamed(VideoPlayerPageSingle.routeName, arguments: {
                  'url': state.singleMovieURL,
                  'movie_name': state.movie.name,
                  'image': state.movie.poster,
                  'movieID': state.movie.id,
                  'profile_id': state.movie.voice_mode,
                });
              },
            );
          } else {
            Navigator.of(context)
                .pushNamed(VideoPlayerPageSingle.routeName, arguments: {
              'url': state.singleMovieURL,
              'movie_name': state.movie.name,
              'image': state.movie.poster,
              'movieID': state.movie.id,
              'profile_id': state.movie.voice_mode,
            });
          }
          return;
        }

        //watch multi
        if (state is MovieDetailLoadedState &&
            state.isUrlWatchLoaded &&
            state.seasons.isNotEmpty) {
          if (state.movie.age != null && state.movie.age!.contains("18")) {
            openWarningDialog(
              context,
              () {
                Navigator.of(context)
                    .pushNamed(SeasonPage.routeName, arguments: {
                  'seasons': state.seasons,
                  'name': state.movie.name,
                  'image': state.movie.poster,
                  'profile_id': state.movie.voice_mode,
                });
              },
            );
          } else {
            Navigator.of(context).pushNamed(SeasonPage.routeName, arguments: {
              'seasons': state.seasons,
              'name': state.movie.name,
              'image': state.movie.poster,
              'profile_id': state.movie.voice_mode,
            });
          }
          return;
        }

        //download
        if (state is MovieDetailLoadedState &&
            state.isUrlDownloadLoaded &&
            state.singleMovieURL != null) {
          Navigator.of(context)
              .pushNamed(SingleDownloadPage.routeName, arguments: {
            'singleMovieUrl': state.singleMovieURL,
            'movie_name': state.movie.name,
            'image': state.movie.poster,
            'tariff': state.movie.tariff,
          });
          return;
        }

        //download
        if (state is MovieDetailLoadedState &&
            state.isUrlDownloadLoaded &&
            state.seasons.isNotEmpty) {
          Navigator.of(context)
              .pushNamed(MultiDownloadSeasonPage.routeName, arguments: {
            'seasons': state.seasons,
            'name': state.movie.name,
            'image': state.movie.poster,
            'tariff': state.movie.tariff,
          });
          return;
        }
      }, builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: AppBar(
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              flexibleSpace: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: double.infinity,
                height: double.infinity,
                color: show ? Colors.black : Colors.transparent,
              ),
              leading: Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 6.0,
                  bottom: 6.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      onTap: () {
                        Navigator.of(context).maybePop();
                      },
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: show ? 1 : 0,
                child: Text(
                  movie_name,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              actions: [
                if (state is MovieDetailLoadedState)
                  LikeButton(
                    isLiked: state.isFavorite,
                    onTap: (isLiked) async {
                      BlocProvider.of<MovieDetailBloc>(context)
                        ..add(AddToFavoriteEvent());
                      return !isLiked;
                    },
                  ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Builder(
              builder: (_) {
                scrollController.addListener(() {
                  if (scrollController.position.pixels >= 50) {
                    setState(() {
                      show = true;
                    });
                  }
                  if (scrollController.position.pixels < 50) {
                    setState(() {
                      show = false;
                    });
                  }
                });
                if (state is MovieDetailLoadingState)
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          CustomPaint(
                            foregroundPainter: FadingEffect(),
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 6,
                                sigmaY: 6,
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
                                child: Container(
                                  width: double.infinity,
                                  height: 250,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.transparent,
                                    size: 50,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        if (imageUrl != '')
                                          ClipRRect(
                                            child: Hero(
                                              tag: imageUrl +
                                                  "${content_id}" +
                                                  "${type ?? "main"}",
                                              child: CustomImageLoader(
                                                imageUrl: imageUrl,
                                                width: 150,
                                                height: 220,
                                                fit: BoxFit.cover,
                                                borderRadius: 0,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        if (imageUrl == '')
                                          Shimmer.fromColors(
                                            baseColor: Constants
                                                .defaultShimmerBaseColor,
                                            highlightColor: Constants
                                                .defaultShimmerHighlightColor,
                                            child: Container(
                                              width: 150,
                                              height: 220,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 220,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: Constants
                                                  .defaultShimmerBaseColor,
                                              highlightColor: Constants
                                                  .defaultShimmerHighlightColor,
                                              child: Container(
                                                width: 170,
                                                height: 20,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Constants
                                                  .defaultShimmerBaseColor,
                                              highlightColor: Constants
                                                  .defaultShimmerHighlightColor,
                                              child: Container(
                                                width: 100,
                                                height: 10,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Constants
                                                  .defaultShimmerBaseColor,
                                              highlightColor: Constants
                                                  .defaultShimmerHighlightColor,
                                              child: Container(
                                                width: 120,
                                                height: 10,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor: Constants
                                                      .defaultShimmerBaseColor,
                                                  highlightColor: Constants
                                                      .defaultShimmerHighlightColor,
                                                  child: Container(
                                                    width: 50,
                                                    height: 10,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: Constants
                                                      .defaultShimmerBaseColor,
                                                  highlightColor: Constants
                                                      .defaultShimmerHighlightColor,
                                                  child: Container(
                                                    width: 50,
                                                    height: 10,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor: Constants
                                                      .defaultShimmerBaseColor,
                                                  highlightColor: Constants
                                                      .defaultShimmerHighlightColor,
                                                  child: Container(
                                                    width: 50,
                                                    height: 10,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: Constants
                                                      .defaultShimmerBaseColor,
                                                  highlightColor: Constants
                                                      .defaultShimmerHighlightColor,
                                                  child: Container(
                                                    width: 50,
                                                    height: 10,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Shimmer.fromColors(
                                                  baseColor: Constants
                                                      .defaultShimmerBaseColor,
                                                  highlightColor: Constants
                                                      .defaultShimmerHighlightColor,
                                                  child: Container(
                                                    width: 50,
                                                    height: 10,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Shimmer.fromColors(
                                                  baseColor: Constants
                                                      .defaultShimmerBaseColor,
                                                  highlightColor: Constants
                                                      .defaultShimmerHighlightColor,
                                                  child: Container(
                                                    width: 50,
                                                    height: 10,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Constants
                                                  .defaultShimmerBaseColor,
                                              highlightColor: Constants
                                                  .defaultShimmerHighlightColor,
                                              child: Container(
                                                width: double.infinity,
                                                height: 35,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // reaction
                              SizedBox(
                                height: 60,
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 70,
                                        height: 60,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 70,
                                        height: 60,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 70,
                                        height: 60,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 70,
                                        height: 60,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 70,
                                        height: 60,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 70,
                                        height: 60,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 70,
                                        height: 60,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 60,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 80,
                                      child: Shimmer.fromColors(
                                        baseColor:
                                            Constants.defaultShimmerBaseColor,
                                        highlightColor: Constants
                                            .defaultShimmerHighlightColor,
                                        child: Container(
                                          width: 70,
                                          height: 60,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 20,
                                      child: Shimmer.fromColors(
                                        baseColor:
                                            Constants.defaultShimmerBaseColor,
                                        highlightColor: Constants
                                            .defaultShimmerHighlightColor,
                                        child: Container(
                                          width: 70,
                                          height: 60,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // genre
                              Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
                                child: Container(
                                  width: 100,
                                  height: 20,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 30,
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 100,
                                        height: 30,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //about
                              SizedBox(
                                height: 10,
                              ),
                              Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
                                child: Container(
                                  width: 150,
                                  height: 20,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
                                child: Container(
                                  width: double.infinity,
                                  height: 20,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
                                child: Container(
                                  width: 300,
                                  height: 20,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                              //actors and directors
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor:
                                        Constants.defaultShimmerBaseColor,
                                    highlightColor:
                                        Constants.defaultShimmerHighlightColor,
                                    child: Container(
                                      width: 60,
                                      height: 20,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor:
                                        Constants.defaultShimmerBaseColor,
                                    highlightColor:
                                        Constants.defaultShimmerHighlightColor,
                                    child: Container(
                                      width: 60,
                                      height: 20,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 60,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              // other
                              Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
                                child: Container(
                                  width: 100,
                                  height: 20,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              //related movies
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 230,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 10,
                                  ),
                                  itemBuilder: (context, index) =>
                                      MovieItemLoading(),
                                  itemCount: 5,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                if (state is MovieDetailLoadedState) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: scrollController,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              CustomPaint(
                                foregroundPainter: FadingEffect(),
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 6,
                                    sigmaY: 6,
                                  ),
                                  child: Container(
                                    height: 250,
                                    child: CarouselSlider.builder(
                                      unlimitedMode: true,
                                      onSlideStart: () {},
                                      onSlideChanged: (value) {},
                                      itemCount:
                                          state.movie.screenshots?.length ?? 0,
                                      slideBuilder: (index) {
                                        return CustomImageLoader(
                                          width: double.infinity,
                                          height: 250,
                                          imageUrl: state.movie
                                                  .screenshots?[index].image ??
                                              '',
                                          borderRadius: 0,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      autoSliderDelay: Duration(seconds: 5),
                                      enableAutoSlider: true,
                                      slideTransform: ParallaxTransform(),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 60),
                                  //play icon
                                  Center(
                                    child: IconButton(
                                      onPressed: () {
                                        BlocProvider.of<MovieDetailBloc>(
                                            context)
                                          ..add(LoadMovieUrlEvent('watch'));
                                      },
                                      icon: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              child: Hero(
                                                tag: imageUrl +
                                                    "${content_id}" +
                                                    "${type ?? "main"}",
                                                child: CustomImageLoader(
                                                  imageUrl: state.movie.poster,
                                                  width: 150,
                                                  height: 220,
                                                  fit: BoxFit.cover,
                                                  borderRadius: 0,
                                                ),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            Positioned(
                                              top: 4.0,
                                              right: 4.0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 3, sigmaY: 3),
                                                  child: Container(
                                                    color: Colors.black
                                                        .withOpacity(
                                                      0.54,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          state.movie.tariff,
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle:
                                                                TextStyle(
                                                              color: state.movie
                                                                          .tariff ==
                                                                      'PREMIUM'
                                                                  ? HexColor(
                                                                      '#FFD914')
                                                                  : Colors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (state
                                                .movie.qualities.isNotEmpty)
                                              QualityEpisode(state),
                                          ],
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: double.infinity,
                                            height: 220,
                                            margin: EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.movie.name,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  state.movie.origName ?? '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                      color:
                                                          HexColor('#BCBCBC'),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  state.movie.nameRu ?? '',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                      color:
                                                          HexColor('#BCBCBC'),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                //lang
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Tili:',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        state.movie.lang ?? '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2),
                                                //year
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Yili:',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        state.movie.year
                                                                .toString() ??
                                                            '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2),
                                                //country
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Davlati:',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        state.movie.countries
                                                                .isNotEmpty
                                                            ? state
                                                                    .movie
                                                                    .countries[
                                                                        0]
                                                                    .name
                                                                    .toString() ??
                                                                ''
                                                            : '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                //trailer
                                                if (state
                                                        .movie.youtubeTrailer !=
                                                    null)
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5,
                                                      ),
                                                      color:
                                                          HexColor('#008A40'),
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  YoutubePlayerPage
                                                                      .routeName,
                                                                  arguments: {
                                                                'videoId': state
                                                                    .movie
                                                                    .youtubeTrailer!,
                                                              });
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 8,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "Treylerni ko'rish"
                                                                    .toUpperCase(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // reaction
                                  Container(
                                    height: 55,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        // like
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () {
                                                BlocProvider.of<
                                                    MovieDetailBloc>(context)
                                                  ..add(
                                                      PutReactionEvent('like'));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      state.reactionType ==
                                                              'like'
                                                          ? Icons.thumb_up_alt
                                                          : Icons
                                                              .thumb_up_alt_outlined,
                                                      color:
                                                          state.reactionType ==
                                                                  'like'
                                                              ? HexColor(
                                                                  "#00E733")
                                                              : Colors.white,
                                                    ),
                                                    Text(
                                                      state.likeCount
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // dislike
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () {
                                                BlocProvider.of<
                                                    MovieDetailBloc>(context)
                                                  ..add(PutReactionEvent(
                                                      'dislike'));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(
                                                      state.reactionType ==
                                                              'dislike'
                                                          ? Icons.thumb_down_alt
                                                          : Icons
                                                              .thumb_down_alt_outlined,
                                                      color:
                                                          state.reactionType ==
                                                                  'dislike'
                                                              ? HexColor(
                                                                  "#FF0000")
                                                              : Colors.white,
                                                    ),
                                                    Text(
                                                      state.dislikeCount
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // imdb
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 7),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              buildRating(double.parse(
                                                  state.movie.rating ?? '0.0')),
                                              Text(
                                                '${state.movie.rating ?? '0.0'}/10 IMDB',
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        // duration
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 7),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Davomiyligi',
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    color: Colors.white60,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                state.movie.duration.toString(),
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        // age
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 7),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Yosh chegarasi',
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    color: Colors.white60,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                state.movie.age.toString(),
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    color: (state.movie.age !=
                                                                null &&
                                                            state.movie.age!
                                                                .contains('18'))
                                                        ? Colors.red
                                                        : Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        // comment
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                    CommentPage.routeName,
                                                    arguments: {
                                                      "movie_name":
                                                          state.movie.name,
                                                      "content_id":
                                                          state.movie.id,
                                                      "is_comments": state
                                                          .movie.is_comments,
                                                    });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 7),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Izoh qoldirish',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          color: Colors.white60,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.comment,
                                                      color: Colors.white,
                                                      size: 20,
                                                    )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      shrinkWrap: true,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //watch and download
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, right: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                5,
                                              ),
                                              color: HexColor('#E82C2A'),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                                onTap: state.isUrlWatchLoading
                                                    ? null
                                                    : () {
                                                        proceedType = 'watch';
                                                        BlocProvider.of<
                                                                MovieDetailBloc>(
                                                            context)
                                                          ..add(
                                                              LoadMovieUrlEvent(
                                                                  'watch'));
                                                      },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                                  child: state.isUrlWatchLoading
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 24,
                                                              width: 24,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "Tomosha qilish"
                                                                  .toUpperCase(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
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
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                5,
                                              ),
                                              color: HexColor('#008A40'),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5,
                                                ),
                                                onTap:
                                                    state.isUrlDownloadLoading
                                                        ? null
                                                        : () {
                                                            proceedType =
                                                                'download';
                                                            BlocProvider.of<
                                                                    MovieDetailBloc>(
                                                                context)
                                                              ..add(LoadMovieUrlEvent(
                                                                  'download'));
                                                          },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 15,
                                                  ),
                                                  child: state
                                                          .isUrlDownloadLoading
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              height: 18,
                                                              width: 18,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Center(
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icons/watch/ic_download.svg',
                                                            height: 18,
                                                            width: 18,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // genre
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: Text(
                                      'Janri:',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 28,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: state.movie.genres.length,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        width: 5,
                                      ),
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            if (index == 0)
                                              SizedBox(
                                                width: 5,
                                              ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(
                                                    0.3,
                                                  ))),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Center(
                                                      child: Text(
                                                        state.movie
                                                            .genres[index].name,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            GenreDetailPage
                                                                .routeName,
                                                            arguments: {
                                                          'genreId': state.movie
                                                              .genres[index].id,
                                                          'genreName': state
                                                              .movie
                                                              .genres[index]
                                                              .name,
                                                        });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),

                                  //about
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: Text(
                                      'Film haqida qisqacha:',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: Text(
                                      state.movie.description ?? '',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: HexColor('#BCBCBC'),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),

                                  //actors and directors
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Rejissyor:',
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            buildActor(
                                                state.movie.director[0], () {}),
                                          ],
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Text(
                                                  'Rollarda:',
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  height: 79,
                                                  child: ListView.separated(
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            SizedBox(
                                                      width: 2,
                                                    ),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: state
                                                        .movie.actors.length,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            buildActor(
                                                      state.movie.actors[index],
                                                      () {
                                                        //go to actor page
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //screenshots
                                  if (state.movie.screenshots != null)
                                    SizedBox(
                                      height: 5,
                                    ),
                                  if (state.movie.screenshots != null)
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: Text(
                                        "Skrinshotlar:",
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (state.movie.screenshots != null)
                                    SizedBox(
                                      height: 5,
                                    ),
                                  if (state.movie.screenshots != null)
                                    SizedBox(
                                      height: 100,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          width: 5,
                                        ),
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              if (index == 0)
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          ScreenShotPage
                                                              .routeName,
                                                          arguments: {
                                                        'screenshots': state
                                                            .movie.screenshots!,
                                                        'startIndex': index,
                                                      });
                                                },
                                                child: Hero(
                                                  child: ClipRRect(
                                                    child: CustomImageLoader(
                                                      width: 180,
                                                      height: 100,
                                                      borderRadius: 0,
                                                      imageUrl: state
                                                          .movie
                                                          .screenshots![index]
                                                          .image,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  tag: state.movie
                                                      .screenshots![index].id,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        itemCount:
                                            state.movie.screenshots!.length,
                                      ),
                                    ),

                                  //related movies
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: Text(
                                      "Boshqa filmlar:",
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        width: 5,
                                      ),
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            if (index == 0)
                                              SizedBox(
                                                width: 5,
                                                height: 0,
                                              ),
                                            MovieRelatedItem(
                                              state.relatedMovies[index],
                                            ),
                                          ],
                                        );
                                      },
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.relatedMovies.length,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        );
      }),
    );
  }
}

Widget buildRating(double rating) {
  int remainingInt = 5;
  if (rating > 0 && rating <= 2) {
    remainingInt = 1;
  } else if (rating > 2 && rating <= 4) {
    remainingInt = 2;
  } else if (rating > 4 && rating <= 6) {
    remainingInt = 3;
  } else if (rating > 6 && rating <= 7.9) {
    remainingInt = 4;
  } else {
    remainingInt = 5;
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (int i = 0; i < remainingInt; i++) ...[
        Icon(
          Icons.star,
          color: HexColor('#F2C94C'),
          size: 20,
        )
      ],
      for (int i = 0; i < 5 - remainingInt; i++) ...[
        Icon(
          Icons.star_border,
          color: HexColor('#F2C94C'),
          size: 20,
        )
      ],
    ],
  );
}

class FadingEffect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect =
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height + 25));
    LinearGradient lg = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black,
      ],
    );
    Paint paint = Paint()..shader = lg.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FadingEffect linePainter) => false;
}
