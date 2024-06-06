import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:yangi_tv_new/bloc/blocs/app_blocs.dart';
import 'package:yangi_tv_new/bloc/blocs/app_states.dart';
import 'package:yangi_tv_new/ui/views/auth/sms_verify_page.dart';

import '../../../bloc/blocs/app_events.dart';
import '../../../helpers/color_changer.dart';

class PhoneNumberPage extends StatefulWidget {
  static const routeName = '/phone-number-page';

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(##) ### ## ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  bool onCurrentPage = true;

  TextEditingController numberController = TextEditingController();
  FocusNode numberFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state is VerifyState && onCurrentPage) {
          onCurrentPage = false;
          Navigator.of(context).pushNamed(SmsVerifyPage.routeName).then(
            (value) {
              onCurrentPage = true;
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: SafeArea(
            child: InkWell(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                numberFocusNode.unfocus();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 170,
                        ),
                        Text(
                          'Iltimos, telefon raqamingizni kiriting',
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
                          height: 35,
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
                              controller: numberController,
                              focusNode: numberFocusNode,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                BlocProvider.of<LoginBloc>(context).add(
                                  ChangeErrorEvent('sendOtp'),
                                );
                              },
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                              inputFormatters: [maskFormatter],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 0,
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_phone_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '+998',
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: null,
                                hintText: '91 123 45 67',
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
                        SizedBox(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              if (state is EnterPhoneNumberState &&
                                  state.errorText != null)
                                Text(
                                  state.errorText!,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: HexColor('#FF0000'),
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                      fontSize: 14,
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
                              onTap: (state is EnterPhoneNumberState &&
                                      state.isLoading)
                                  ? null
                                  : () {
                                      BlocProvider.of<LoginBloc>(context).add(
                                        SendOtpEvent(
                                            maskFormatter.getUnmaskedText()),
                                      );
                                    },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: (state is EnterPhoneNumberState &&
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
      },
    );
  }
}
