import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/first_time_tracker.dart';
import 'package:yangi_tv_new/ui/views/main/collection_page.dart';
import 'package:yangi_tv_new/ui/views/main/favorites_page.dart';
import 'package:yangi_tv_new/ui/views/main/main_page.dart';
import 'package:yangi_tv_new/ui/views/main/profile_page.dart';

import '../../../helpers/color_changer.dart';
import '../main/search_page.dart';

class NavigationPage extends StatefulWidget {
  static const routeName = '/navigation-page';

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  PageController? _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController?.jumpToPage(_selectedIndex);
    });
  }

  void openLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Stack(
                  children: [
                    Blur(
                      blur: 7,
                      blurColor: HexColor('#4D4D4D').withOpacity(1),
                      child: Container(
                        width: double.infinity,
                        child: SizedBox(
                          height: 220,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SvgPicture.asset(
                              'assets/icons/profile/ic_logout.svg'),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Siz rostdan ham\nchiqishni xohlaysizmi?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      "Yo'q",
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: HexColor('#FF4747'),
                                  onPressed: () {
                                    SystemChannels.platform
                                        .invokeMethod('SystemNavigator.pop');
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Ha',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  void openFirstTimeDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Stack(
                  children: [
                    Blur(
                      blur: 15,
                      blurColor: HexColor('#4D4D4D'),
                      child: Container(
                        width: double.infinity,
                        child: SizedBox(
                          height: 270,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          SvgPicture.asset(
                            'assets/icons/tariff/ic_tariff_bought.svg',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Tabriklaymiz! Sizga film va seriallarni ko'rish uchun 2 kunlik bonus taqdim qilindi!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: HexColor('#FF4747'),
                                  onPressed: () {
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Rahmat!',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  void callDialog() async {
    await Future.delayed(Duration(milliseconds: 1500));
    if (FirstTimeTracker.instance.isFirstTime) openFirstTimeDialog();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    callDialog();
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      MainPage(),
      SearchPage(),
      CollectionPage(),
      FavoritesPage(),
      ProfilePage(),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          if (_selectedIndex != 0) {
            onTap(0);
            return false;
          }
          openLogoutDialog();
          return false;
        },
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                  ).blurred(
                    blur: 7,
                    blurColor: Colors.black,
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                onTap: () {
                                  onTap(0);
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _selectedIndex == 0
                                        ? SvgPicture.asset(
                                            'assets/icons/navigation/ic_home_s.svg',
                                            height: 28,
                                            width: 28,
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/navigation/ic_home_us.svg',
                                            height: 28,
                                            width: 28,
                                            color:
                                                Colors.white.withOpacity(0.25),
                                          ),
                                    Text(
                                      'Asosiy',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 65,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  onTap(1);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _selectedIndex == 1
                                        ? SvgPicture.asset(
                                            'assets/icons/navigation/ic_search_s.svg',
                                            height: 28,
                                            width: 28,
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/navigation/ic_search_us.svg',
                                            height: 28,
                                            width: 28,
                                            color:
                                                Colors.white.withOpacity(0.25),
                                          ),
                                    Text(
                                      'Qidiruv',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 65,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  onTap(2);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _selectedIndex == 2
                                        ? SvgPicture.asset(
                                            'assets/icons/navigation/ic_category_s.svg',
                                            height: 28,
                                            width: 28,
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/navigation/ic_category_us.svg',
                                            height: 28,
                                            width: 28,
                                            color:
                                                Colors.white.withOpacity(0.25),
                                          ),
                                    Text(
                                      'Kolleksiya',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 65,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  onTap(3);
                                },
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _selectedIndex == 3
                                          ? SvgPicture.asset(
                                              'assets/icons/navigation/ic_liked_s.svg',
                                              height: 28,
                                              width: 28,
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/navigation/ic_liked_us.svg',
                                              height: 28,
                                              width: 28,
                                              color: Colors.white
                                                  .withOpacity(0.25),
                                            ),
                                      Text(
                                        'Sevimli',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                onTap: () {
                                  onTap(4);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _selectedIndex == 4
                                        ? SvgPicture.asset(
                                            'assets/icons/navigation/ic_profile_s.svg',
                                            height: 28,
                                            width: 28,
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/navigation/ic_profile_us.svg',
                                            height: 28,
                                            width: 28,
                                            color:
                                                Colors.white.withOpacity(0.25),
                                          ),
                                    Text(
                                      'Profil',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
