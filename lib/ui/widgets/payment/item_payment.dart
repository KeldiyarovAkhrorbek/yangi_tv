import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';

class ItemPayment extends StatelessWidget {
  String currentPayment;
  String paymentName;
  String iconPath;
  bool isSvg;
  final VoidCallback pressed;

  ItemPayment({
    required this.currentPayment,
    required this.paymentName,
    required this.iconPath,
    required this.isSvg,
    required this.pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                10,
              ),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  10,
                ),
                onTap: () {
                  pressed();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: isSvg
                      ? SvgPicture.asset(
                          iconPath,
                          fit: BoxFit.contain,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            iconPath,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        if (currentPayment == paymentName)
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: HexColor('#00C42B'),
                    borderRadius: BorderRadius.circular(
                      18,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}
