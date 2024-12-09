import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/models/session.dart';
import 'package:yangi_tv_new/ui/views/auth/change_username_page.dart';
import 'package:yangi_tv_new/ui/views/auth/phone_number_page.dart';
import 'package:yangi_tv_new/ui/views/navigation/navigation_page.dart';
import 'package:yangi_tv_new/ui/widgets/dialog/sessionDeleteDialog.dart';
import 'package:yangi_tv_new/ui/widgets/session/item_session_reg.dart';

import '../../../bloc/blocs/app_events.dart';
import '../../../helpers/color_changer.dart';
import '../courses/courses_page.dart';

class SessionDeletePage extends StatefulWidget {
  static const routeName = '/session-delete-page';

  @override
  State<SessionDeletePage> createState() => _SessionDeletePageState();
}

class _SessionDeletePageState extends State<SessionDeletePage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is EnterPhoneNumberState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              PhoneNumberPage.routeName, (route) => false);
        }
        if (state is ChangeNameState) {
          Navigator.of(context).pushNamed(ChangeUsernamePage.routeName);
        }
        if (state is SuccessState) {
          if (state.shouldOpenCourses) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                CoursesPage.routeName, (route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                NavigationPage.routeName, (route) => false);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Qurilmalar soni limitga yetgan!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 0,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Iltimos, eski qurilmalaringizdagi seansni yakunlang!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 0,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (state is DeleteSessionState)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 14,
                              ),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => ItemSessionReg(
                                state.sessions[index],
                                () {
                                  openDeleteSessionDialog(
                                      context, state.sessions[index]);
                                },
                              ),
                              itemCount: state.sessions.length,
                              physics: PageScrollPhysics(),
                            ),
                          ),
                        SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (state is DeleteSessionState &&
                          state.sessions.length < 3)
                        Container(
                          width: double.infinity,
                          height: 45,
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor('#E50914'),
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                              onTap: (state.isLoading)
                                  ? null
                                  : () {
                                      BlocProvider.of<LoginBloc>(context).add(
                                        CheckOtpDeleteSessionEvent(),
                                      );
                                    },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: (state.isLoading)
                                    ? Center(
                                        child: Container(
                                            width: 26,
                                            height: 26,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            )),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'DAVOM ETISH',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_outlined,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
