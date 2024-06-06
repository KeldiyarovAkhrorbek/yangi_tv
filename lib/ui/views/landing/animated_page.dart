import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class AnimatedPage extends StatefulWidget {
  String title;
  String subtitle;

  AnimatedPage({required this.title, required this.subtitle});

  @override
  State<AnimatedPage> createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage> {
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();

  animateToMaxMin(double max, double min, double direction, int seconds,
      ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController
          .animateTo(direction,
              duration: Duration(seconds: seconds), curve: Curves.linear)
          .then((value) {
        direction = direction == max ? min : max;
        animateToMaxMin(max, min, direction, seconds, scrollController);
      });
    }
  }

  List<String> images = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
  ];
  List<String> images1 = [];
  List<String> images2 = [];
  List<String> images3 = [];

  @override
  void initState() {
    super.initState();
    images.shuffle();
    for (int i = 0; i <= 9; i++) {
      images1.add(images[i]);
    }
    for (int i = 10; i <= 19; i++) {
      images2.add(images[i]);
    }
    for (int i = 20; i <= 29; i++) {
      images3.add(images[i]);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double minScrollExtent1 = _scrollController1.position.minScrollExtent;
      double maxScrollExtent1 = _scrollController1.position.maxScrollExtent;
      double minScrollExtent2 = _scrollController2.position.minScrollExtent;
      double maxScrollExtent2 = _scrollController2.position.maxScrollExtent;
      double minScrollExtent3 = _scrollController3.position.minScrollExtent;
      double maxScrollExtent3 = _scrollController3.position.maxScrollExtent;

      animateToMaxMin(maxScrollExtent1, minScrollExtent1, maxScrollExtent1, 30,
          _scrollController1);
      animateToMaxMin(maxScrollExtent2, minScrollExtent2, maxScrollExtent2, 30,
          _scrollController2);
      animateToMaxMin(maxScrollExtent3, minScrollExtent3, maxScrollExtent3, 30,
          _scrollController3);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController1.dispose();
    _scrollController2.dispose();
    _scrollController3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ListView.separated(
                    controller: _scrollController1,
                    itemBuilder: (context, index) => Image.asset(
                          'assets/images/landing/images/${images1[index]}.jpg',
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                    itemCount: images1.length),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: ListView.separated(
                    reverse: true,
                    controller: _scrollController2,
                    itemBuilder: (context, index) => Image.asset(
                          'assets/images/landing/images/${images2[index]}.jpg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                    itemCount: images2.length),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: ListView.separated(
                    controller: _scrollController3,
                    itemBuilder: (context, index) => Image.asset(
                          'assets/images/landing/images/${images3[index]}.jpg',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                    itemCount: images3.length),
              ),
            ],
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
          Blur(
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
            blurColor: Colors.black,
            blur: 3,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 300,
                  width: 300,
                ),
                SizedBox(
                  height: 300,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
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
                  widget.subtitle,
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
