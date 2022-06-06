import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/config/strings.dart';

import 'package:iExchange_it/config/app_config.dart' as config;
import 'package:iExchange_it/src/models/product.dart';
import 'package:intl/intl.dart';

class HomeGridWidgetItem extends StatelessWidget {
 final Product? product;
 final VoidCallback? onTap;
 final VoidCallback? onFav;

  HomeGridWidgetItem({this.product, this.onFav, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return InkWell(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 4.0),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: product!.images != null && product!.images!.length > 0 ? product!.images![0].path : "https://dealerson-hold.com/wp-content/uploads/2019/02/placeholder.jpg",
                  memCacheWidth: 140,
                  memCacheHeight: 140,
                  imageBuilder: (context, imgProvider) {
                    return Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                          image: DecorationImage(
                              image: imgProvider,
                              fit: BoxFit.cover,
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
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5)),
                                color: (product!.type.toString().toLowerCase() == FREE_TYPE || product!.type.toString().toLowerCase() == FREE.toLowerCase())
                                    ? Colors.greenAccent
                                    : (product!.type.toString().toLowerCase() == SALE_TYPE || product!.type.toString().toLowerCase() == SALE.toLowerCase())
                                    ? Colors.cyanAccent
                                    : Colors.limeAccent,
                              ),
                              child: Text(
                                product!.type.toString().toUpperCase(),
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
                Container(
                  height: 141,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            theme.primaryColor.withOpacity(0.0),
                            theme.primaryColor.withOpacity(0.6),
                            theme.primaryColor.withOpacity(1),
                          ],
                          stops: [0.2, 0.7, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product!.condition.toString().toUpperCase(),
                            style: textTheme.bodyText2!.merge(TextStyle(fontSize: 11, color: Colors.white)),
                          ),
                          InkWell(
                            onTap: this.onFav,
                            child: Icon(
                              product!.isFavorite ? Icons.favorite : Icons.favorite_border,
                              // Icons.favorite_border,
                              size: 20,
                              color: config.Colors().favoriteColor(1),
                            ),
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
                  Text(
                    product!.name ?? "",
                    style: textTheme.subtitle2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // StarRating(rating: item.rating, size: 14,),
                      Text(
                        "PKR ${product!.price != null ? NumberFormat.compact().format(product!.price) : "0"}",
                        style: textTheme.subtitle1!.merge(TextStyle(color: Color(0xFFFED766))),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: theme.focusColor,
                      ),
                      SizedBox(width: 5,),
                      Flexible(
                        child: Text(
                          '${product!.city??" "}, ${product!.country??" "}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyText2!.merge(TextStyle(fontSize: 11)),
                        ),
                      ),
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
