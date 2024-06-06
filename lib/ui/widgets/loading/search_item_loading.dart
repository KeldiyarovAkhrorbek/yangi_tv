import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yangi_tv_new/helpers/constants.dart';
import 'package:yangi_tv_new/helpers/custom_image_loader.dart';
import '../../../helpers/color_changer.dart';

class SearchItemLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            10,
          ),
          child: Shimmer.fromColors(
            baseColor: Constants.defaultShimmerBaseColor,
            highlightColor: Constants.defaultShimmerHighlightColor,
            child: Container(
              width: 130,
              height: 170,
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
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: SizedBox(
              height: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Constants.defaultShimmerBaseColor,
                    highlightColor: Constants.defaultShimmerHighlightColor,
                    child: Container(
                      width: 200,
                      height: 20,

                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 50,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 40,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Constants.defaultShimmerBaseColor,
                            highlightColor: Constants.defaultShimmerHighlightColor,
                            child: Container(
                              width: 80,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.black,
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
                              width: 30,
                              height: 20,
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
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 270,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor: Constants.defaultShimmerBaseColor,
                        highlightColor: Constants.defaultShimmerHighlightColor,
                        child: Container(
                          width: 200,
                          height: 35,
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
