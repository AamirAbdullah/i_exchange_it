import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/config/strings.dart';

import 'package:iExchange_it/config/app_config.dart' as config;
import 'package:iExchange_it/src/models/product.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CarouselWidgetItem extends StatelessWidget {

 final Product? item;
 final VoidCallback? onTap;
 final VoidCallback? onFav;

  bool showFavorite = true;

  CarouselWidgetItem({this.item, this.onTap, this.showFavorite = true, this.onFav});


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return InkWell(
      onTap: this.onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: item!.images != null && item!.images!.length > 0
                  ? item!.images![0].path
                  : "http://via.placeholder.com/300",
              memCacheWidth: 140,
              memCacheHeight: 140,
              fit: BoxFit.cover,
              imageBuilder: (context, imgProvider) {
                return Container(
                  height: 140,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imgProvider,
                          fit: BoxFit.cover
                      )
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: item!.type.toString().toLowerCase() == FREE_TYPE
                                ? Colors.greenAccent
                                : item!.type.toString().toLowerCase() == SALE_TYPE
                                ? Colors.cyanAccent
                                : Colors.limeAccent,
                          ),
                          child: Text(
                            item!.type.toString().toUpperCase(),
                            style: textTheme.bodyText2!
                                .merge(TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 11
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                      Text(
                        item!.condition.toString().toUpperCase(),
                        style: textTheme.bodyText2!.merge(TextStyle(fontSize: 11)),
                      ),
                      this.showFavorite
                          ? InkWell(
                        onTap: this.onFav,
                        child: Icon(
                          item!.isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: config.Colors().favoriteColor(1),
                        ),
                      )
                          : SizedBox(height: 0, width: 0),
                    ],
                  ),
                  SizedBox(height: 2,),
                  Text(
                    item!.name.toString(),
                    style: textTheme.subtitle2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3,),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: theme.focusColor,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        item!.city,
                        style: textTheme.bodyText2!.merge(TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item!.country,
                        style: textTheme.bodyText2!.merge(TextStyle(fontSize: 11)),
                      )
                      // StarRating(rating: item.rating, size: 14,),
                      // Text(
                      //   '(${item.totalReviews})',
                      //   style: textTheme.bodyText2.merge(TextStyle(fontSize: 12)),
                      // )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "PKR ${NumberFormat.compact().format(item!.price)}",
                    style: textTheme.subtitle1!.merge(TextStyle(color: Color(0xFFFED766))),
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
