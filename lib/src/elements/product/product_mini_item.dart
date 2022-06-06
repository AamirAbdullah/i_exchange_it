import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/product.dart';

class ProductMiniItem extends StatelessWidget {

 final Product? product;
 final VoidCallback? onTap;

  ProductMiniItem({this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return InkWell(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: theme.focusColor)
        ),
        child: Row(
          children: [

            Container(
              height: 60,
              width: 60,
              child: product!.images != null && product!.images!.length > 0
                  ? CachedNetworkImage(
                imageUrl: product!.images![0].path,
                fit: BoxFit.cover,
              )
                  : Image.asset("assets/placeholders/image.jpg", fit: BoxFit.cover,)
              ,
            ),

            SizedBox(width: 10,),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.subtitle2,),
                  SizedBox(height: 7),
                  Text(product!.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyText2,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
