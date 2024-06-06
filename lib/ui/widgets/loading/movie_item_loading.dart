import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yangi_tv_new/helpers/constants.dart';

class MovieItemLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Shimmer.fromColors(
            baseColor: Constants.defaultShimmerBaseColor,
            highlightColor: Constants.defaultShimmerHighlightColor,
            child: Container(
              width: 128,
              height: 190,
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
    );
  }
}
