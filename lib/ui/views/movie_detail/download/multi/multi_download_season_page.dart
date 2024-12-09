import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/download/multi/multi_download_episodes_page.dart';

import '../../../../../models/season.dart';

class MultiDownloadSeasonPage extends StatefulWidget {
  static const routeName = '/multi-download-season';

  @override
  State<MultiDownloadSeasonPage> createState() =>
      _MultiDownloadSeasonPageState();
}

class _MultiDownloadSeasonPageState extends State<MultiDownloadSeasonPage> {
  String movie_name = '';
  String image = '';
  String tariff = '';
  List<Season> seasons = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    movie_name = args['name'];
    image = args['image'];
    tariff = args['tariff'];
    seasons = args['seasons'];
  }

  final ScrollController scrollController = ScrollController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels > 50) {
        show = true;
      } else
        show = false;
      setState(() {});
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            automaticallyImplyLeading: false,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            centerTitle: true,
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
            flexibleSpace: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: double.infinity,
              height: double.infinity,
              color: show ? Colors.black : Colors.transparent,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text(
              movie_name,
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        body: BlocConsumer<DownloadBloc, DownloadState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Builder(
              builder: (_) {
                if (state is DownloadState)
                  return Stack(
                    children: [
                      Image.asset(
                        'assets/images/profile_background.png',
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(
                                0.8,
                              ),
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            Text(
                              "Yuklab olish uchun faslni tanlang:",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: PageScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 120,
                              ),
                              itemBuilder: (context, index) {
                                return seasonItem(seasons[index]);
                              },
                              itemCount: seasons.length,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                return Container();
              },
            );
          },
        ),
      ),
    );
  }

  Widget seasonItem(Season season) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white,
              width: 1,
            )),
        width: double.infinity,
        height: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(MultiDownloadEpisodesPage.routeName, arguments: {
                "name": movie_name,
                "image": image,
                "season": season.name,
                "episodes": season.episodes,
                "tariff": tariff,
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.all(
                5,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FancyShimmerImage(
                        imageUrl: image,
                        width: double.infinity,
                        height: double.infinity,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 60,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Text(
                            season.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
