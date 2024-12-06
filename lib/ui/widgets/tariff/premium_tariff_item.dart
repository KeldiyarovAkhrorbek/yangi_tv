import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/models/tariff.dart';

class PremiumTariffItem extends StatefulWidget {
  final Tariff tariff;
  final int index;
  final List<String> movies;
  final VoidCallback buyPressed;
  bool isAnime;

  PremiumTariffItem({
    required this.tariff,
    required this.index,
    required this.buyPressed,
    required this.movies,
    this.isAnime = false,
  });

  @override
  State<PremiumTariffItem> createState() => _PremiumTariffItemState();
}

class _PremiumTariffItemState extends State<PremiumTariffItem> {
  final cs.CarouselSliderController _carouselController =
      cs.CarouselSliderController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carouselController.nextPage(duration: Duration(milliseconds: 2000));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      width: double.infinity,
      height: 320,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        cs.CarouselSlider(
                          carouselController: _carouselController,
                          options: cs.CarouselOptions(
                              height: 90,
                              disableCenter: true,
                              reverse: widget.index % 2 == 1,
                              viewportFraction: 0.19,
                              scrollPhysics: NeverScrollableScrollPhysics(),
                              onPageChanged: (_, __) {
                                _carouselController.nextPage(
                                    duration: Duration(milliseconds: 2000));
                              }),
                          items: widget.movies
                              .map(
                                (image) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: FancyShimmerImage(
                                      imageUrl:
                                          "https://rasmlar.yangi.tv/tarif/${image}.jpg",
                                      width: 70,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    widget.tariff.name,
                                    style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Center(
                                  child: Text(
                                    "Narxi: ${widget.tariff.cost} UZS",
                                    style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        color: HexColor('#FFE871'),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 55,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    widget.tariff.description,
                                    style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (!widget.isAnime)
                              SizedBox(
                                width: 10,
                              ),
                            if (!widget.isAnime)
                              Expanded(
                                flex: 45,
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#959595')
                                                        .withOpacity(
                                                      0.2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      SvgPicture.asset(
                                                          "assets/icons/tariff/ic_movie.svg"),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "10000+",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "kinolar",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#959595')
                                                        .withOpacity(
                                                      0.2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      SvgPicture.asset(
                                                          "assets/icons/tariff/ic_cartoon.svg"),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "1500+",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "multfilm",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 13,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#959595')
                                                        .withOpacity(
                                                      0.2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      SvgPicture.asset(
                                                          "assets/icons/tariff/ic_retro.svg"),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "2000+",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "retro",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#959595')
                                                        .withOpacity(
                                                      0.2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      SvgPicture.asset(
                                                          "assets/icons/tariff/ic_serial.svg"),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "1000+",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "seriallar",
                                                            style: GoogleFonts
                                                                .ubuntu(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 0,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: RawMaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                fillColor: Colors.white,
                onPressed: () {
                  widget.buyPressed();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Sotib olish',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
