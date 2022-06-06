// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iExchange_it/config/strings.dart';
import 'package:iExchange_it/src/controller/item_controller.dart';
import 'package:iExchange_it/src/elements/carousel_widget_item.dart';
import 'package:iExchange_it/src/elements/item_detials_image_slider.dart';
import 'package:iExchange_it/src/elements/product/review_item.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/review.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;
import 'package:global_configuration/global_configuration.dart';
import 'package:share/share.dart';


class ViewItemDetails extends StatefulWidget {
 final RouteArgument? args;

  ViewItemDetails({this.args});

  @override
  _ViewItemDetailsState createState() => _ViewItemDetailsState();
}

class _ViewItemDetailsState extends StateMVC<ViewItemDetails> {

  String? currentImage = '';
  ItemController? _con;

  _ViewItemDetailsState() : super(ItemController()) {
    _con = controller as ItemController?;
  }

  @override
  void initState() {
    _con!.product = widget.args!.product;
    _con!.isMine = widget.args!.isMine;
    userRepo.getCurrentUser().then((value) {
      _con!.currentUser = value;
      if(value.id.toString() == _con!.product!.userId.toString()) {
        _con!.isMine = true;
      }
    });
    _con!.getProductDetails();
    _con!.getProductReviews();
    _con!.getProductsByChildCategory(_con!.product!.childCategoryId);
    super.initState();
    _con!.initiateLocationController();
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;


    var format = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ');
    var dateTime = format.parse(_con!.product!.createdAt);
    var day = DateFormat('EEEE').format(dateTime);
    var time = DateFormat('hh:mm aa').format(dateTime);

    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    String endOfBid = "";
    bool endBidding = false;

    if(_con!.product!.biddingEnd != null && _con!.product!.biddingEnd.length > 0) {
      var biddingEndAt = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ").parse(
          _con!.product!.biddingEnd);
      endOfBid = DateFormat("dd-MM-yyyy").format(biddingEndAt);

      if(DateTime.now().millisecondsSinceEpoch >= biddingEndAt.millisecondsSinceEpoch) {
        endBidding = true;
      }

    }

