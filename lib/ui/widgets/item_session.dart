import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/models/session.dart';

class SessionItem extends StatelessWidget {
  SessionModel session;
  final VoidCallback removePressed;

  SessionItem(this.session, this.removePressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor('#282828'),
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/auth/ic_session.svg',
                  color: Colors.white,
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      session.name ?? 'Qurilma',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Text(
                      session.deviceModel ?? 'Qurilma',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 0,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            TextButton(
              onPressed: () {
                removePressed();
              },
              child: Text(
                'SEANSNI YAKUNLASH',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: HexColor('#FF4545'),
                    fontWeight: FontWeight.w500,
                    height: 0,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
