import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/models/session.dart';

import '../../../bloc/blocs/app_blocs.dart';
import '../../../bloc/blocs/app_events.dart';
import '../../../helpers/color_changer.dart';

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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                                BlocProvider.of<LoginBloc>(context).add(
                                  RemoveSessionEvent(session.token),
                                );
                                Navigator.of(context).maybePop();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
