import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/ui/views/auth/phone_number_page.dart';
import 'package:yangi_tv_new/ui/views/landing/animated_page.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing-page';

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var pages = [
      AnimatedPage(
        title: "BARCHASI\nO'ZBEK\nTILIDA",
        subtitle: "BARCHASI FAQAT BIZDA!",
      ),
      pageBuild(
        'assets/images/landing/landing_2.jpg',
        "ENG SO'NGGI\nPREMYERALAR",
        "FAQAT BIZDA TOMOSHA QILING!",
      ),
      pageBuild(
        'assets/images/landing/landing_3.jpg',
        "HAMMASI\nFAQAT SIZ\nUCHUN",
        "HOZIROQ SINAB KO'RING",
      ),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CarouselSlider.builder(
              keepPage: true,
              unlimitedMode: false,
              enableAutoSlider: false,
              slideBuilder: (index) {
                return pages[index];
              },
              slideTransform: ParallaxTransform(),
              itemCount: pages.length,
              onSlideChanged: (value) {
                setState(() {
                  currentPage = value % 10;
                });
              },
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedSmoothIndicator(
                    activeIndex: currentPage,
                    count: 3,
                    effect: WormEffect(activeDotColor: HexColor('#E82C2A')),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: HexColor('#E50914'),
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              PhoneNumberPage.routeName, (route) => false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'DAVOM ETISH',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pageBuild(
    String image,
    String title,
    String subtitle,
  ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          Image.asset(
            width: double.infinity,
            height: double.infinity,
            image,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(
              0.4,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
              angle: -math.pi,
              child: Container(
                width: double.infinity,
                height: 340,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 0,
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
