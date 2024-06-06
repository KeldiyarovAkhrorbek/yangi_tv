import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yangi_tv_new/models/comment.dart';
import 'package:yangi_tv_new/models/payment_history.dart';

import '../../../helpers/bubble.dart';

class CommentItem extends StatelessWidget {
  Comment comment;

  CommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    if(comment.text==null)
      return Container();
    return Container(
      child: Column(
        children: [
          if (comment.reply?.text != null)
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
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
                          text: comment.reply!.text!,
                          color: Colors.black,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
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
                          border: Border.all(color: Colors.white, width: .8),
                          color: Colors.black,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: FancyShimmerImage(
                            imageUrl:
                            'https://admin.yangi.tv/uploads/assets/payments/system.jpg',
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
                        bottom: 13,
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
                        comment.reply?.date ?? '',
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
          Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                width: double.infinity,
                margin: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(color: Colors.white, width: .8),
                        color: Colors.black,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: FancyShimmerImage(
                          imageUrl: comment.photo,
                          width: 50,
                          height: 50,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: BubbleSpecialThree(
                          text: comment.text!,
                          color: Colors.black,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          tail: true,
                          isSender: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 13,
                      right: 30,
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
                      comment.date,
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
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 90, top: 1),
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
                      "${comment.name} ${comment.login}",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}