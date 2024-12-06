import 'package:blur/blur.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_events.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/helpers/constants.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/movie_detail_page.dart';
import 'package:yangi_tv_new/ui/views/story/story_watch_page.dart';
import 'package:yangi_tv_new/ui/widgets/genre_item.dart';
import 'package:yangi_tv_new/ui/widgets/loading/movie_item_loading.dart';
import 'package:yangi_tv_new/ui/widgets/main_category_item.dart';
import 'package:yangi_tv_new/ui/widgets/story_item.dart';

import '../../../bloc/repos/mainrepository.dart';
import '../../../helpers/color_changer.dart';
import '../../../helpers/custom_image_loader.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  bool isAutoSlideOn = true;
  int activeBannerIndex = 0;
  final successController = ScrollController();
  final loadingController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MainBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetMainEvent()),
      child: BlocConsumer<MainBloc, MainState>(listener: (context, state) {
        if (state is MainErrorState) {
          openTryAgainDialog(() {
            BlocProvider.of<MainBloc>(context)..add(GetMainEvent());
          });
        }

        if (state is MainLoadingState) {
          setState(() {
            activeBannerIndex = 0;
          });
        }
      }, builder: (context, state) {
        return RefreshIndicator(
          color: Colors.black,
          onRefresh: () async {
            if (successController.hasClients) successController.jumpTo(0);
            if (loadingController.hasClients) loadingController.jumpTo(0);
            BlocProvider.of<MainBloc>(context)..add(GetMainEvent());
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            extendBody: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(42),
              child: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Container(
                  height: 35.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/yangi_tv.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(
              builder: (_) {
                if (state is MainLoadingState)
                  return SingleChildScrollView(
                    controller: loadingController,
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 65,
                          padding: EdgeInsets.only(left: 5),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(
                                65 / 2,
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
                                child: Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            itemCount: 10,
                          ),
                        ),
                        SizedBox(
                          height: 27,
                        ),
                        Shimmer.fromColors(
                          baseColor: Constants.defaultShimmerBaseColor,
                          highlightColor:
                              Constants.defaultShimmerHighlightColor,
                          child: Container(
                            width: double.infinity,
                            height: 245,
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Shimmer.fromColors(
                            enabled: true,
                            baseColor: Constants.defaultShimmerBaseColor,
                            highlightColor:
                                Constants.defaultShimmerHighlightColor,
                            child: Container(
                              width: 100,
                              height: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 120,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(right: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Constants.defaultShimmerBaseColor,
                                  highlightColor:
                                      Constants.defaultShimmerHighlightColor,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            itemCount: 10,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor:
                                          Constants.defaultShimmerBaseColor,
                                      highlightColor: Constants
                                          .defaultShimmerHighlightColor,
                                      child: Container(
                                        width: 100,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
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
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 220,
                                  child: ListView.separated(
                                    itemBuilder: (context, index) =>
                                        MovieItemLoading(),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      width: 10,
                                    ),
                                    itemCount: 10,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                )
                              ],
                            );
                          },
                          itemCount: 10,
                        )
                      ],
                    ),
                  );

                if (state is MainSuccessState)
                  return SingleChildScrollView(
                    controller: successController,
                    physics: state.stories.isEmpty
                        ? AlwaysScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        if (state.stories.isNotEmpty)
                          Container(
                            height: 100,
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) => SizedBox(
                                width: 9,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      EdgeInsets.only(left: index == 0 ? 5 : 0),
                                  child: StoryItem(state.stories[index], () {
                                    Navigator.of(context).pushNamed(
                                        StoryWatchPage.routeName,
                                        arguments: {
                                          'mainBloc': BlocProvider.of<MainBloc>(
                                              context),
                                          'index': index,
                                        });
                                  }),
                                );
                              },
                              itemCount: state.stories.length,
                            ),
                          ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          height: 245,
                          width: double.infinity,
                          child: CarouselSlider.builder(
                              unlimitedMode: true,
                              onSlideChanged: (value) {
                                setState(() {
                                  activeBannerIndex =
                                      value % state.banners.length;
                                });
                              },
                              enableAutoSlider: isAutoSlideOn,
                              onSlideEnd: () {
                                setState(() {
                                  isAutoSlideOn = true;
                                });
                              },
                              onSlideStart: () {
                                setState(() {
                                  isAutoSlideOn = false;
                                });
                              },
                              autoSliderDelay: Duration(
                                seconds: 8,
                              ),
                              slideBuilder: (index) {
                                return InkWell(
                                  splashFactory: NoSplash.splashFactory,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    if (state.banners[index].contentId != null)
                                      Navigator.of(context).pushNamed(
                                        MovieDetailPage.routeName,
                                        arguments: {
                                          'content_id':
                                              state.banners[index].contentId,
                                          'movie_name':
                                              state.banners[index].name,
                                        },
                                      );

                                    if (state.banners[index].url != null) {
                                      await launchUrl(
                                          Uri.parse(state.banners[index].url!));
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      CustomImageLoader(
                                        imageUrl: state.banners[index].image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 250,
                                        borderRadius: 0,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 30,
                                            ).blurred(
                                              blur: 5,
                                              blurColor: Colors.black,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  state.banners[index].name,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                );
                              },
                              slideTransform: ParallaxTransform(),
                              itemCount: state.banners.length),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedSmoothIndicator(
                          activeIndex: activeBannerIndex,
                          count: state.banners.length,
                          effect: ScrollingDotsEffect(
                              activeDotColor: HexColor('#E82C2A'),
                              maxVisibleDots: 11,
                              activeDotScale: 1.3,
                              dotHeight: 10,
                              dotWidth: 10),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                "Janrlar",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Container(
                              width: 120,
                              height: 120,
                              child: GenreItem(state.genres[index]),
                            ),
                            itemCount: state.genres.length,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: PageScrollPhysics(),
                          itemBuilder: (context, index) =>
                              MainCategory(state.categories[index]),
                          itemCount: state.categories.length,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  );

                return Container();
              },
            ),
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FadingEffect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height));
    LinearGradient lg = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withOpacity(0.02),
        Colors.black,
      ],
    );
    Paint paint = Paint()..shader = lg.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FadingEffect linePainter) => false;
}
