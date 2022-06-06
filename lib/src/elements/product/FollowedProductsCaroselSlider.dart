import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/home_controller.dart';
import 'package:iExchange_it/src/elements/carousel_widget_item.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/route_argument.dart';

class FollowedProductsCarouselSlider extends StatelessWidget {

 final HomeController? con;

  FollowedProductsCarouselSlider({this.con});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 301,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: con!.followingsProducts.length,
          itemBuilder: (ctx, index) {
            Product item = con!.followingsProducts[index];
            return CarouselWidgetItem(
              item: item,
              onTap: (){
                Navigator.of(context).pushNamed("/ItemDetails", arguments: RouteArgument(product: item));
              },
              onFav: (){
                con!.toggleFavorite(item);
              },);
          }
      ),
    );
  }
}
