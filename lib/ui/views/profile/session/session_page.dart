import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/models/session.dart';
import 'package:yangi_tv_new/ui/widgets/session/item_session_other.dart';
import 'package:yangi_tv_new/ui/widgets/session/item_session_self.dart';

import '../../../../bloc/blocs/app_events.dart';
import '../../../../bloc/repos/mainrepository.dart';
import '../../../../helpers/color_changer.dart';

class SessionPage extends StatefulWidget {
  static const routeName = '/session-page';

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  void openDeleteSessionDialog(BuildContext context, SessionModel session) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) {
        return Container(
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
                            'assets/icons/session/ic_delete_session.svg'),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Rostdan ham ${session.name} (${session.deviceModel})\nsessiyasini yakunlamoqchimisiz?",
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
                                  BlocProvider.of<SessionBloc>(context)
                                    ..add(LogoutSessionEvent(session.token));
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
        );
      },
    );
  }

  final ScrollController scrollController = ScrollController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SessionBloc(RepositoryProvider.of<MainRepository>(context))
            ..add(GetSessionEvent()),
      child: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {},
        builder: (context, state) {
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
                    "Faol qurilmalar",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
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
                  Builder(
                    builder: (_) {
                      if (state is SessionLoadingState)
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );

                      if (state is SessionSuccessState)
                        return Column(
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            ItemSessionSelf(state.current),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListView.separated(
                              itemBuilder: (context, index) =>
                                  ItemSessionOther(state.sessions[index], () {
                                openDeleteSessionDialog(
                                    context, state.sessions[index]);
                              }),
                              padding: EdgeInsets.zero,
                              itemCount: state.sessions.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => SizedBox(
                                height: 20,
                              ),
                            )
                          ],
                        );
                      return Container();
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
