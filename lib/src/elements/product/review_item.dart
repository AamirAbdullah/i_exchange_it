// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/review.dart';
import 'package:intl/intl.dart';

class ReviewItemWidget extends StatelessWidget {
  
 final Review? review;
 final VoidCallback? onStatusChange;
  bool showAction = true;

  ReviewItemWidget({this.review, this.onStatusChange, this.showAction = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;



    var format = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ');
    var dateTime = format.parse(review!.createdAt);
    var day = DateFormat('EEEE').format(dateTime);
    var dayOfMonth = DateFormat('dd').format(dateTime);
    var month = DateFormat('MMM').format(dateTime);
    var time = DateFormat('hh:mm aa').format(dateTime);

    bool isVisible = review!.status == "1" || review!.status == 1 || review!.status == true;

    return Opacity(
      opacity: isVisible ? 1 : 0.6,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${review!.comment}', style: textTheme.bodyText1),
                    SizedBox(height: 3),
                    Text(
                        '$day $dayOfMonth, $month at $time',
                        style: textTheme.caption
                    ),
                  ],
                ),
              ),

              showAction ?
              InkWell(
                onTap: this.onStatusChange,
                child: Container(
                  width: 50,
                  height: 20,
                  color: theme.colorScheme.secondary,
                  child: Center(
                    child: Text(
                      isVisible
                          ? "Hide"
                          : "UnHide",
                      style: textTheme.bodyText2!.merge(TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      )),
                    ),
                  ),
                ),
              )
                  : SizedBox(height: 0, width: 0,)


            ],
          ),
          SizedBox(height: 3),
          Container(width: size.width, height: 0.3, color: theme.focusColor,),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
