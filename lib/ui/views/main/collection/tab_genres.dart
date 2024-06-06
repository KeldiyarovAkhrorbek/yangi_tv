import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/widgets/genre_item.dart';
import 'package:yangi_tv_new/ui/widgets/loading/genre_item_loading.dart';

import '../../../../bloc/blocs/app_events.dart';
import '../../../../bloc/repos/mainrepository.dart';
import '../../../../helpers/color_changer.dart';

class TabGenres extends StatefulWidget {
  @override
  State<TabGenres> createState() => _TabGenresState();
}

class _TabGenresState extends State<TabGenres> {
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
          GenreBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetGenresEvent()),
      child: BlocConsumer<GenreBloc, GenreState>(listener: (context, state) {
        if (state is GenreErrorState)
          openTryAgainDialog(() {
            BlocProvider.of<GenreBloc>(context)..add(GetGenresEvent());
          });
      }, builder: (context, state) {
        return RefreshIndicator(
          color: Colors.black,
          onRefresh: () async {
            BlocProvider.of<GenreBloc>(context)..add(GetGenresEvent());
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Builder(
              builder: (_) {
                if (state is GenreLoadingState)
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) => GenreItemLoading(),
                    itemCount: 30,
                  );

                if (state is GenreSuccessState) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        GridView.builder(
                          physics: PageScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) =>
                              GenreItem(state.genres[index]),
                          itemCount: state.genres.length,
                        ),
                        SizedBox(
                          height: 140,
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        );
      }),
    );
  }
}
