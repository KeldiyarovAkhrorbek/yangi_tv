import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';

import '../../../helpers/color_changer.dart';

class QualityEpisode extends StatelessWidget {
  MovieDetailLoadedState state;

  QualityEpisode(this.state);

  @override
  Widget build(BuildContext context) {
    if (state.movie.qualities.length <= 3)
      return Container(
        height: 220,
        width: 150,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Container(
                    height: 2,
                  ),
                  itemBuilder: (context, index) => Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          color: Colors.black.withOpacity(
                            0.54,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 3,
                            ),
                            child: Center(
                              child: Text(
                                getCorrectFormat(state.movie.qualities[index]),
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: HexColor('#FFD914'),
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
                  ),
                  itemCount: state.movie.qualities.length,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
              if (state.movie.type == 'multi')
                SizedBox(
                  height: 2,
                ),
              if (state.movie.type == 'multi')
                Row(
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            color: Colors.black.withOpacity(
                              0.54,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 3,
                              ),
                              child: Center(
                                child: Text(
                                  state.movie.episodes,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white,
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
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    return Container(
      height: 220,
      width: 150,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.movie.qualities.contains('360p'))
              Container(
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black.withOpacity(
                        0.54,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        child: Center(
                          child: Text(
                            '360p',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: HexColor('#FFD914'),
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
              ),
            if (state.movie.qualities.contains('360p'))
              SizedBox(
                height: 2,
              ),
            if (state.movie.qualities.contains('480p'))
              Container(
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black.withOpacity(
                        0.54,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        child: Center(
                          child: Text(
                            '480p',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: HexColor('#FFD914'),
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
              ),
            if (state.movie.qualities.contains('HD') ||
                state.movie.qualities.contains('FHD') ||
                state.movie.qualities.contains('4k'))
              SizedBox(
                height: 2,
              ),
            if (state.movie.qualities.contains('HD') ||
                state.movie.qualities.contains('FHD') ||
                state.movie.qualities.contains('4k'))
              Container(
                width: 250,
                height: 19,
                child: Row(
                  children: [
                    if (state.movie.qualities.contains('HD'))
                      Container(
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(
                                0.54,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                child: Center(
                                  child: Text(
                                    '720p',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: HexColor('#FFD914'),
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
                      ),
                    if (state.movie.qualities.contains('HD'))
                      SizedBox(
                        width: 2,
                      ),
                    if (state.movie.qualities.contains('FHD'))
                      Container(
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(
                                0.54,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: Center(
                                  child: Text(
                                    '1080p',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: HexColor('#FFD914'),
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
                      ),
                    SizedBox(
                      width: 2,
                    ),
                    if (state.movie.qualities.contains('4K'))
                      Container(
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.black.withOpacity(
                                0.54,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                child: Center(
                                  child: Text(
                                    '4K',
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: HexColor('#FFD914'),
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
                      ),
                  ],
                ),
              ),
            if (state.movie.type == 'multi')
              SizedBox(height: 2,),
            if (state.movie.type == 'multi')
              Row(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          color: Colors.black.withOpacity(
                            0.54,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 3,
                            ),
                            child: Center(
                              child: Text(
                                state.movie.episodes,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.white,
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
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String getCorrectFormat(String format) {
    if (format == 'HD') {
      return '720p';
    }
    if (format == 'FHD') {
      return '1080p';
    }

    return format;
  }
}
