import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/custom_image_loader.dart';
import 'package:yangi_tv_new/helpers/translit.dart';
import 'package:yangi_tv_new/models/movie_full.dart';

class ActorWidget extends StatelessWidget {
  Actor actor;
  Function() pressed;

  ActorWidget(this.actor, this.pressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pressed();
      },
      child: Container(
        width: 60,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CustomImageLoader(
                imageUrl: actor.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                borderRadius: 0,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              Translit().toTranslit(
                  source:
                      actor.name.replaceAll("Дж", "Ж").replaceAll("дж", "ж")),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
