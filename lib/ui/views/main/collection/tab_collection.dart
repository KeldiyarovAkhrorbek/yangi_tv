import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_events.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/views/collection_detail/collection_detail_page.dart';
import 'package:yangi_tv_new/ui/widgets/collection/item_collection.dart';

import '../../../../bloc/repos/mainrepository.dart';
import '../../../../helpers/color_changer.dart';

class TabCollection extends StatefulWidget {
  const TabCollection({super.key});

  @override
  State<TabCollection> createState() => _TabCollectionState();
}

class _TabCollectionState extends State<TabCollection> {
  ScrollController scrollController = ScrollController();

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
          CollectionBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetCollectionsEvent()),
      child: BlocConsumer<CollectionBloc, CollectionState>(
        listener: (context, state) {
          if (state is CollectionErrorState)
            openTryAgainDialog(() {
              BlocProvider.of<CollectionBloc>(context)
                ..add(GetCollectionsEvent());
            });
        },
        builder: (context, state) {
          scrollController.addListener(
            () async {
              if (state is CollectionSuccessState && !state.isPaginating) {
                if (scrollController.position.pixels ==
                    scrollController.position.maxScrollExtent) {
                  BlocProvider.of<CollectionBloc>(context).add(
                    PaginateCollectionEvent(),
                  );
                }
              }
            },
          );
          if (state is CollectionSuccessState)
            return RefreshIndicator(
              color: Colors.black,
              onRefresh: () async {
                BlocProvider.of<CollectionBloc>(context)
                  ..add(GetCollectionsEvent());
              },
              child: Scaffold(
                backgroundColor: Colors.black,
                body: SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: GridView.builder(
                          physics: PageScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 230,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 40,
                          ),
                          itemBuilder: (context, index) => ItemCollection(
                            state.collections[index].images,
                            state.collections[index].name,
                            () {
                              Navigator.of(context).pushNamed(
                                  CollectionDetailPage.routeName,
                                  arguments: {
                                    'collection_id':
                                        state.collections[index].id,
                                    'collection_name':
                                        state.collections[index].name,
                                  });
                            },
                          ),
                          itemCount: state.collections.length,
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
                      SizedBox(
                        height: 120,
                      ),
                    ],
                  ),
                ),
              ),
            );

          if (state is CollectionLoadingState)
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );

          return Container();
        },
      ),
    );
  }
}
