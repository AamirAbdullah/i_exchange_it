// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {

 final IconData? icon;
 final String? text;
 final Color? color;
 final Color? textColor;
 final VoidCallback? onSeeAll;
  bool isShowSeeAll = true;

  HomeSectionHeader({this.icon, this.isShowSeeAll = true, this.text, this.color, this.onSeeAll, this.textColor});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(left: 7, top: 5, bottom: 5, right: 12),
              decoration: BoxDecoration(
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.3, 0.3),
                    blurRadius: 4,
                  )
                ],
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: textColor,
                  ),
                  SizedBox(width: 5,),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: size.width - 70,
                    ),
                    child: Text(text ?? " ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headline6!.merge(TextStyle(color: textColor)),),
                  ),
                ],
              )
          ),
          SizedBox(width: 10,),
          Expanded(
            flex: 1,
            child: Container(
              height: 0.5,
              color: color,
            ),
          ),
          SizedBox(width: this.isShowSeeAll ? 50 : 10,),
          this.isShowSeeAll
              ? InkWell(
            onTap: this.onSeeAll,
            child: Text("see all", style: textTheme.subtitle2!
                .merge(TextStyle(
                color: color,
                // color: Colors.black,
                decoration: TextDecoration.underline)),),
          ) : SizedBox(width: 0, height: 0,)
        ],
      ),
    );
  }
}
