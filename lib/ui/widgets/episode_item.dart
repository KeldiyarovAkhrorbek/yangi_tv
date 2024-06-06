import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/models/season.dart';

class EpisodeItem extends StatelessWidget {
  Episode episode;
  String image;
  final VoidCallback pressed;

  EpisodeItem(this.episode, this.image, this.pressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pressed();
      },
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                child: FancyShimmerImage(
                  imageUrl: image,
                  width: double.infinity,
                  height: 120,
                  boxFit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                episode.name.toString(),
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
