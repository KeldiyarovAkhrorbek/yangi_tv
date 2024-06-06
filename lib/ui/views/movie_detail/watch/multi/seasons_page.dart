import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/decryptor.dart';
import 'package:yangi_tv_new/ui/widgets/episode_item.dart';

import '../../../../../models/season.dart';
import 'video_player_page_multi.dart';

class SeasonPage extends StatefulWidget {
  static const routeName = '/seasons-page';

  @override
  State<SeasonPage> createState() => _SeasonPageState();
}

class _SeasonPageState extends State<SeasonPage> with TickerProviderStateMixin {
  List<Season> seasons = [];
  int? profile_id;
  String name = '';
  String image = '';
  List<Tab> seasonTabs = [];
  late TabController tabController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    seasons = args['seasons'];
    name = args['name'];
    image = args['image'];
    profile_id = args['profile_id'];
    if (seasonTabs.isEmpty) {
      seasons.forEach(
        (season) {
          seasonTabs.add(
            Tab(
              text: season.name,
            ),
          );
        },
      );
      tabController = TabController(length: seasonTabs.length, vsync: this);
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            name,
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
          bottom: TabBar(
            overlayColor: MaterialStateProperty.all(Colors.grey),
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            dividerColor: Colors.transparent,
            controller: tabController,
            labelStyle: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            indicatorColor: Colors.white,
            unselectedLabelStyle: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.white.withOpacity(.6),
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            tabs: seasonTabs,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: TabBarView(
          controller: tabController,
          children: seasons.map(
            (season) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: 145,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return EpisodeItem(season.episodes[index], image, () {
                      if (season.episodes[index].file != null) {
                        Navigator.of(context).pushNamed(
                          VideoPlayerPageMulti.routeName,
                          arguments: {
                            'movie_name': name,
                            'videoUrl':
                                decryptArray(season.episodes[index].file!),
                            'image': image,
                            'episodeID': season.episodes[index].id,
                            'profile_id': profile_id,
                            'seasonAndEpisode':
                                "${season.name} ${season.episodes[index].name}",
                          },
                        );
                      }
                    });
                  },
                  itemCount: season.episodes.length,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
