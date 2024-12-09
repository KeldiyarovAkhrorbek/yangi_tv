import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/widgets/dialog/tryAgainDialog.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GenreBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetGenresEvent()),
      child: BlocConsumer<GenreBloc, GenreState>(listener: (context, state) {
        if (state is GenreErrorState)
          openTryAgainDialog(context, () {
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
