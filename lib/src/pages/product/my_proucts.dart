import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/my_product_controller.dart';
import 'package:iExchange_it/src/elements/home_grid_widget_item.dart';
import 'package:iExchange_it/src/elements/shimmer/grid_product_shimmer_list.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MyProductsWidget extends StatefulWidget {
 final RouteArgument? argument;
  MyProductsWidget({this.argument});

  @override
  _MyProductsWidgetState createState() => _MyProductsWidgetState();
}

class _MyProductsWidgetState extends StateMVC<MyProductsWidget> {

  MyProductController? _con;

  _MyProductsWidgetState() : super(MyProductController()) {
    _con = controller as MyProductController?;
  }

  @override
  void initState() {
    _con!.getMyProducts();
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
        title: Text("My Products", style: textTheme.headline6, ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: theme.colorScheme.secondary),
          onPressed: (){
              Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            _con!.isLoadingProducts
                ? GridProductShimmerList()
                : _con!.products.isEmpty
            ? Container(
              height: 100,
              child: Center(
                child: Text(
                  "No Product found...",
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
                    _con!.products.length, (index) {
                  Product product =
                  _con!.products[index];
                  return HomeGridWidgetItem(
                    product: product,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          "/ItemDetails",
                          arguments: RouteArgument(
                              product: product, isMine: true)).then((value) {
                                _con!.getMyProducts();
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
