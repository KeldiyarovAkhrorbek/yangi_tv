
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';

void openWarningDialog(BuildContext context, VoidCallback proceedPressed) {
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
                        height: 250,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 250,
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
                        SvgPicture.asset('assets/icons/watch/ic_warning.svg'),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Ushbu kontent uchun yosh chegarasi 18+ deb belgilangan.\nSiz 18 yoshdan oshganmisiz?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
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
                                    "Yo'q",
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
                                onPressed: () async {
                                  Navigator.of(context).maybePop();
                                  await Future.delayed(
                                      Duration(milliseconds: 100));
                                  proceedPressed();
                                },
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    'Ha',
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