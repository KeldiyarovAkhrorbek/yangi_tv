import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helpers/custom_image_loader.dart';
import '../../../models/movie_full.dart';

class ScreenShotPage extends StatefulWidget {
  static const routeName = '/screenshot-page';

  @override
  State<ScreenShotPage> createState() => _ScreenShotPageState();
}

class _ScreenShotPageState extends State<ScreenShotPage> {
  List<Screenshot> screenshots = [];
  int activePage = 0;
  int startIndex = 0;
  late PageController _pageController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    screenshots = args['screenshots'] as List<Screenshot>;
    startIndex = args['startIndex'] as int;
    activePage = startIndex;
    _pageController = PageController(initialPage: startIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${activePage + 1}/${screenshots.length}",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 400,
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: screenshots.length,
                    onPageChanged: (int page) {
                      setState(() {
                        activePage = page;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        height: 400,
                        child: Hero(
                          tag: screenshots[index].id,
                          child: CustomImageLoader(
                            height: 200,
                            width: double.infinity,
                            borderRadius: 0,
                            fit: BoxFit.contain,
                            imageUrl: screenshots[index].image,
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
