import 'package:flutter/material.dart';

class GeneralCategoryListIconItem extends StatelessWidget {
 final String? name;
 final String? image;
 final VoidCallback? onTap;

  GeneralCategoryListIconItem({this.name, this.image, this.onTap});

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
              child: this.image != null
                  ? Container(
                // width: 53,
                // height: 53,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(image!), //
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
                    name!,
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
