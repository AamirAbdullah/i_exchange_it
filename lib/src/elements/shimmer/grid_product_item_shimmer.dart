import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GridProductItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.only(bottom: 4.0),
      margin: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(5),
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
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: theme.highlightColor,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.highlightColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
                          ),
                          child:  Container(height: 15, width: 35,),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 141,
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //     colors: [
                      //       theme.primaryColorDark.withOpacity(0.0),
                      //       theme.primaryColorDark.withOpacity(0.6),
                      //       theme.primaryColorDark.withOpacity(1),
                      //     ],
                      //     stops: [0.2, 0.7, 1],
                      //     begin: Alignment.topCenter,
                      //     end: Alignment.bottomCenter
                      // )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 8, width: 50, color: theme.highlightColor,),
                          Icon(
                            Icons.favorite,
                            size: 20,
                            color: theme.highlightColor,
                          )
                        ],
                      ),

                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2,),
                  Container(height: 12, width: 40, color: theme.highlightColor,),
                  SizedBox(height: 3,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\$",
                        style: textTheme.subtitle1!.merge(TextStyle(fontSize: 12, color: theme.highlightColor, fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(width: 10),
                      Container(width: 30, height: 8, color: theme.highlightColor,),
                    ],
                  ),
                  SizedBox(height: 5,),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
