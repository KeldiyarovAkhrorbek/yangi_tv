import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/helpers/color_changer.dart';
import 'package:yangi_tv_new/helpers/custom_image_loader.dart';

class ItemCollection extends StatelessWidget {
  List<String> images;
  String nameText;
  final VoidCallback pressed;

  ItemCollection(this.images, this.nameText, this.pressed);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        pressed();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (images.length == 1) buildOne(images),
          if (images.length == 2) buildTwo(images),
          if (images.length == 3) buildThree(images),
          if (images.length == 4) buildFour(images),
          if (images.length >= 5) buildFive(images),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                color: HexColor('#1E1E34'),
                borderRadius: BorderRadius.circular(
                  10,
                )),
            child: Center(
              child: Text(
                nameText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOne(List<String> images) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: CustomImageLoader(
        imageUrl: images[0],
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        borderRadius: 0,
      ),
    );
  }

  Widget buildTwo(List<String> images) {
    return Container(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 20.0,
              bottom: 20,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-10 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[0],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              bottom: 1,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(10 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[1],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildThree(List<String> images) {
    return Container(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 20.0,
              bottom: 25,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-1 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[0],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 35.0,
              bottom: 25,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(15 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[1],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 1,
              top: 15,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-15 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[2],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFour(List<String> images) {
    return Container(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 20.0,
              bottom: 25,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-1 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[0],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 50.0,
              bottom: 25,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-10 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[1],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 1,
              top: 15,
              right: 10,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-15 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[2],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 50.0,
              bottom: 0,
              top: 10,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(15 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[3],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFive(List<String> images) {
    return Container(
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 20.0,
              bottom: 25,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-1 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[0],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 50.0,
              bottom: 25,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-10 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[1],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 1,
              top: 15,
              right: 10,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-15 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[2],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 5,
              left: 25,
              bottom: 10,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(2 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[3],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 50,
              top: 10,
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(20 / 360),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                child: CustomImageLoader(
                  imageUrl: images[4],
                  width: 100,
                  height: 140,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
