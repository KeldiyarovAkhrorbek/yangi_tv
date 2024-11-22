import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/custom_image_loader.dart';
import 'package:yangi_tv_new/models/Movie_Short.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/movie_detail_page.dart';

import '../../helpers/color_changer.dart';

class MovieItem extends StatelessWidget {
  final MovieShort movie;
  bool isFavorite;
  bool isHero;

  MovieItem(this.movie, [this.isFavorite = false, this.isHero = true]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MovieDetailPage.routeName, arguments: {
          'imageUrl': movie.poster,
          'content_id': movie.id,
          'movie_name': movie.name,
        });
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  child: HeroMode(
                    enabled: isHero,
                    child: Hero(
                      tag: movie.poster + "${movie.id}" + "main",
                      transitionOnUserGestures: true,
                      child: CustomImageLoader(
                        imageUrl: movie.poster,
                        width: 128,
                        height: 190,
                        fit: BoxFit.cover,
                        borderRadius: 0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4.0,
                  right: 4.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(
                        0.6,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        child: Center(
                          child: Text(
                            movie.tariff,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: movie.tariff == 'PREMIUM'
                                    ? HexColor('#FFD914')
                                    : Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isFavorite)
                  Positioned(
                    top: 4.0,
                    left: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.favorite,
                              color: HexColor('#FF2D00'),
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          movie.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
