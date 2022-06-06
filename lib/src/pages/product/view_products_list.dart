import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/home_controller.dart';
import 'package:iExchange_it/src/elements/product/other_products_grid.dart';
import 'package:iExchange_it/src/elements/shimmer/grid_product_shimmer_list.dart';
import 'package:iExchange_it/src/models/sorting_type.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/elements/recent_items_grid.dart';
import 'package:iExchange_it/src/models/route_argument.dart';

class ViewProductsListWidget extends StatefulWidget {
 final RouteArgument? argument;

  ViewProductsListWidget({this.argument});

  @override
  _ViewProductsListWidgetState createState() => _ViewProductsListWidgetState();
}

class _ViewProductsListWidgetState extends StateMVC<ViewProductsListWidget> {
  HomeController? _con;

  _ViewProductsListWidgetState() : super(HomeController()) {
    _con = controller as HomeController?;
  }

  @override
  void initState() {
    _con!.showRecent = widget.argument!.showRecent;
    if (_con!.showRecent) {
      _con!.getRecentProductsSort();
    } else if (widget.argument!.showFeatured) {
      _con!.getFeaturedProductsSort();
    } else if (widget.argument!.showPopular) {
      _con!.getPopularProductsSort();
    } else if (widget.argument!.showProductsByFollow) {
      _con!.getFollowedUsersProducts();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text(
          _con!.showRecent
              ? "Recent Products"
              : widget.argument!.showFeatured
                  ? "Featured Products"
                  : "Popular",
          style: textTheme.headline6,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(CupertinoIcons.back),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _con!.showSortDialog = true;
              });
            },
            icon: Column(
              children: [
                Icon(
                  Icons.filter_list,
                  color: theme.colorScheme.secondary,
                ),
                Text(
                  "Sort",
                  style: textTheme.caption!
                      .merge(TextStyle(color: theme.colorScheme.secondary)),
                )
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            children: [
              _con!.isLoading
                  ? GridProductShimmerList()
                  : widget.argument!.showRecent
                      ? _con!.recentProducts.isEmpty
                          ? Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  "No product found",
                                  style: textTheme.caption,
                                ),
                              ),
                            )
                          : RecentItemsGrid(
                              con: _con,
                            )
                      : widget.argument!.showFeatured
                          ? _con!.featuredProducts.isEmpty
                              ? Container(
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      "No product found",
                                      style: textTheme.caption,
                                    ),
                                  ),
                                )
                              : OtherItemsGrid(
                                  con: _con,
                                  products: _con!.featuredProducts,
                                )
                          : widget.argument!.showProductsByFollow
                              ? _con!.followingsProducts.isEmpty
                                  ? Container(
                                      height: 100,
                                      child: Center(
                                        child: Text(
                                          "No product found",
                                          style: textTheme.caption,
                                        ),
                                      ),
                                    )
                                  : OtherItemsGrid(
                                      con: _con,
                                      products: _con!.followingsProducts,
                                    )
                              : SizedBox(),
            ],
          )),
          _con!.showSortDialog
              ? Container(
                  height: size.height,
                  width: size.width,
                  color: theme.scaffoldBackgroundColor.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      height: 320,
                      width: 220,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: theme.focusColor,
                                offset: Offset(0.1, 0.1),
                                blurRadius: 3)
                          ]),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Sort by",
                              style: textTheme.headline6,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 170,
                              height: 0.5,
                              color: theme.focusColor,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                                mainAxisSize: MainAxisSize.min,
                                children: _con!.sortingTypes.map((sortField) {
                                  final field = sortField;

                                  return InkWell(
                                    onTap: () {
                                      _con!.sortProducts(field);
                                    },
                                    child: IgnorePointer(
                                      child: RadioListTile<SortingType>(
                                        dense: true,
                                        title: Text(field.name),
                                        subtitle: _con!.selectedType == field
                                            ? Text(_con!.isAscending
                                                ? "Ascending"
                                                : "Descending")
                                            : null,
                                        groupValue: _con!.selectedType,
                                        activeColor:
                                            Theme.of(context).colorScheme.secondary,
                                        onChanged: (SortingType? value) {
                                          // if(_con.selectedType.name == field.name) {
                                          //   setState(() {
                                          //     _con.isAscending = !_con.isAscending;
                                          //   });
                                          // } else {
                                          //   setState(() {
                                          //     _con.selectedType = field;
                                          //     _con.isAscending = true;
                                          //   });
                                          // }
                                        },
                                        value: field,
                                        toggleable: true,
                                      ),
                                    ),
                                  );
                                }).toList()),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Positioned(
                  bottom: 0,
                  child: SizedBox(
                    height: 0,
                    width: 0,
                  ),
                )
        ],
      ),
    );
  }
}
