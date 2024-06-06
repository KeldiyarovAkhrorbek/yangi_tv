import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yangi_tv_new/models/category.dart';
import 'package:yangi_tv_new/ui/views/category_detail/category_detail_page.dart';
import 'package:yangi_tv_new/ui/widgets/movie_item.dart';

import '../../helpers/color_changer.dart';

class MainCategory extends StatelessWidget {
  final Category category;

  MainCategory(this.category);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                category.name,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(CategoryDetailPage.routeName, arguments: {
                    'categoryId': category.id,
                    'categoryName': category.name,
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "Barchasini ko'rish",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withOpacity(
                          0.6,
                        ),
                        size: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 10,
            ),
            itemBuilder: (context, index) {
              if (index == 0)
                return Container(
                  margin: EdgeInsets.only(left: 5),
                  child: MovieItem(
                    category.movies[index],
                    false,
                    true,
                  ),
                );
              if (index == category.movies.length)
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 190,
                        width: 128,
                        decoration: BoxDecoration(
                          color: HexColor('#2A3139'),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        )),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Yanada\nko'proq",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: 'Ubuntu',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  CategoryDetailPage.routeName,
                                  arguments: {
                                    'categoryId': category.id,
                                    'categoryName': category.name,
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              return MovieItem(
                category.movies[index],
                false,
                true,
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: category.movies.length + 1,
          ),
        ),
      ],
    );
  }
}
