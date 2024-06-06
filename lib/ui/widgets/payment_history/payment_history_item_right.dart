import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:yangi_tv_new/models/payment_history.dart';

import '../../../helpers/bubble.dart';

class PaymentHistoryItemRight extends StatelessWidget {
  PaymentHistory paymentHistory;

  PaymentHistoryItemRight(this.paymentHistory);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            width: double.infinity,
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: BubbleSpecialThree(
                    text: paymentHistory.description,
                    color: Colors.black,
                    textStyle: TextStyle(color: Colors.white, fontSize: 12),
                    tail: true,
                    isSender: true,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: .8,
                    ),
                    color: Colors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: FancyShimmerImage(
                      imageUrl: paymentHistory.image,
                      width: 50,
                      height: 50,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: 14,
                  left: 40,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    )),
                child: Text(
                  paymentHistory.date,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(right: 100, top: 1),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    )),
                child: Text(
                  "Yangi TV",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
