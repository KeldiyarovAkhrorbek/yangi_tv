import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/widgets/story_watch_item.dart';

import '../../../bloc/blocs/app_events.dart';

class StoryWatchPage extends StatefulWidget {
  static const routeName = '/story-watch-page';

  @override
  State<StoryWatchPage> createState() => _StoryWatchPageState();
}

class _StoryWatchPageState extends State<StoryWatchPage> {
  late MainBloc mainBloc;
  int startIndex = 0;
  CarouselSliderController carouselSliderController =
      CarouselSliderController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    mainBloc = args['mainBloc'];
    startIndex = args['index'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<MainBloc, MainState>(
          bloc: mainBloc,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is MainSuccessState)
              return SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CarouselSlider.builder(
                  controller: carouselSliderController,
                  initialPage: startIndex,
                  slideBuilder: (index) => StoryWatchItem(
                    state.stories[index],
                    () {
                      mainBloc
                        ..add(WatchStoryEvent(state.stories[index].id ?? 0));
                    },
                  ),
                  itemCount: state.stories.length,
                  scrollDirection: Axis.vertical,
                ),
              );

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.green,
            );
          },
        ),
      ),
    );
  }
}
