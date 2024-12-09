import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/defaults.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImageLoader extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;

  CustomImageLoader(
      {required this.imageUrl,
      required this.width,
      required this.height,
      required this.fit,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: Duration.zero,
      imageUrl: imageUrl,
      width: width,
      height: height,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: defaultShimmerBaseColor,
        highlightColor: defaultShimmerHighlightColor,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
