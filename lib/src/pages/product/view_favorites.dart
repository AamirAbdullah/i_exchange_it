import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/item_controller.dart';
import 'package:iExchange_it/src/elements/home_grid_widget_item.dart';
import 'package:iExchange_it/src/elements/shimmer/grid_product_shimmer_list.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class FavoritesListWidget extends StatefulWidget {
 final RouteArgument? argument;

  FavoritesListWidget({this.argument});

  @override
  _FavoritesListWidgetState createState() => _FavoritesListWidgetState();
}

class _FavoritesListWidgetState extends StateMVC<FavoritesListWidget> {
  ItemController? _con;

  _FavoritesListWidgetState() : super(ItemController()) {
    _con = controller as ItemController?;
  }

  @override
  void initState() {
    _con!.getFavoriteProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;


    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final double itemWidth = (size.width / 2);
    final double landscapeItemWidth =  (size.width / 3);

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Favorites", style: textTheme.headline6, ),
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(CupertinoIcons.back),),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            _con!.isLoadingProducts
                ? GridProductShimmerList()
                : _con!.favorites.isEmpty
                ? Container(
              height: 100,
              child: Center(
                child: Text(
                  "Nothing in Favorites...",
                  style: textTheme.caption,
                ),
              ),
            )
                : Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 5),
              child: GridView.count(
                childAspectRatio: isPortrait
                    ? (itemWidth / 251)
                    : (landscapeItemWidth / 251),
                crossAxisCount: isPortrait ? 2 : 3,
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10),
                children: List.generate(
                    _con!.favorites.length, (index) {
                  Product product =
                  _con!.favorites[index];
                  return HomeGridWidgetItem(
                    product: product,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          "/ItemDetails",
                          arguments: RouteArgument(
                              product: product)).then((value) {
                        _con!.getFavoriteProducts();
                      });
                    },
                    onFav: () {
                      _con!.toggleFavoriteById(product);
                    },
                  );
                }),
              ),
            )

          ],
        ),
      ),
    );
  }
}
