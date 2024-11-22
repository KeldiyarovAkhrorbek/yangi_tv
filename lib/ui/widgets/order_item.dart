import 'package:flutter/material.dart';
import 'package:yangi_tv_new/ui/views/movie_detail/movie_detail_page.dart';

import '../../helpers/color_changer.dart';
import '../../models/order_model.dart';

class OrderItem extends StatelessWidget {
  OrderModel order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return order.status == 'closed'
        ? doneItem(context, order)
        : order.status == 'rejected'
            ? rejectedItem(order)
            : waitingItem(order);
  }
}

Widget doneItem(BuildContext context, OrderModel order) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 30,
    ),
    child: Stack(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: 20,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          order.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              'Holati: ',
                              style: TextStyle(
                                color: HexColor('#7C7C99'),
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Tayyor',
                              style: TextStyle(
                                color: HexColor('#00AA2E'),
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        if (order.message != null)
                          Row(
                            children: [
                              Text(
                                'Izoh: ',
                                style: TextStyle(
                                  color: HexColor('#7C7C99'),
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                order.message!,
                                style: TextStyle(
                                  color: HexColor('#7C7C99'),
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        if (order.message != null)
                          SizedBox(
                            height: 30,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white60,
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(MovieDetailPage.routeName, arguments: {
                        'content_id': order.contentId!,
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        "Kontentga o'tish",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget rejectedItem(OrderModel order) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 10,
    ),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: 20,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      order.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          "Holati: ",
                          style: TextStyle(
                            color: HexColor('#7C7C99'),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Rad etildi",
                          style: TextStyle(
                            color: HexColor('#E30000'),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    if (order.message != null)
                      Row(
                        children: [
                          Text(
                            "Izoh: ",
                            style: TextStyle(
                              color: HexColor('#7C7C99'),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            order.message!,
                            style: TextStyle(
                              color: HexColor('#7C7C99'),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    ),
  );
}

Widget waitingItem(OrderModel order) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 10,
    ),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            bottom: 20,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      order.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Text(
                          "Holati: ",
                          style: TextStyle(
                            color: HexColor('#7C7C99'),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Kutilmoqda",
                          style: TextStyle(
                            color: HexColor('#FF9900'),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    if (order.message != null)
                      Row(
                        children: [
                          Text(
                            'Izoh: ',
                            style: TextStyle(
                              color: HexColor('#7C7C99'),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            order.message!,
                            style: TextStyle(
                              color: HexColor('#7C7C99'),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    ),
  );
}
