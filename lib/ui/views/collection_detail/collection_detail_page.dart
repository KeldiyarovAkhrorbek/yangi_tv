import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_events.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';

import '../../../bloc/repos/mainrepository.dart';
import '../../widgets/loading/movie_item_loading.dart';
import '../../widgets/movie_item.dart';

class CollectionDetailPage extends StatefulWidget {
  static const routeName = '/collection-detail-page';

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  String collection_name = '';
  int collection_id = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    collection_id = args['collection_id'] as int;
    collection_name = args['collection_name'] as String;
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CollectionDetailBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetCollectionDetailEvent(collection_id: collection_id)),
      child: Scaffold(
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
              collection_name,
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
        body: BlocConsumer<CollectionDetailBloc, CollectionDetailState>(
          listener: (context, state) {},
          builder: (context, state) {
            scrollController.addListener(
              () async {
                if (state is CollectionDetailSuccessState &&
                    !state.isPaginating) {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    BlocProvider.of<CollectionDetailBloc>(context).add(
                      PaginateCollectionDetailEvent(),
                    );
                  }
                }
              },
            );

            if (state is CollectionDetailLoadingState)
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

            if (state is CollectionDetailSuccessState) {
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
    );
  }
}
