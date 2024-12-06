import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/injection_container.dart';
import 'package:yangi_tv_new/ui/views/profile/downloads/multi/downloaded_seasons_page.dart';
import 'package:yangi_tv_new/ui/views/profile/downloads/single/downloaded_qualities_page.dart';

import '../../../../models/db/database_movie.dart';

class DownloadsPage extends StatefulWidget {
  static const routeName = '/downloads-page';

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<DatabaseMovie> movies = [];

  @override
  void initState() {
    super.initState();
    var all_tasks = getIt<DownloadBloc>().all_tasks;
    all_tasks.forEach((task) {
      if (!movies.contains(DatabaseMovie(
          name: task.movieName, image: task.image, is_multi: task.is_multi))) {
        movies.add(DatabaseMovie(
            name: task.movieName, image: task.image, is_multi: task.is_multi));
      }
    });
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
      child: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          var all_tasks = getIt<DownloadBloc>().all_tasks;
          movies = [];
          all_tasks.forEach((task) {
            if (!movies.contains(DatabaseMovie(
                name: task.movieName,
                image: task.image,
                is_multi: task.is_multi))) {
              movies.add(DatabaseMovie(
                  name: task.movieName,
                  image: task.image,
                  is_multi: task.is_multi));
            }
          });
          setState(() {});
        },
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
              iconTheme: IconThemeData(
                color: Colors.white,
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
              flexibleSpace: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: double.infinity,
                height: double.infinity,
                color: show ? Colors.black : Colors.transparent,
              ),
              title: Text(
                "Yuklab olinganlar",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
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
              if (movies.isEmpty)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                          'assets/icons/download/ic_empty_download.svg'),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Sizda hali yuklab olingan\nfilmlar mavjud emas!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (movies.isNotEmpty)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: PageScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 5,
                            mainAxisExtent: 120,
                          ),
                          itemBuilder: (context, index) {
                            return movieItem(movies[index % movies.length]);
                          },
                          itemCount: movies.length,
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget movieItem(DatabaseMovie movie) {
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
              if (movie.is_multi) {
                Navigator.of(context)
                    .pushNamed(DownloadedSeasonsPage.routeName, arguments: {
                  "name": movie.name,
                  "image": movie.image,
                });
              } else {
                Navigator.of(context)
                    .pushNamed(DownloadedQualitiesPage.routeName, arguments: {
                  "name": movie.name,
                  "image": movie.image,
                });
              }
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
                        imageUrl: movie.image,
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
                          Expanded(
                            flex: 1,
                            child: Text(
                              movie.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
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
