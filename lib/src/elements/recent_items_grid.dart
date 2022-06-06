import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/home_controller.dart';
import 'package:iExchange_it/src/elements/home_grid_widget_item.dart';

import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/route_argument.dart';

class RecentItemsGrid extends StatelessWidget {
  final HomeController? con;

  RecentItemsGrid({this.con});

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var media = MediaQuery.of(context);

    final double itemHeight = (media.size.height - kToolbarHeight - 24) / 2.1;
    print("Item height is: $itemHeight");
    final double itemWidth = (media.size.width / 2);
    print(itemWidth / itemHeight);

    final double landscapeItemWidth = (media.size.width / 3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GridView.count(
        childAspectRatio:
            isPortrait ? (itemWidth / 251) : (landscapeItemWidth / 251),
        crossAxisCount: isPortrait ? 2 : 3,
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 10),
        children: List.generate(con!.recentProducts.length, (index) {
          Product product = con!.recentProducts[index];
          return HomeGridWidgetItem(
            product: product,
            onTap: () {
              Navigator.of(context).pushNamed("/ItemDetails",
                  arguments: RouteArgument(product: product));
            },
            onFav: () {
              con!.toggleFavorite(product);
            },
          );
        }),
      ),
    );
  }
}
