import 'package:flutter/material.dart';
import 'package:iExchange_it/src/elements/home_grid_widget_item.dart';

import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/route_argument.dart';

class ProductsGrid extends StatelessWidget {
 final List<Product>? products;

  ProductsGrid({this.products});

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var media = MediaQuery.of(context);

    final double itemHeight = (media.size.height - kToolbarHeight - 24) / 2.1;
    print("Item height is: $itemHeight");
    final double itemWidth = (media.size.width / 2);
    print(itemWidth / itemHeight);

    final double landscapeItemWidth = (media.size.width / 3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: products!.isEmpty
          ? Container(
              height: 50,
              child: Center(
                child: Text(
                  "No Item found",
                  style: textTheme.caption,
                ),
              ),
            )
          : GridView.count(
              childAspectRatio:
                  isPortrait ? (itemWidth / 251) : (landscapeItemWidth / 251),
              crossAxisCount: isPortrait ? 2 : 3,
              primary: false,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 10),
              children: List.generate(this.products!.length, (index) {
                Product product = this.products![index];
                return HomeGridWidgetItem(
                  product: product,
                  onTap: () {
                    Navigator.of(context).pushNamed("/ItemDetails",
                        arguments: RouteArgument(product: product));
                  },
                  onFav: () {},
                );
              }),
            ),
    );
  }
}
