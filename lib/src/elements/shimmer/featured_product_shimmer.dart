import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedProductShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Container(
      width: 140,
      padding: EdgeInsets.only(bottom: 4.0),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: theme.primaryColor,
          boxShadow: [
            BoxShadow(
                color: theme.focusColor,
                offset: Offset(0.3, 0.3),
                blurRadius: 4
            )
          ]
      ),
      child: Shimmer.fromColors(
        baseColor: theme.focusColor,
        highlightColor: theme.highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
          height: 140,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.highlightColor,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.highlightColor,
                      ),
                      child: Container(height: 15, width: 35,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 20, height: 10, color: theme.highlightColor,),
                      Icon(
                        Icons.favorite,
                        size: 20,
                        color: theme.highlightColor,
                      )
                    ],
                  ),
                  SizedBox(height: 2,),
                  Container(width: 70, height: 10, color: theme.highlightColor,),
                  SizedBox(height: 3,),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: theme.highlightColor,
                      ),
                      SizedBox(width: 5,),
                      Container(width: 70, height: 8, color: theme.highlightColor,),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Container(width: 50, height: 8, color: theme.highlightColor,),
                      // StarRating(rating: item.rating, size: 14,),
                      // Text(
                      //   '(${item.totalReviews})',
                      //   style: textTheme.bodyText2.merge(TextStyle(fontSize: 12)),
                      // )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(
                        "\$",
                        style: textTheme.subtitle1!.merge(TextStyle(fontSize: 12, color: theme.highlightColor, fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(width: 10),
                      Container(width: 30, height: 8, color: theme.highlightColor,),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
