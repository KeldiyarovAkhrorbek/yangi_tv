import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/widgets/movie_item.dart';

import '../../../bloc/blocs/app_blocs.dart';
import '../../../bloc/blocs/app_events.dart';
import '../../../bloc/repos/mainrepository.dart';
import '../../widgets/loading/movie_item_loading.dart';

class CategoryDetailPage extends StatefulWidget {
  static const routeName = '/category-detail-page';

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  String category_name = '';
  int category_id = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    category_id = args['categoryId'] as int;
    category_name = args['categoryName'] as String;
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryDetailBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetCategoryDetailEvent(category_id: category_id)),
      child: BlocConsumer<CategoryDetailBloc, CategoryDetailState>(
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
                  category_name,
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
                    if (state is CategoryDetailSuccessState &&
                        !state.isPaginating) {
                      if (scrollController.position.maxScrollExtent -
                              scrollController.position.pixels <=
                          40) {
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
                  return GridView.builder(
                    controller: scrollController,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 200,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) =>
                        MovieItem(state.movies[index]),
                    itemCount: state.movies.length,
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
