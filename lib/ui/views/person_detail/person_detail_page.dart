import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_events.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/helpers/custom_image_loader.dart';

import '../../../bloc/repos/mainrepository.dart';
import '../../widgets/loading/movie_item_loading.dart';
import '../../widgets/movie_item.dart';

class PersonDetailPage extends StatefulWidget {
  static const routeName = '/person-detail-page';

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  String person_name = '';
  String person_image = '';
  int person_id = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    person_name = args['person_name'] as String;
    person_image = args['person_image'] as String;
    person_id = args['person_id'] as int;
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PersonDetailBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetPersonDetailEvent(person_id: person_id)),
      child: BlocConsumer<PersonDetailBloc, PersonDetailState>(
        listener: (context, state) {},
        builder: (context, state) {
          scrollController.addListener(
            () {
              if (state is PersonDetailSuccessState && !state.isPaginating) {
                if (scrollController.position.pixels ==
                    scrollController.position.maxScrollExtent) {
                  BlocProvider.of<PersonDetailBloc>(context).add(
                    PaginatePersonDetailEvent(),
                  );
                }
              }
            },
          );
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: CustomScrollView(
                controller: scrollController,
                physics: state is PersonDetailLoadingState
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    expandedHeight: 210,
                    pinned: true,
                    centerTitle: true,
                    titleSpacing: 0,
                    backgroundColor: Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1.2,
                      centerTitle: true,
                      titlePadding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      title: Text(
                        person_name,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      collapseMode: CollapseMode.pin,
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              80,
                            ),
                            child: CustomImageLoader(
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                              borderRadius: 0,
                              imageUrl: person_image,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Builder(
                      builder: (_) {
                        if (state is PersonDetailLoadingState)
                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisExtent: 200,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) => MovieItemLoading(),
                            itemCount: 15,
                          );

                        if (state is PersonDetailSuccessState) {
                          return SingleChildScrollView(
                            // controller: scrollController,
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
                          );
                        }
                        return Container();
                      },
                    ),
                  ])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
