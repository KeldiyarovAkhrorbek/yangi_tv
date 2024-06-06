import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/custom_image_loader.dart';
import 'package:yangi_tv_new/models/story.dart';

import '../../helpers/color_changer.dart';

class StoryItem extends StatelessWidget {
  final Story story;
  final VoidCallback storyPressed;

  StoryItem(this.story, this.storyPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        storyPressed();
      },
      child: Container(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        story.watched ? Colors.grey : HexColor('#FFD600'),
                        story.watched ? Colors.grey : HexColor('#FF0099'),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: Colors.black,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    60 / 2,
                  ),
                  child: CustomImageLoader(
                    imageUrl: story.image ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    borderRadius: 0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              story.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
