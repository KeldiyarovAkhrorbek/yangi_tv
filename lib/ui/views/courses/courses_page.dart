import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/helpers/secure_storage.dart';
import 'package:yangi_tv_new/ui/widgets/movie_item.dart';

import '../../../bloc/blocs/app_blocs.dart';
import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';
import '../../../helpers/color_changer.dart';
import '../../widgets/loading/movie_item_loading.dart';

class CoursesPage extends StatefulWidget {
  static const routeName = '/courses-page';

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
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
                            "Could not load data.\nPlease try again.",
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
                                      'Try again',
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
      CategoryDetailBloc(RepositoryProvider.of<MainRepository>(context))
        ..add(GetCategoryDetailEvent(category_id: 11)),
      child: BlocConsumer<CategoryDetailBloc, CategoryDetailState>(
        listener: (context, state) {
          if (state is CategoryDetailErrorState) {
            openTryAgainDialog(
                  () {
                BlocProvider.of<CategoryDetailBloc>(context)
                  ..add(GetCategoryDetailEvent(category_id: 11));
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            extendBody: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(42),
              child: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                title: Container(
                  height: 35.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/yangi_tv.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(
              builder: (_) {
                scrollController.addListener(
                      () async {
                    if (state is CategoryDetailSuccessState &&
                        !state.isPaginating) {
                      if (scrollController.position.pixels ==
                          scrollController.position.maxScrollExtent) {
                        BlocProvider.of<CategoryDetailBloc>(context).add(
                          PaginateCategoryDetailEvent(),
                        );
                      }
                    }
                  },
                );

                if (state is CategoryDetailLoadingState)
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

                if (state is CategoryDetailSuccessState) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      controller: scrollController,
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
                            itemBuilder: (context, index) =>
                                MovieItem(state.movies[index]),
                            itemCount: state.movies.length,
                          ),
                          if (state.isPaginating)
                            SizedBox(
                              height: 10,
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
                        ],
                      ),
                    ),
                  );
                }

                if (state is CategoryDetailErrorState) {
                  return Text(
                    state.errorText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  );
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}