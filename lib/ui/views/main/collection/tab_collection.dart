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
import 'package:yangi_tv_new/ui/widgets/dialog/tryAgainDialog.dart';

import '../../../../bloc/repos/mainrepository.dart';
import '../../../../helpers/color_changer.dart';

class TabCollection extends StatefulWidget {
  const TabCollection({super.key});

  @override
  State<TabCollection> createState() => _TabCollectionState();
}

class _TabCollectionState extends State<TabCollection> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CollectionBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetCollectionsEvent()),
      child: BlocConsumer<CollectionBloc, CollectionState>(
        listener: (context, state) {
          if (state is CollectionErrorState)
            openTryAgainDialog(context, () {
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
              child: GridView.builder(
                controller: scrollController,
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 30, bottom: 120),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 230,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 40,
                ),
                itemBuilder: (context, index) {
                  return ItemCollection(
                    state.collections[index].images,
                    state.collections[index].name,
                        () {
                      Navigator.of(context).pushNamed(
                          CollectionDetailPage.routeName,
                          arguments: {
                            'collection_id': state.collections[index].id,
                            'collection_name': state.collections[index].name,
                          });
                    },
                  );
                },
                itemCount: state.collections.length,
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
