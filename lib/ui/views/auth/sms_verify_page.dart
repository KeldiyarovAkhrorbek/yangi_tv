import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/views/auth/change_username_page.dart';
import 'package:yangi_tv_new/ui/views/auth/session_delete_page.dart';
import 'package:yangi_tv_new/ui/views/courses/courses_page.dart';

import '../../../bloc/blocs/app_events.dart';
import '../../../helpers/color_changer.dart';
import '../navigation/navigation_page.dart';

class SmsVerifyPage extends StatefulWidget {
  static const routeName = '/sms-verify-page';

  @override
  State<SmsVerifyPage> createState() => _SmsVerifyPageState();
}

class _SmsVerifyPageState extends State<SmsVerifyPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  var borderColor = Colors.white;
  var errorColor = HexColor('#FF0000');
  var fillColor = HexColor('#434141');

  bool canSendOtp = false;
  int remainingTime = 60;
  Timer? _timer;

  void resendOtp(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(
      ResendOtpEvent(),
    );
    remainingTime = 60;
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) if (remainingTime == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          if (mounted)
            setState(() {
              remainingTime--;
            });
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startTimer();
  }

  Future<void> getSmsCode() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    super.dispose();
    _timer = null;
  }

  bool onCurrentPage = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is DeleteSessionState && onCurrentPage) {
          onCurrentPage = false;
          Navigator.of(context).pushNamed(SessionDeletePage.routeName).then(
            (value) {
              onCurrentPage = true;
            },
          );
        }

        if (state is SuccessState) {
          if (state.shouldOpenCourses) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                CoursesPage.routeName, (route) => false);
          } else
            Navigator.of(context).pushNamedAndRemoveUntil(
                NavigationPage.routeName, (route) => false);
        }

        if (state is ChangeNameState && onCurrentPage) {
          onCurrentPage = false;
          Navigator.of(context).pushNamed(ChangeUsernamePage.routeName).then(
            (value) {
              onCurrentPage = true;
            },
          );
        }
      },
      builder: (context, state) {
        var defaultPinTheme = PinTheme(
          width: 50,
          height: 50,
          textStyle: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: 0,
              fontSize: 19,
            ),
          ),
          decoration: BoxDecoration(
            color: HexColor('#D9D9D9').withOpacity(0.47),
            borderRadius: BorderRadius.circular(8),
            border: (state is VerifyState && state.errorText != null)
                ? Border.all(color: HexColor('#FF0000'))
                : null,
          ),
        );
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: [
                          PinFieldAutoFill(
                            codeLength: 6,
                            enabled: false,
                            autoFocus: false,
                            enableInteractiveSelection: false,
                            onCodeChanged: (code) {
                              if (code != null && code.isNotEmpty) {
                                controller.text = code;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
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
                          height: 110,
                        ),
                        Text(
                          "${BlocProvider.of<LoginBloc>(context).phoneNumberMasked}" +
                              ' - ushbu raqamga\ntasdiqlash kodi yuborildi. Kodni kiriting:',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        SizedBox(
                          height: 68,
                          child: Pinput(
                            length: 6,
                            controller: controller,
                            focusNode: focusNode,
                            defaultPinTheme: defaultPinTheme,
                            onChanged: (value) async {
                              BlocProvider.of<LoginBloc>(context).add(
                                ChangeErrorEvent('verify'),
                              );
                            },
                            onCompleted: (pin) async {
                              BlocProvider.of<LoginBloc>(context).add(
                                CheckOtpEvent(otp: controller.text),
                              );
                            },
                            focusedPinTheme: defaultPinTheme.copyWith(
                              height: 60,
                              width: 55,
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(
                                  color:
                                      false ? HexColor('#FF0000') : borderColor,
                                ),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                color: errorColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                                child: (state is VerifyState &&
                                        state.errorText != null)
                                    ? Text(
                                        state.errorText!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: HexColor('#FF0000'),
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Kod yetib bormadimi?",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: remainingTime == 0
                                    ? () {
                                        resendOtp(context);
                                      }
                                    : null,
                                child: Text(
                                  remainingTime == 0
                                      ? "Kodni qayta yuborish"
                                      : "Kodni qayta yuborish (${remainingTime} soniyadan so'ng)",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: HexColor('#FF0000'),
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              onTap: (state is VerifyState && state.isLoading)
                                  ? null
                                  : () {
                                      BlocProvider.of<LoginBloc>(context).add(
                                        CheckOtpEvent(otp: controller.text),
                                      );
                                    },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: (state is VerifyState && state.isLoading)
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
      },
    );
  }
}
