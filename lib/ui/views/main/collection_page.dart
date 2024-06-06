import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/ui/views/main/collection/tab_collection.dart';
import 'package:yangi_tv_new/ui/views/main/collection/tab_genres.dart';

import '../../../helpers/color_changer.dart';

class CollectionPage extends StatefulWidget {
  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage>
    with TickerProviderStateMixin {
  TabController? tabController;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController?.addListener(() {
      setState(() {
        activeIndex = tabController?.index ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            unselectedLabelColor: Colors.white.withOpacity(
              0.6,
            ),
            labelColor: Colors.white,
            isScrollable: false,
            dividerColor: Colors.transparent,
            controller: tabController,
            indicator: null,
            indicatorColor: Colors.transparent,
            tabs: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: activeIndex == 0
                      ? HexColor('#1E1E34')
                      : HexColor('#707070').withOpacity(0.25),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Kolleksiya",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: activeIndex == 0
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    color: activeIndex == 1
                        ? HexColor('#1E1E34')
                        : HexColor('#707070').withOpacity(0.25),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Janrlar",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: activeIndex == 1
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          TabCollection(),
          TabGenres(),
        ],
      ),
    );
  }
}
