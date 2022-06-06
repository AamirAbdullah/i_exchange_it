

import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/category.dart';

class CategoryListIconItem extends StatelessWidget {
 final Category? cat;
 final VoidCallback? onTap;

  CategoryListIconItem({this.cat, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return GestureDetector(
      onTap: this.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
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
                  color: theme.colorScheme.secondary,
                  width: 1,
                ),
              ),
              child: cat!.image != null
                  ? Container(
                // width: 53,
                // height: 53,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(cat!.image), //
                    // fit: BoxFit.fill,
                  ),
                ),
              )
              : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset("assets/placeholders/default_cat.png", color: theme.focusColor,),
              ),
            ),
            Container(
              width: 60,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: Text(
                    cat!.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyText2!.merge(TextStyle(fontWeight: FontWeight.w500, fontSize: 11)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
