import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: (){},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Shimmer.fromColors(
          baseColor: theme.focusColor,
          highlightColor: theme.highlightColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 55,
                height: 55,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: theme.highlightColor,
                    width: 1,
                  ),
                ),
                child: Container(
                  // width: 53,
                  // height: 53,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset("assets/placeholders/default_cat.png", color: theme.highlightColor,),
                ),
              ),
              Container(
                width: 60,
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Center(
                    child: Container(
                      height: 10, width: 45,
                      color: theme.highlightColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
