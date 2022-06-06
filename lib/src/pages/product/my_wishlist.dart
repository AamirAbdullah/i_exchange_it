import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/wishlist_controller.dart';
import 'package:iExchange_it/src/elements/CircularLoadingWidget.dart';
import 'package:iExchange_it/src/elements/wishlist_item.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:iExchange_it/src/models/wishlist_got.dart';

import 'package:mvc_pattern/mvc_pattern.dart';

class MyWishlistWidget extends StatefulWidget {
 final RouteArgument? argument;

  MyWishlistWidget({this.argument});

  @override
  _MyWishlistWidgetState createState() => _MyWishlistWidgetState();
}

class _MyWishlistWidgetState extends StateMVC<MyWishlistWidget> {

  WishlistController? _con;

  _MyWishlistWidgetState() : super(WishlistController()) {
    _con = controller as WishlistController?;
  }

  @override
  void initState() {
    _con!.getMyWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if(_con!.showDeleteDialog) {
          setState((){
            _con!.showDeleteDialog = false;
          });
          return false;
        }
        else {
          return !_con!.isLoading;
        }
      },
      child: Scaffold(
        key: _con!.scaffoldKey,
        appBar: AppBar(
          title: Text("My Wishlist", style: textTheme.headline6, ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: theme.colorScheme.secondary),
            onPressed: (){
              if(_con!.showDeleteDialog) {
                setState((){
                  _con!.showDeleteDialog = false;
                });
                
              }
              else if(!_con!.isLoading) {
                Navigator.of(context).pop();
              }
            },
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [

                  _con!.isLoading && _con!.wishlists.isEmpty
                      ? CircularLoadingWidget(
                          height: 100,
                        )
                      : _con!.wishlists.isEmpty
                          ? Container(
                              width: size.width,
                              height: size.height,
                              child: Center(
                                child: Text(
                                  "Nothing to show",
                                  style: textTheme.caption,
                                ),
                              ),
                            )
                          : ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: _con!.wishlists.length,
                              itemBuilder: (context, index) {
                                WishlistGot wish = _con!.wishlists[index];

                                return WishlistItemWidget(
                                  wish: wish,
                                  onDelete: () {
                                    _con!.promptToDelete(wish);
                                  },
                                );

                              },
                            )
                ],
              ),
            ),

            _con!.showDeleteDialog
                ? Container(
              height: size.height,
              width: size.width,
              color: theme.scaffoldBackgroundColor.withOpacity(0.8),
              child: Center(
                child: Container(
                  height: 150,
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: theme.focusColor,
                            offset: Offset(0.1, 0.1),
                            blurRadius: 3
                        )
                      ]
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Remove Item", style: textTheme.subtitle2),
                      ),
                      Container(height: 0.3, color: theme.focusColor),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Are you sure you want to remove this from Wishlist?", style: textTheme.bodyText1),
                      ),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: (){
                                _con!.deleteItemFromWishlist();
                              },
                              child: Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: theme.scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: [
                                        BoxShadow(
                                            color: theme.focusColor,
                                            offset: Offset(0.1, 0.1),
                                            blurRadius: 3
                                        )
                                      ]
                                  ),
                                  child: Center(child: Text("YES", style: textTheme.bodyText2))
                              )
                          ),
                          InkWell(
                              onTap: (){
                                setState((){
                                  _con!.toDelete = null;
                                  _con!.showDeleteDialog = false;
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: theme.scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: [
                                        BoxShadow(
                                            color: theme.focusColor,
                                            offset: Offset(0.1, 0.1),
                                            blurRadius: 3
                                        )
                                      ]
                                  ),
                                  child: Center(child: Text("NO", style: textTheme.bodyText2))
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
                : SizedBox(height: 0, width: 0),
          ],
        ),
      ),
    );
  }
}
