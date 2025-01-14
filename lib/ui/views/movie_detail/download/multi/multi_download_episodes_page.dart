import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:blur/blur.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/download/download_bloc.dart';
import 'package:yangi_tv_new/bloc/blocs/download/download_event.dart';
import 'package:yangi_tv_new/bloc/blocs/download/download_state.dart';
import 'package:yangi_tv_new/helpers/decryptor.dart';
import 'package:yangi_tv_new/helpers/filesizeformatter.dart';
import 'package:yangi_tv_new/injection_container.dart';
import '../../../../../bloc/repos/mainrepository.dart';
import '../../../../../helpers/color_changer.dart';
import '../../../../../models/season.dart';
import '../../../profile/tariffs_page/tariffs_page.dart';
import '../../watch/offline/video_player_page_offline.dart';

class MultiDownloadEpisodesPage extends StatefulWidget {
  static const routeName = '/multi-download-episodes';

  @override
  State<MultiDownloadEpisodesPage> createState() =>
      _MultiDownloadEpisodesPageState();
}

class _MultiDownloadEpisodesPageState extends State<MultiDownloadEpisodesPage> {
  String movie_name = '';
  String image = '';
  String season = '';
  String tariff = '';
  List<Episode> episodes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    movie_name = args['name'];
    image = args['image'];
    season = args['season'];
    episodes = args['episodes'];
    tariff = args['tariff'];
  }

  void openPauseDialog(BuildContext context, String taskId, String name) {
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
                          height: 230,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 230,
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
                              'assets/icons/download/ic_pause_task.svg'),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${name} yuklab olinmoqda,\npauza qilasizmi?",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Bekor qilish',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: HexColor('#FF4747'),
                                  onPressed: () {
                                    getIt<DownloadBloc>().add(
                                      PauseTaskEvent(taskId),
                                    );
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Ha, albatta!',
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

  void openRemoveTaskDialog(BuildContext context, String taskId, String name) {
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
                          height: 230,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 230,
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
                              'assets/icons/download/ic_delete_task.svg'),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${name}ni\nrostdan ham o'chirmoqchimisiz?",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Bekor qilish',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  fillColor: HexColor('#FF4747'),
                                  onPressed: () {
                                    getIt<DownloadBloc>().add(
                                      DeleteTaskEvent(taskId),
                                    );
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Ha, albatta!',
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

  final ScrollController scrollController = ScrollController();
  bool show = false;

  bool isTariffLoading = false;
  String? errorText;

  void showErrorDialog(String text) {
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
                          height: 230,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 230,
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
                            'assets/icons/download/ic_error.svg',
                            color: Colors.red,
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            text,
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
                                  fillColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).maybePop();
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Tushunarli',
                                      style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                          color: Colors.black,
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
    scrollController.addListener(() {
      if (scrollController.position.pixels > 50) {
        show = true;
      } else
        show = false;
      setState(() {});
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: AppBar(
            automaticallyImplyLeading: false,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            leading: Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 6.0,
                bottom: 6.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: double.infinity,
              height: double.infinity,
              color: show ? Colors.black : Colors.transparent,
            ),
            title: Text(
              movie_name,
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        body: BlocConsumer<DownloadBloc, DownloadState>(
          bloc: getIt<DownloadBloc>(),
          listener: (context, state) {},
          builder: (context, state) {
            return Builder(
              builder: (_) {
                return Stack(
                  children: [
                    Image.asset(
                      'assets/images/profile_background.png',
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(
                              0.8,
                            ),
                            Colors.black,
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.only(top: 60),
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        if(index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "${season}dan yuklab olish uchun qismni tanlang:",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        }
                        return buildEpisode(context, episodes[index - 1], state);
                      },
                      itemCount: episodes.length + 1,
                    ),
                    if (isTariffLoading)
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                          ).blurred(
                            blurColor: Colors.black,
                            blur: 10,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                  ],
                );
                return Container();
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildEpisode(
      BuildContext context, Episode episode, DownloadState state) {
    var indexTask = -1;
    indexTask = state.tasks
        .indexWhere((dbTask) => dbTask.url == decryptArray(episode.file!));
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FancyShimmerImage(
                      imageUrl: image,
                      width: double.infinity,
                      height: double.infinity,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 72,
                  child: Builder(builder: (_) {
                    if (indexTask == -1)
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              episode.name,
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      if (episode.file != null)
                                        getIt<DownloadBloc>().add(
                                          AddDownloadEvent(
                                            movie_name: movie_name,
                                            name: episode.name,
                                            displayName: movie_name +
                                                " " +
                                                season +
                                                " " +
                                                episode.name,
                                            image: image,
                                            url: decryptArray(episode.file!),
                                            seasonName: season,
                                            is_multi: true,
                                            tariff: tariff,
                                          ),
                                        );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/profile/ic_download.svg',
                                            color: Colors.white,
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Yuklab olish",
                                            style: GoogleFonts.ubuntu(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );

                    if (state.tasks[indexTask].status == TaskStatus.paused)
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              episode.name,
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Pauza qilingan",
                                          style: GoogleFonts.ubuntu(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${(state.tasks[indexTask].size * state.tasks[indexTask].progress).abs().toHumanReadableFileSize()} | ${(state.tasks[indexTask].size).abs().toHumanReadableFileSize()}",
                                        style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );

                    if (state.tasks[indexTask].status == TaskStatus.running ||
                        state.tasks[indexTask].status ==
                            TaskStatus.waitingToRetry ||
                        state.tasks[indexTask].status == TaskStatus.enqueued)
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              episode.name,
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Qoldi: ${prettyDuration(Duration(seconds: state.tasks[indexTask].remainingTime))}",
                                          style: GoogleFonts.ubuntu(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${(state.tasks[indexTask].size * state.tasks[indexTask].progress).abs().toHumanReadableFileSize(round: 2)} | ${(state.tasks[indexTask].size).abs().toHumanReadableFileSize(round: 2)} | ${(state.tasks[indexTask].networkSpeed).abs().toStringAsFixed(2)} MB/s",
                                        style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );

                    if (state.tasks[indexTask].status == TaskStatus.complete)
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              episode.name,
                              style: GoogleFonts.ubuntu(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () async {
                                      setState(() {
                                        isTariffLoading = true;
                                      });
                                      var tariffExists = false;
                                      try {
                                        var activeTariffs =
                                            await MainRepository()
                                                .getActiveTariffs();
                                        var profile =
                                            await MainRepository().getProfile();
                                        setState(() {
                                          isTariffLoading = false;
                                        });
                                        if (state.tasks[indexTask].tariff
                                                .toUpperCase() ==
                                            'BEPUL') tariffExists = true;

                                        activeTariffs.forEach((tariff) {
                                          if (tariff.name ==
                                                  state.tasks[indexTask]
                                                      .tariff ||
                                              state.tasks[indexTask].tariff
                                                      .toUpperCase() ==
                                                  'BEPUL') {
                                            tariffExists = true;
                                          }
                                        });
                                        if (!tariffExists) {
                                          //return to tariff page
                                          Navigator.of(context).pushNamed(
                                              TariffsPage.routeName,
                                              arguments: {
                                                'tariff_filter': state
                                                    .tasks[indexTask].tariff,
                                              });
                                          return;
                                        }

                                        //proceed to watch
                                        File file =
                                            File(state.tasks[indexTask].path);
                                        bool exists = await file.exists();
                                        if (exists)
                                          Navigator.of(context).pushNamed(
                                              VideoPlayerPageOffline.routeName,
                                              arguments: {
                                                'movie_name': state
                                                    .tasks[indexTask]
                                                    .displayName,
                                                'profile': profile,
                                                'videoUrl': file.path,
                                              });
                                      } catch (e) {
                                        setState(() {
                                          isTariffLoading = false;
                                        });
                                        if (e
                                            .toString()
                                            .toLowerCase()
                                            .contains('socket')) {
                                          showErrorDialog(
                                              'Iltimos, internetingizni yoqib qo\'ying,\nsizdan trafik talab etilmaydi!');
                                        } else {
                                          showErrorDialog(
                                              'Qandaydir xatolik yuzaga keldi.\nIltimos, qayta urining.');
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/download/ic_play.svg',
                                            color: Colors.white,
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Tomosha qilish",
                                            style: GoogleFonts.ubuntu(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: HexColor('#959595').withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "To'liq yuklandi! (100%)",
                                        style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${state.tasks[indexTask].size.abs().toHumanReadableFileSize(round: 1)}",
                                        style: GoogleFonts.ubuntu(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );

                    return Container();
                  }),
                ),
              ],
            ),
          ),
          Builder(
            builder: (_) {
              if (indexTask == -1) {
                return Container();
              }

              if (state.tasks[indexTask].status == TaskStatus.running ||
                  state.tasks[indexTask].status == TaskStatus.waitingToRetry ||
                  state.tasks[indexTask].status == TaskStatus.enqueued)
                return Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        child: IconButton(
                          onPressed: () {
                            openPauseDialog(context,
                                state.tasks[indexTask].taskId, episode.name);
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/download/ic_pause.svg',
                            color: HexColor('#FFD914'),
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          onPressed: () {
                            openRemoveTaskDialog(context,
                                state.tasks[indexTask].taskId, episode.name);
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/download/ic_cancel.svg',
                            width: 23,
                            height: 23,
                          ),
                        ),
                      )
                    ],
                  ),
                );

              if (state.tasks[indexTask].status == TaskStatus.complete)
                return Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      onPressed: () {
                        openRemoveTaskDialog(context,
                            state.tasks[indexTask].taskId, episode.name);
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/download/ic_cancel.svg',
                        width: 23,
                        height: 23,
                      ),
                    ),
                  ),
                );

              if (state.tasks[indexTask].status == TaskStatus.paused)
                return Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      onPressed: () {
                        getIt<DownloadBloc>()
                          ..add(ResumeTaskEvent(state.tasks[indexTask].taskId));
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/download/ic_play.svg',
                        width: 23,
                        height: 23,
                        color: HexColor('#00C42B'),
                      ),
                    ),
                  ),
                );

              return Container();
            },
          ),
        ],
      ),
    );
  }
}
