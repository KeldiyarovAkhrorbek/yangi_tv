import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/widgets/movie_item.dart';

import '../../../bloc/blocs/app_blocs.dart';
import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';
import '../../widgets/loading/movie_item_loading.dart';

class GenreDetailPage extends StatefulWidget {
  static const routeName = '/genre-detail-page';

  @override
  State<GenreDetailPage> createState() => _GenreDetailPageState();
}

class _GenreDetailPageState extends State<GenreDetailPage> {
  String genreName = '';
  int genreId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    genreId = args['genreId'] as int;
    genreName = args['genreName'] as String;
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GenreDetailBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetGenreDetailEvent(genre_id: genreId)),
      child: BlocConsumer<GenreDetailBloc, GenreDetailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                centerTitle: true,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                backgroundColor: Colors.black,
                title: Text(
                  genreName,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            body: Builder(
              builder: (_) {
                scrollController.addListener(
                  () async {
                    if (state is GenreDetailSuccessState &&
                        !state.isPaginating) {
                      if (scrollController.position.pixels ==
                          scrollController.position.maxScrollExtent) {
                        BlocProvider.of<GenreDetailBloc>(context).add(
                          PaginateGenreDetailEvent(),
                        );
                      }
                    }
                  },
                );
                if (state is GenreDetailLoadingState)
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


                if (state is GenreDetailSuccessState) {
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
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
