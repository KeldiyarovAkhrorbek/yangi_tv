import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';

import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';
import '../../../helpers/color_changer.dart';
import '../../widgets/loading/movie_item_loading.dart';
import '../../widgets/movie_item.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  void openTryAgainDialog(VoidCallback tryAgainPressed) {
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
                            'assets/icons/auth/ic_dangerous.svg',
                            height: 50,
                            width: 50,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Ma'lumotni yuklab bo'lmadi,\niltimos, qayta urining.",
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
                                    tryAgainPressed();
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Qayta urinish',
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FavoritesBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetFavoritesEvent()),
      child: BlocConsumer<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
        if (state is FavoritesErrorState) {
          openTryAgainDialog(() {
            BlocProvider.of<FavoritesBloc>(context)..add(GetFavoritesEvent());
          });
        }
      }, builder: (context, state) {
        return RefreshIndicator(
          color: Colors.black,
          onRefresh: () async {
            BlocProvider.of<FavoritesBloc>(context)..add(GetFavoritesEvent());
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Text(
                  "Saqlanganlar",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(
              builder: (_) {
                return Builder(
                  builder: (_) {
                    scrollController.addListener(
                      () async {
                        if (state is FavoritesSuccessState &&
                            !state.isPaginating) {
                          if (scrollController.position.pixels ==
                              scrollController.position.maxScrollExtent) {
                            BlocProvider.of<FavoritesBloc>(context).add(
                              PaginateFavoritesEvent(),
                            );
                          }
                        }
                      },
                    );
                    if (state is FavoritesLoadingState)
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 200,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) => MovieItemLoading(),
                        itemCount: 15,
                      );

                    if (state is FavoritesSuccessState) {
                      if (state.movies.isEmpty)
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/favorites/ic_empty_favorites.svg',
                                height: 80,
                                width: 80,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Sizda hali saqlanganlar\nmavjud emas!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              GridView.builder(
                                physics: PageScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisExtent: 200,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) => MovieItem(
                                  state.movies[index],
                                  true,
                                  false,
                                ),
                                itemCount: state.movies.length,
                              ),
                              if (state.isPaginating)
                                SizedBox(
                                  height: 20,
                                ),
                              if (state.isPaginating)
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              if (state.isPaginating)
                                SizedBox(
                                  height: 10,
                                ),
                              SizedBox(
                                height: 120,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
