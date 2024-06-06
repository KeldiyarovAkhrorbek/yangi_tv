import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/widgets/loading/search_item_loading.dart';
import 'package:yangi_tv_new/ui/widgets/search_item.dart';

import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';
import '../../../helpers/color_changer.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();
  Timer? timer;
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBloc(RepositoryProvider.of<MainRepository>(context)),
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text(
                "Qidiruv",
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
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 0,
                  ),
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: HexColor("#3B3B3B"),
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        onChanged: (text) {
                          if (timer != null) timer!.cancel();
                          timer = Timer(Duration(milliseconds: 500), () {
                            BlocProvider.of<SearchBloc>(context).add(
                              GetSearchEvent(search_text: text),
                            );
                          });
                        },
                        onSubmitted: (value) async {
                          focusNode.unfocus();
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          focusedBorder: null,
                          hintText: 'Masalan: Yovuzlik qarorgohi 7',
                          hintStyle: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.3),
                            textStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(
              builder: (_) {
                scrollController.addListener(
                  () async {
                    if (state is SearchSuccessState && !state.isPaginating) {
                      if (scrollController.position.pixels ==
                          scrollController.position.maxScrollExtent) {
                        BlocProvider.of<SearchBloc>(context).add(
                          PaginateSearchEvent(),
                        );
                      }
                    }
                  },
                );

                if (state is SearchLoadingState)
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 25,
                              ),
                              itemBuilder: (context, index) =>
                                  SearchItemLoading(),
                              itemCount: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                if (state is SearchInitialState)
                  return Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        SvgPicture.asset(
                          'assets/icons/search/initial.svg',
                          color: Colors.white,
                          width: 130,
                          height: 130,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Nimani qidiramiz?',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  );

                if (state is SearchErrorInsufficientState)
                  return Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          "Minimum qidiruv uzunligi: 2 ta harf",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              color: HexColor('#FF0000'),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                if (state is SearchSuccessState) {
                  if (state.movies.isEmpty) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/search/nothing.svg',
                            color: Colors.white,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Qidiruv bo'yicha\nhech narsa topilmadi",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    );
                  }
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: PageScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 25,
                              ),
                              itemBuilder: (context, index) =>
                                  SearchItem(state.movies[index]),
                              itemCount: state.movies.length,
                            ),
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
                            height: 140,
                          )
                        ],
                      ),
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

  @override
  bool get wantKeepAlive => true;
}
