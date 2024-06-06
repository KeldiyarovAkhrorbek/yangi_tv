import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/models/session.dart';

class ItemSessionOther extends StatelessWidget {
  final SessionModel session;
  final VoidCallback deletePressed;

  ItemSessionOther(this.session, this.deletePressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: Colors.black,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 45,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  SvgPicture.asset(
                    'assets/icons/session/ic_devices.svg',
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 70,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: HexColor('#959595').withOpacity(
                                          0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        )),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        session.name.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: HexColor('#959595').withOpacity(
                                          0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        )),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    child: Center(
                                      child: Text(
                                        session.deviceModel.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                                color: HexColor('#959595').withOpacity(
                                  0.2,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                )),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "So'nggi faolligi:",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    session.createdAt.toString(),
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  deletePressed();
                },
                icon: SvgPicture.asset(
                  'assets/icons/session/ic_delete.svg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