    return WillPopScope(
      onWillPop: () async {
        if(_con!.showDeleteDialog) {
          setState((){
            _con!.showDeleteDialog = false;
          });
          return false;
        } else if (_con!.showImage) {
          setState((){
            _con!.showImage = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _con!.scaffoldKey,
        body: Container(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ItemDetailsImageSlider(con: _con, onTap: (int index){
                          setState((){
                            _con!.secondaryController = PageController(initialPage: index);
                            _con!.showImage = true;
                          });
                        },),
                        _appBar(),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: MediaQuery.of(context).size.width-20, bottom: !_con!.isMine ? 70 : 20),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              _con!.product!.user != null
                                  ? InkWell(
                                onTap: (){
                                  Navigator.of(context).pushNamed("/UserProfile",
                                      arguments: RouteArgument(user: _con!.product!.user));
                                },
                                    child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    CachedNetworkImage(
                                      imageUrl: _con!.product!.user!.image,
                                      imageBuilder: (ctx, provider) {
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            image: DecorationImage(
                                              image: provider,
                                              fit: BoxFit.fill
                                            )
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _con!.product!.user!.name,
                                            style: textTheme.headline4!.merge(TextStyle(color: theme.colorScheme.secondary)
                                            ),
                                          ),
                                          Text(
                                            "Posted $day at $time",
                                            style: textTheme.caption!.merge(
                                              TextStyle(fontSize: 10)
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              Navigator.of(context).pushNamed("/UserProfile",
                                                  arguments: RouteArgument(user: _con!.product!.user));
                                            },
                                            child: Text(
                                              "More Ads by this user",
                                              style: textTheme.subtitle1!
                                                  .merge(TextStyle(color: theme.colorScheme.secondary, decoration: TextDecoration.underline)
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){},
                                      icon: Icon(CupertinoIcons.forward),
                                    )
                                ],
                              ),
                                  )
                              : SizedBox(height: 0),
                              SizedBox(height: _con!.product!.user != null ? 15 : 0,),


                              _con!.product!.user != null ? Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),) : SizedBox(height: 0),
                              SizedBox(height: _con!.product!.user != null ? 20 : 0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(CupertinoIcons.eye, color: theme.focusColor, size: 12,),
                                      Text(" ${_con!.product!.viewsCount} Views ", style: textTheme.bodyText2,),
                                    ],
                                  ),
                                  SizedBox(width: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("PKR",
                                        style: textTheme.headline4!
                                            .merge(TextStyle(color: theme.colorScheme.secondary)),
                                      ),
                                      SizedBox(width: 5,),
                                      Text('${NumberFormat.compact().format(_con!.product!.price)}', style: textTheme.headline4),
                                    ],
                                  ),
                                  SizedBox(width: 15,),
                                  Text(
                                    _con!.product!.description,
                                    style: textTheme.bodyText2!
                                        .merge(TextStyle(fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),

                              _con!.product!.video != null && _con!.product!.video.toString().length > 0
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20,),
                                  Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                                  SizedBox(height: 20,),
                                  Text("Video",
                                    style: textTheme.headline4!
                                        .merge(TextStyle(color: theme.colorScheme.secondary)),
                                  ),
                                  SizedBox(width: 25,),
                                  InkWell(
                                    onTap: () async {
                                      if(await canLaunch(_con!.product!.video)) {
                                        launch(_con!.product!.video);
                                      }
                                    },
                                    child: Text(
                                      _con!.product!.video,
                                      style: textTheme.bodyText2!
                                          .merge(TextStyle(fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              )
                              : SizedBox(),

                              _con!.product!.bidding != null && _con!.product!.bidding == "1" || _con!.product!.bidding == 1
                              ? Column(
                                children: [
                                  SizedBox(height: 15,),
                                  Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(endBidding ? "Bidding Closed" : "Open for Bidding",
                                            style: textTheme.headline4!
                                                .merge(TextStyle(color: theme.accentColor)),
                                          ),
                                          SizedBox(height: 8,),
                                          Text(
                                            endBidding ? "Bidding ended on: $endOfBid" : "Bidding ends on: $endOfBid",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: textTheme.caption!
                                                .merge(TextStyle(fontWeight: FontWeight.w800)),
                                          ),
                                        ],
                                      ),
                                      _con!.isMine || endBidding
                                          ? SizedBox(width: 10)
                                          : RaisedButton(
                                        onPressed:(){
                                          Navigator.of(context).pushNamed("/PlaceBid",
                                              arguments: RouteArgument(product: _con!.product)
                                          );
                                        },
                                        color: theme.accentColor,
                                        child: Center(child: Text("Place Bid", style: textTheme.subtitle2),),
                                      )

                                    ],
                                  ),
                                ],
                              )
                              : SizedBox(height: 0),


                              SizedBox(height: 15,),
                              Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                              SizedBox(height: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Address",
                                    style: textTheme.headline4!
                                        .merge(TextStyle(color: theme.accentColor)),
                                  ),
                                  SizedBox(height: 8,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (_con!.product!.address ?? "") + ", " + (_con!.product!.city ?? "")+ ", " + (_con!.product!.country ?? ""),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: textTheme.caption!
                                        .merge(TextStyle(fontWeight: FontWeight.w800)),
                                      ),
                                      SizedBox(height: 15,),
                                      InkWell(
                                        onTap: () async {
                                            if (_con!.product!.latitude != null &&
                                                _con!.product!.longitude != null) {
                                              String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${_con!.product!.latitude},${_con!.product!.longitude}';
                                              if (await canLaunch(googleUrl)) {
                                                await launch(googleUrl);
                                              } else {
                                                showToast('Could not open the map.');
                                              }
                                            }
                                          },
                                          child: Container(
                                          height: 140,
                                          child: GoogleMap(
                                            mapType: MapType.normal,
                                            initialCameraPosition: CameraPosition(target: LatLng(40.7237765, -74.017617), zoom: 13.0),
                                            // markers: markers,s
                                            onTap: (pos) async {
                                              if (_con!.product!.latitude != null &&
                                                  _con!.product!.longitude != null) {
                                                String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${_con!.product!.latitude},${_con!.product!.longitude}';
                                                if (await canLaunch(googleUrl)) {
                                              await launch(googleUrl);
                                              } else {
                                              // showToast('Could not open the map.');
                                              }
                                            }
                                            },
                                            mapToolbarEnabled: false,
                                            zoomControlsEnabled: false,
                                            myLocationButtonEnabled: false,
                                            compassEnabled: false,
                                            markers: Set.from(_con!.allMarkers),
                                            onMapCreated: (GoogleMapController controller) {
                                              _con!.isMapCreated = true;
                                              _con!.mapController = controller;
                                              _con!.mapController.setMapStyle(_con!.mapStyle);
                                            },
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                              SizedBox(height: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(CupertinoIcons.collections, color: theme.accentColor,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Category",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                  .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(_con!.product!.category != null ? _con!.product!.category!.name : "",
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(CupertinoIcons.check_mark_circled, color: theme.accentColor,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Available for",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                      _con!.product!.type.toString().toUpperCase(),
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(CupertinoIcons.time, color: theme.accentColor,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Condition",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                      _con!.product!.condition == 0 ? "New" : "Used",
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // Icon(CupertinoIcons.settings, color: theme.accentColor,),
                                            SizedBox(width: 35,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(" ",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(" ",
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),


                              _con!.product!.attrs.length > 1
                                  ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                                  SizedBox(height: 20,),
                                  Text("More details", style: textTheme.subtitle1!
                                      .merge(TextStyle(color: theme.accentColor))),

                                  GridView.count(
                                    crossAxisCount: isPortrait ? 2 : 3,
                                    shrinkWrap: true,
                                      primary: false,
                                      childAspectRatio: 3,
                                    children: List.generate(
                                    _con!.product!.attrs.length,
                                            (index) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(_con!.product!.attrs[index].handler,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: textTheme.bodyText2!
                                                    .merge(TextStyle(fontWeight: FontWeight.w800)),
                                              ),
                                              Container(
                                                width: 100,
                                                margin: EdgeInsets.only(left: 5),
                                                child: Text(_con!.product?.attrs[index].valueToSend ?? "",
                                                    style: textTheme.caption
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                    ),
                                  ),


                                  SizedBox(height: 20,),

                                ],
                              )
                              : SizedBox(height: 0),



                              _con!.product!.type != null && _con!.product!.type.toString().toLowerCase() == EXCHANGE.toLowerCase()
                                  ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                                  SizedBox(height: 20,),
                                  Text("Looking to exchange with a Product with following properties", style: textTheme.subtitle1!
                                      .merge(TextStyle(color: theme.accentColor))),

                                  SizedBox(height: 20,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(CupertinoIcons.collections, color: theme.accentColor,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("From Category",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(_con!.product!.wishCategory != null ? _con!.product!.wishCategory!.name : "",
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.money, color: theme.accentColor,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Price Range",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                      _con!.product!.minPrice != null && _con!.product!.maxPrice != null ?
                                                      '${NumberFormat.compact().format(_con!.product!.minPrice)} - ${NumberFormat.compact().format(_con!.product!.maxPrice)}' : "",
                                                      // _con.product.type.toString().toUpperCase() ?? "",
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 15,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(CupertinoIcons.location, color: theme.accentColor,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Within City",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(_con!.product!.wishLocation != null ? _con!.product!.wishLocation : "",
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.map, color: theme.accentColor,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Distance Range",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                      '${_con!.product!.range.toString().toUpperCase()} KM',
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 15,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(CupertinoIcons.time, color: theme.accentColor,),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Condition",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                      _con!.product!.wishCondition.toString().toUpperCase(),
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // Icon(CupertinoIcons.settings, color: theme.accentColor,),
                                            SizedBox(width: 35,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(" ",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: textTheme.bodyText2!
                                                      .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(" ",
                                                      style: textTheme.caption
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),

                                  SizedBox(height: 5,),

                                  _con!.product!.wishAttrs.length > 1
                                      ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        // SizedBox(height: 20,),
                                        // Text("More details", style: textTheme.subtitle1
                                        //     .merge(TextStyle(color: theme.accentColor))),

                                        GridView.count(
                                          crossAxisCount: isPortrait ? 2 : 3,
                                          shrinkWrap: true,
                                          primary: false,
                                          childAspectRatio: 3,
                                          children: List.generate(
                                              _con!.product!.wishAttrs.length,
                                                  (index) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(_con!.product!.wishAttrs[index].handler,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: textTheme.bodyText2!
                                                          .merge(TextStyle(fontWeight: FontWeight.w800)),
                                                    ),
                                                    Container(
                                                      width: 100,
                                                      margin: EdgeInsets.only(left: 5),
                                                      child: Text(_con!.product?.wishAttrs[index].valueToSend ?? "",
                                                          style: textTheme.caption
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }
                                          ),
                                        ),

                                        SizedBox(height: 10,),
                                        
                                        // Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                                        //
                                        // SizedBox(height: 20,),

                                    ],
                                  ),
                                      )
                                      : SizedBox(height: 0),

                                ],
                              )
                                  : SizedBox(height: 0, width: 0),


                              _con!.product!.type != null && _con!.product!.type.toString().toLowerCase() == EXCHANGE.toLowerCase() && _con!.product!.relatedProducts.isNotEmpty
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15,),
                                  Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                                  SizedBox(height: 10),
                                  Text("Priority Products to Exchange", style: textTheme.subtitle1!
                                      .merge(TextStyle(color: theme.accentColor))),

                                  Container(
                                    height: 279,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _con!.product!.relatedProducts.length,
                                        // itemCount: 6,
                                        itemBuilder: (ctx, index) {
                                          Product item = _con!.product!.relatedProducts[index];
                                          // Product item = _con.product.relatedProducts[0];
                                          return CarouselWidgetItem(
                                            item: item,
                                            onTap: (){
                                              Navigator.of(context).pushNamed("/ItemDetails", arguments: RouteArgument(product: item));
                                            },
                                            showFavorite: false,
                                            onFav: (){
                                              // con.toggleFavorite(item);
                                            },);
                                        }
                                    ),
                                  )

                                ],
                              )
                                  : SizedBox(height: 0, width: 0),

                              _con!.catProducts.isEmpty
                                  ? SizedBox()
                                  : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(height: 15,),
                                  Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                                  SizedBox(height: 20,),
                                  Text("Relevant Ads", style: textTheme.subtitle1!
                                      .merge(TextStyle(color: theme.accentColor))),

                                  Container(
                                    height: 279,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _con!.catProducts.length,
                                        // itemCount: 6,
                                        itemBuilder: (ctx, index) {
                                          Product item = _con!.catProducts[index];
                                          // Product item = _con.product.relatedProducts[0];
                                          return CarouselWidgetItem(
                                            item: item,
                                            onTap: (){
                                              Navigator.of(context).pushNamed("/ItemDetails", arguments: RouteArgument(product: item));
                                            },
                                            showFavorite: false,
                                            onFav: (){
                                              // con.toggleFavorite(item);
                                            },);
                                        }
                                    ),
                                  ),

                                ],
                              ),

                              SizedBox(height: 15,),
                              Container(height: 0.4, color: theme.focusColor.withOpacity(0.5),),
                              SizedBox(height: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Ad Reviews",
                                        style: textTheme.headline6,
                                      ),

                                      InkWell(
                                        onTap: (){
                                          Navigator.of(context).pushNamed("/SeeReviews",
                                              arguments: RouteArgument(product: _con!.product, isEditingReview: true));
                                        },
                                        child: Text("leave review",
                                          style: textTheme.bodyText1!.merge(TextStyle(
                                              decoration: TextDecoration.underline
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),

                                  _con!.reviews.isEmpty
                                      ? Text("No reviews yet", style: textTheme.bodyText2,)
                                      : ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: _con!.reviews.length > 3 ? 3 : _con!.reviews.length,
                                    itemBuilder: (context, index) {

                                      Review review = _con!.reviews[index];

                                      bool isVisible = review.status == "1" || review.status == 1 || review.status == true;

                                      return isVisible || _con!.isMine
                                                ? ReviewItemWidget(
                                                    review: review,
                                                    onStatusChange: (){
                                                      _con!.changeReviewStatus(review);
                                                    },
                                                    showAction: _con!.isMine,
                                                  )
                                                : SizedBox(height: 0, width: 0);
                                          },
                                  ),

                                  _con!.reviews.isEmpty
                                    ? SizedBox(height: 0)
                                      : Center(
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.of(context).pushNamed("/SeeReviews", arguments: RouteArgument(product: _con!.product));
                                      },
                                      child: Text("See all (${_con!.isMine ? _con!.reviews.length : _con!.reviewsCount})",
                                        style: textTheme.subtitle2!.merge(TextStyle(
                                            decoration: TextDecoration.underline
                                        )),
                                      ),
                                    ),
                                  ),



                                ],
                              )
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              !_con!.isMine
                  ? Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 30,
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            theme.accentColor,
                            Colors.orangeAccent
                          ],
                          stops: [0.4, 0.8],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                      ),
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: IconButton(onPressed: (){

                        Navigator.of(context).pushNamed("/UserChat", arguments: RouteArgument(currentUser: _con!.currentUser,
                            user: _con!.product!.user, product: _con!.product));

                      }, icon: Icon(CupertinoIcons.conversation_bubble))),
                      Container(width: 0.3, height: 30, color: Colors.white,),
                      Expanded(flex: 1,
                          child: IconButton(onPressed: () async {
                            if(_con!.product!.user != null) {
                              if (await canLaunch("tel:${_con!.product!.user!.phone}")) {
                                await launch("tel:${_con!.product!.user!.phone}");
                              }
                            }
                          },
                              icon: Icon(CupertinoIcons.phone, semanticLabel: "Call",))),
                    ],
                  ),
                ),
              )
              : SizedBox(height: 0, width: 0),


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
                          child: Text("Delete Item", style: textTheme.subtitle2),
                        ),
                        Container(height: 0.3, color: theme.focusColor),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Are you sure you want to delete this Ad?", style: textTheme.bodyText1),
                        ),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: (){
                                _con!.deleteProduct();
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


              _con!.showImage
              ? Container(
                height: size.height,
                  width: size.width,
                color: Colors.black.withOpacity(0.8),
                child: Stack(
                  children: [
                    PageView.builder(
                        controller: _con!.secondaryController,
                        physics: PageScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        // itemCount: [con.item.image, con.item.image, con.item.image,].length,
                        itemCount: _con!.product!.images!.length,
                        onPageChanged: (index){
                          this.currentImage = _con!.product!.images![index].path;
                        },
                        itemBuilder: (context, index) {
                          return PinchZoom(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: CachedNetworkImage(
                                imageUrl: _con!.product!.images![index].path,
                              ),
                            ),
                            resetDuration: const Duration(seconds: 5),
                            maxScale: 5,
                            onZoomStart: (){print('Start zooming');},
                            onZoomEnd: (){print('Stop zooming');},
                          );
                          // return Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   height: MediaQuery.of(context).size.height,
                          //   child: CachedNetworkImage(
                          //     imageUrl: _con.product.images[index].path,
                          //   ),
                          // );
                        }
                    ),

                    Positioned(
                      top: MediaQuery.of(context).padding.top,
                      left: 0,
                      child: IconButton(
                        onPressed: (){
                          setState((){
                            _con!.showImage = false;
                          });
                        },
                        icon: Icon(CupertinoIcons.back, color: Colors.white,),
                      ),
                    )
                  ],
                ),
              )
              : SizedBox(height: 0),



              ///Loader
              _con!.isLoading
                  ? Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Please wait...",
                            style: Theme.of(context).textTheme.bodyText2)
                      ],
                    ),
                  ),
                ),
              )
                  : Positioned(bottom: 10, child: SizedBox(height: 0)),


            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: 58.0 + statusBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(CupertinoIcons.back),),
          Row(
            children: [

              IconButton(
                onPressed: (){
                  Share.share('Hi! I\'ve found this Ad on iExchangeIt.'
                      '\nCheck it out! ${GlobalConfiguration().getValue('base_url')}product/${_con!.product!.id}', subject: 'Look what I Found!');
                },
                icon: Icon(Icons.share, color: Colors.white),
              ),
              
              IconButton(
                onPressed: (){
                  _con!.toggleFavorite();
                },
                icon: Icon(
                    _con!.product!.isFavorite ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
                    color: _con!.product!.isFavorite ? Colors.redAccent : Colors.white,
                ),
              ),

              _con!.isMine
                  ? IconButton(
                onPressed: (){
                  setState((){
                    _con!.showDeleteDialog = true;
                  });
                },
                icon: Icon(CupertinoIcons.trash_fill),
              )
                  : SizedBox(height: 0, width: 0),

              _con!.isMine
                  ? IconButton(
                onPressed: (){
                  Navigator.of(context).pushNamed("/EditProduct", arguments: RouteArgument(product: _con!.product)).then((value) {
                    if(value != null) {
                      if(value as bool) {
                        _con!.getProductDetails();
                      }
                    }
                  });
                },
                icon: Icon(Icons.edit),
              )
                  : SizedBox(height: 0, width: 0),

            ],
          )
        ],
      ),
    );
  }

}
