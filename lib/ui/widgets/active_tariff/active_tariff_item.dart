import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/models/active_tariff.dart';

class ActiveTariffItem extends StatelessWidget {
  ActiveTariff tariff;

  ActiveTariffItem(this.tariff);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(
            color: Colors.white,
          )),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 52,
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('#959595').withOpacity(
                  0.2,
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (tariff.name.toLowerCase().contains('premium'))
                    SvgPicture.asset(
                      'assets/icons/tariff/ic_crown.svg',
                      height: 40,
                      width: 40,
                    ),
                  if (!tariff.name.toLowerCase().contains('premium'))
                    SvgPicture.asset(
                      'assets/icons/tariff/ic_fire.svg',
                      height: 40,
                      width: 40,
                    ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    tariff.name,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            width: 0.9,
            height: double.infinity,
            color: Colors.white,
          ),
          Expanded(
            flex: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          "Tugash muddati:",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
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
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          tariff.expire,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
    );
  }
}