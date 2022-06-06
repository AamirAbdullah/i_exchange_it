import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/bid.dart';
import 'package:intl/intl.dart';

class BitItemWidget extends StatelessWidget {

 final Bid bid;
 final String text;
 final VoidCallback onProductTap;
 final VoidCallback onProfileTap;

  BitItemWidget({required this.text, required this.bid, required this.onProductTap, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var format = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ');
    var dateTime = format.parse(bid.createdAt);
    var day = DateFormat('EEEE').format(dateTime);
    var dayOfMonth = DateFormat('dd').format(dateTime);
    var month = DateFormat('MMM').format(dateTime);
    var time = DateFormat('hh:mm aa').format(dateTime);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: theme.focusColor,
                blurRadius: 5,
                offset: Offset(0, 0)
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10,),

          Text("Offer Details", style: textTheme.headline6,),
          SizedBox(height: 5,),
          Text('$day ${dayOfMonth}th, $month at $time', style: textTheme.caption,),

          SizedBox(height: 10,),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 0.3, color: theme.colorScheme.secondary)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(this.text, style: textTheme.subtitle2,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bid Price: ", style: textTheme.bodyText1,),
                        Text("Comment/Message: ", style: textTheme.bodyText1,),
                      ],
                    ),
                    SizedBox(width: 7,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${bid.price}", style: textTheme.bodyText1,),
                          Text("${bid.message}",
                            style: textTheme.bodyText1,),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),

                bid.user != null
                    ? InkWell(
                  onTap: this.onProfileTap,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sent by: ", style: textTheme.subtitle1,),
                          SizedBox(height: 7),
                          Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    bid.user!.image != null ?
                          CachedNetworkImage(
                            imageUrl: bid.user!.image,
                            imageBuilder: (ctx, provider) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                        image: provider,
                                        fit: BoxFit.fill
                                    )
                                ),
                              );
                            },
                          )
                        : Image.asset("assets/placeholders/profile.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill),
                          SizedBox(width: 15,),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bid.user!.name ?? "Unknown",
                                  style: textTheme.subtitle2,
                                ),
                                Text(
                                  "Bid Placed $day at $time",
                                  style: textTheme.caption!.merge(
                                      TextStyle(fontSize: 10)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: this.onProfileTap,
                            icon: Icon(CupertinoIcons.forward, size: 18,),
                          )
                  ],
                ),
                          SizedBox(height: 7),
                        ],
                      ),
                    )
                    : SizedBox(height: 0),

              ],
            ),
          ),

          InkWell(
            onTap: this.onProductTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: theme.focusColor,
                        blurRadius: 1,
                        offset: Offset(0, 0)
                    )
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Product Details",
                    style: textTheme.subtitle2!
                        .merge(TextStyle(
                      color: theme.colorScheme.secondary,
                    )),),
                  SizedBox(height: 10,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${bid.product!.name}", style: textTheme.bodyText1,),
                        SizedBox(height: 5,),
                        Text("${bid.product!.description}",
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyText2,),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Text("${bid.product!.city}, ", style: textTheme.caption,),
                            Text("${bid.product!.country}", style: textTheme.caption,),
                          ],
                        )

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          SizedBox(height: 7,),

        ],
      ),
    );
  }
}
