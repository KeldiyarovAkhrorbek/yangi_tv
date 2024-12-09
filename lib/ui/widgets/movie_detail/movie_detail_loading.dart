import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yangi_tv_new/helpers/constants.dart';
import 'package:yangi_tv_new/helpers/custom_image_loader.dart';
import 'package:yangi_tv_new/ui/widgets/loading/movie_item_loading.dart';
import 'package:yangi_tv_new/ui/widgets/movie_detail/fading_effect.dart';

class MovieDetailLoadingWidget extends StatelessWidget {
  String imageUrl;
  String? type;
  int content_id;

  MovieDetailLoadingWidget({
    required this.imageUrl,
    required this.type,
    required this.content_id,
  });

  @override
  Widget build(BuildContext context) {
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
                  highlightColor: Constants.defaultShimmerHighlightColor,
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                              baseColor: Constants.defaultShimmerBaseColor,
                              highlightColor:
                                  Constants.defaultShimmerHighlightColor,
                              child: Container(
                                width: 150,
                                height: 220,
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
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
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
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
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
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
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
                                    baseColor:
                                        Constants.defaultShimmerBaseColor,
                                    highlightColor:
                                        Constants.defaultShimmerHighlightColor,
                                    child: Container(
                                      width: 50,
                                      height: 10,
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
                                      width: 50,
                                      height: 10,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
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
                                    baseColor:
                                        Constants.defaultShimmerBaseColor,
                                    highlightColor:
                                        Constants.defaultShimmerHighlightColor,
                                    child: Container(
                                      width: 50,
                                      height: 10,
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
                                      width: 50,
                                      height: 10,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
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
                                    baseColor:
                                        Constants.defaultShimmerBaseColor,
                                    highlightColor:
                                        Constants.defaultShimmerHighlightColor,
                                    child: Container(
                                      width: 50,
                                      height: 10,
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
                                      width: 50,
                                      height: 10,
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
                              Shimmer.fromColors(
                                baseColor: Constants.defaultShimmerBaseColor,
                                highlightColor:
                                    Constants.defaultShimmerHighlightColor,
                                child: Container(
                                  width: double.infinity,
                                  height: 35,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
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
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 70,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 70,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 70,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 70,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 70,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 70,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 70,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                          baseColor: Constants.defaultShimmerBaseColor,
                          highlightColor:
                              Constants.defaultShimmerHighlightColor,
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
                          baseColor: Constants.defaultShimmerBaseColor,
                          highlightColor:
                              Constants.defaultShimmerHighlightColor,
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
                  highlightColor: Constants.defaultShimmerHighlightColor,
                  child: Container(
                    width: 100,
                    height: 20,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 100,
                          height: 30,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 100,
                          height: 30,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 100,
                          height: 30,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 100,
                          height: 30,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                  highlightColor: Constants.defaultShimmerHighlightColor,
                  child: Container(
                    width: 150,
                    height: 20,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                  highlightColor: Constants.defaultShimmerHighlightColor,
                  child: Container(
                    width: double.infinity,
                    height: 20,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Constants.defaultShimmerBaseColor,
                  highlightColor: Constants.defaultShimmerHighlightColor,
                  child: Container(
                    width: 300,
                    height: 20,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                      baseColor: Constants.defaultShimmerBaseColor,
                      highlightColor: Constants.defaultShimmerHighlightColor,
                      child: Container(
                        width: 60,
                        height: 20,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Shimmer.fromColors(
                      baseColor: Constants.defaultShimmerBaseColor,
                      highlightColor: Constants.defaultShimmerHighlightColor,
                      child: Container(
                        width: 60,
                        height: 20,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
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
                  highlightColor: Constants.defaultShimmerHighlightColor,
                  child: Container(
                    width: 100,
                    height: 20,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10,
                    ),
                    itemBuilder: (context, index) => MovieItemLoading(),
                    itemCount: 5,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
