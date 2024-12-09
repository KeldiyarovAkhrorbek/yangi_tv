import 'package:flutter/material.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';

Widget buildRating(double rating) {
  int remainingInt = 5;
  if (rating > 0 && rating <= 2) {
    remainingInt = 1;
  } else if (rating > 2 && rating <= 4) {
    remainingInt = 2;
  } else if (rating > 4 && rating <= 6) {
    remainingInt = 3;
  } else if (rating > 6 && rating <= 7.9) {
    remainingInt = 4;
  } else {
    remainingInt = 5;
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (int i = 0; i < remainingInt; i++) ...[
        Icon(
          Icons.star,
          color: HexColor('#F2C94C'),
          size: 20,
        )
      ],
      for (int i = 0; i < 5 - remainingInt; i++) ...[
        Icon(
          Icons.star_border,
          color: HexColor('#F2C94C'),
          size: 20,
        )
      ],
    ],
  );
}
