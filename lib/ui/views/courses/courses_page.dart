import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/helpers/detect_emulator.dart';
import 'package:yangi_tv_new/ui/widgets/movie_item.dart';

import '../../../bloc/blocs/app_blocs.dart';
import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';
import '../../widgets/loading/movie_item_loading.dart';

class CoursesPage extends StatefulWidget {
  static const routeName = '/courses-page';

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryDetailBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetCategoryDetailEvent(category_id: 11)),
      child: BlocConsumer<CategoryDetailBloc, CategoryDetailState>(
        listener: (context, state) {},
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
                return Container();
              },
            ),
          );
        },
      ),
    );
  }
}
