import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_events.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';

import '../../../helpers/color_changer.dart';
import '../navigation/navigation_page.dart';

class ChangeUsernamePage extends StatefulWidget {
  static const routeName = '/change-username-page';

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  FocusNode nameFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    nameFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is SuccessState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              NavigationPage.routeName, (route) => false);
        }
      },
      builder: (context, state) {
        if (state is ChangeNameState)
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: InkWell(
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  nameFocusNode.unfocus();
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                BackButton(
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Text(
                            'Iltimos, ismingizni kiriting!',
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: HexColor("#3B3B3B"),
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              child: TextFormField(
                                controller: nameController,
                                focusNode: nameFocusNode,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: null,
                                  hintText: 'Ismingizni kiriting...',
                                  hintStyle: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (state.errorText != null)
                            SizedBox(
                              height: 10,
                            ),
                          if (state.errorText != null)
                            Text(
                              state.errorText!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: HexColor('#E50914'),
                              ),
                            )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                                          ChangeNameEvent(nameController.text),
                                        );
                                      },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: (state is VerifyState &&
                                          state.isLoading)
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
            ),
          );

        return Container();
      },
    );
  }
}
