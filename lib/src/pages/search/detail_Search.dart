import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iExchange_it/src/controller/search_controller.dart';
import 'package:iExchange_it/src/elements/home_grid_widget_item.dart';
import 'package:iExchange_it/src/elements/search/searchSortBottomFeild.dart';
import 'package:iExchange_it/src/elements/search/search_filter_bottom_sheet.dart';
import 'package:iExchange_it/src/elements/shimmer/grid_product_shimmer_list.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/category2.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:iExchange_it/src/pages/search/search_design.dart';
import 'package:iExchange_it/src/repository/search_repository.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;
import 'package:mvc_pattern/mvc_pattern.dart';

class DetailSearch extends StatefulWidget {
  final RouteArgument? argument;
  final int id;
  final String? searchtext;
  const DetailSearch(
      {Key? key, this.argument, required this.id, this.searchtext})
      : super(key: key);

  @override
  _DetailSearchState createState() => _DetailSearchState();
}
List<CategorySearch> categorys = [];

class _DetailSearchState extends StateMVC<DetailSearch> {
  SearchController? _con;
  var i;
  // var location = loc.Location();
  // loc.PermissionStatus _status;
  LocationPermission? _status;
  List<Category>? cat;
  _DetailSearchState() : super(SearchController()) {
    _con = controller as SearchController?;
  }
  @override
  void initState() {
    userRepo.getCurrentUser().then((user) {
      setState(() {
        _con!.currentUser = user;
      });
    });
    searchbycategory(searchtext: widget.searchtext, categoryid: widget.id);
    _con!.getCategories();

    super.initState();
    _con!.overlayState = Overlay.of(context);
     

    // location.hasPermission()
    //     .then(_updateStatus);
    Geolocator.checkPermission().then(_updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double itemWidth = (size.width / 2);
    final double landscapeItemWidth = (size.width / 3);


    return WillPopScope(
        onWillPop: () async {
          if (_con!.isSuggestionsDropDownOpened) {
            _con!.removeOverlay();
            return false;
          }
          return true;
        },
        child: Scaffold(
            key: _con!.scaffoldKey,
            // resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            body: Container(
              padding: EdgeInsets.only(right: 10),
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: statusBarHeight,
                    ),
                    Container(
                      key: _con!.searchFieldKey,
                      color: theme.scaffoldBackgroundColor,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (_con!.isSuggestionsDropDownOpened) {
                                _con!.removeOverlay();
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                CupertinoIcons.back,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      style: textTheme.bodyText1!.merge(
                                          TextStyle(
                                              color: theme.primaryColorDark)),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search here...",
                                        hintStyle: textTheme.bodyText1!.merge(
                                            TextStyle(color: theme.hintColor)),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    // onTap: () {
                                    //   if (_con!.isSuggestionsDropDownOpened) {
                                    //     _con!.removeOverlay();
                                    //   }
                                    //   _con!.searchNow();
                                    // },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        CupertinoIcons.search,
                                        color: theme.primaryColorDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showSearchSortBottomSheet(context, _con);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    CupertinoIcons.add,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  Text(
                                    "SORT",
                                    style: textTheme.caption!.merge(TextStyle(
                                        color: theme.colorScheme.secondary)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showSearchFiltersBottomSheet(context, _con);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.filter_list,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  Text(
                                    "Filters",
                                    style: textTheme.caption!.merge(TextStyle(
                                        color: theme.colorScheme.secondary)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _con!.onlyWithBidding =
                                          !_con!.onlyWithBidding;
                                    });
                                    _con!.filterWithBiddingPicturesAndVideos();
                                  },
                                  icon: Icon(
                                    _con!.onlyWithBidding
                                        ? CupertinoIcons
                                            .check_mark_circled_solid
                                        : CupertinoIcons.circle,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                      child: Text(
                                    "Only with bidding",
                                    style: textTheme.bodyText2!.copyWith(
                                        color: theme.colorScheme.secondary),
                                  )),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _con!.onlyWithPictures =
                                          !_con!.onlyWithPictures;
                                    });
                                    _con!.filterWithBiddingPicturesAndVideos();
                                  },
                                  icon: Icon(
                                    _con!.onlyWithPictures
                                        ? CupertinoIcons
                                            .check_mark_circled_solid
                                        : CupertinoIcons.circle,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                      child: Text(
                                    "Only with Pictures",
                                    style: textTheme.bodyText2!.copyWith(
                                        color: theme.colorScheme.secondary),
                                  )),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _con!.onlyWithVideos =
                                          !_con!.onlyWithVideos;
                                    });
                                    _con!.filterWithBiddingPicturesAndVideos();
                                  },
                                  icon: Icon(
                                    _con!.onlyWithVideos
                                        ? CupertinoIcons
                                            .check_mark_circled_solid
                                        : CupertinoIcons.circle,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                      child: Text(
                                    "Only with videos",
                                    style: textTheme.bodyText2!.copyWith(
                                        color: theme.colorScheme.secondary),
                                  )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                // Container(
                //     height: (size.height - statusBarHeight - 55 - 50),
                //     child: SingleChildScrollView(
                //       child: Column(
                //         children: [
                //           _con!.isSearching
                //               ? GridProductShimmerList()
                //               : _con!.searchComplete &&
                //                       _con!.searchedProducts.isEmpty
                //                   ? Container(
                //                       height: 100,
                //                       child: Center(
                //                         child: Text(
                //                           "No results found...",
                //                           style: textTheme.caption,
                //                         ),
                //                       ),
                //                     ):
                //                    Padding(
                //                       padding: const EdgeInsets.symmetric(
                //                           horizontal: 5),
                //                       child: GridView.count(
                //                         childAspectRatio: isPortrait
                //                             ? (itemWidth / 251)
                //                             : (landscapeItemWidth / 251),
                //                         crossAxisCount: isPortrait ? 2 : 3,
                //                         primary: false,
                //                         shrinkWrap: true,
                //                         padding:
                //                             EdgeInsets.symmetric(vertical: 10),
                //                         children: List.generate(
                //                             _con!.searchedProducts.length,
                //                             (index) {
                //                           Product product =
                //                               _con!.searchedProducts[index];
                //                           return HomeGridWidgetItem(
                //                             product: product,
                //                             onTap: () {
                //                               Navigator.of(context).pushNamed(
                //                                   "/ItemDetails",
                //                                   arguments: RouteArgument(
                //                                       product: product));
                //                             },
                //                             onFav: () {},
                //                           );
                //                         }),
                //                       ),
                //                     ),
                //
                //         ],
                //       ),
                //     ),
                //   ),

                    ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: categorys.length,
                        itemBuilder: (BuildContext context, int index)
                        =>SearchDesign(categorySearch:categorys[index],
                        )),



                  ],
                ),
              ),
            )));
  }

  showSearchFiltersBottomSheet(
      BuildContext context, SearchController? _oldCon) {
    var theme = Theme.of(context);

    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: theme.primaryColorDark,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, setModalState) {
            return SearchFilterBottomSheetWidget(
              con: _oldCon,
            );
          });
        }).then((value) {
      if (value != null) {
        var _newCon = value as SearchController;
        setState(() {
          if (_newCon.applyFilter) {
            _con!.categories = _newCon.categories;
            _con!.subCats = _newCon.subCats;
            _con!.childCats = _newCon.childCats;
            _con!.selectedCat = _newCon.selectedCat;
            _con!.selectedSubCat = _newCon.selectedSubCat;
            _con!.selectedChildCat = _newCon.selectedChildCat;
            _con!.catDropdownMenuItems = _newCon.catDropdownMenuItems;
            _con!.subCatDropdownMenuItems = _newCon.subCatDropdownMenuItems;
            _con!.childCatDropdownMenuItems = _newCon.childCatDropdownMenuItems;
            _con!.itemTypeDropdownMenuItems = _newCon.itemTypeDropdownMenuItems;

            _con!.loc = _newCon.loc;
            _con!.condition = _newCon.condition;
            _con!.minPriceController = _newCon.minPriceController;
            _con!.maxPriceController = _newCon.maxPriceController;
            _con!.applyFilter = _newCon.applyFilter;
            _con!.selectedItemType = _newCon.selectedItemType;
            _con!.selectedCondition = _newCon.selectedCondition;
            _con!.minPrice = _newCon.minPrice;
            _con!.maxPrice = _newCon.maxPrice;

            _con!.attributes = _newCon.attributes;
            _con!.attrs = _newCon.attrs;
          }
        });
      }
    });
  }

  showSearchSortBottomSheet(BuildContext context, SearchController? _oldCon) {
    var theme = Theme.of(context);

    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: theme.primaryColorDark,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (ctx, setModalState) {
            return SearchSortBottomSheet(
              con: _oldCon,
            );
          });
        }).then((value) {
      if (value != null) {
        var _newCon = value as SearchController;
        setState(() {
          if (_newCon.applyFilter) {
            _con!.categories = _newCon.categories;
            _con!.subCats = _newCon.subCats;
            _con!.childCats = _newCon.childCats;
            _con!.selectedCat = _newCon.selectedCat;
            _con!.selectedSubCat = _newCon.selectedSubCat;
            _con!.selectedChildCat = _newCon.selectedChildCat;
            _con!.catDropdownMenuItems = _newCon.catDropdownMenuItems;
            _con!.subCatDropdownMenuItems = _newCon.subCatDropdownMenuItems;
            _con!.childCatDropdownMenuItems = _newCon.childCatDropdownMenuItems;
            _con!.itemTypeDropdownMenuItems = _newCon.itemTypeDropdownMenuItems;

            _con!.loc = _newCon.loc;
            _con!.condition = _newCon.condition;
            _con!.minPriceController = _newCon.minPriceController;
            _con!.maxPriceController = _newCon.maxPriceController;
            _con!.applyFilter = _newCon.applyFilter;
            _con!.selectedItemType = _newCon.selectedItemType;
            _con!.selectedCondition = _newCon.selectedCondition;
            _con!.minPrice = _newCon.minPrice;
            _con!.maxPrice = _newCon.maxPrice;

            _con!.attributes = _newCon.attributes;
            _con!.attrs = _newCon.attrs;
          }
        });
      }
    });
  }

  // void _updateStatus(loc.PermissionStatus status) async {
  void _updateStatus(LocationPermission status) async {
    if (_status != status) {
      setState(() {
        _status = status;
      });
      //Check if user location turned On or not
      //then call this function
      _checkLocationServiceStatus();
    } else {
      _askPermission();
    }
  }

  void _askPermission() {
    // if (_status == null) {
    //   location.requestPermission().then((status) {
    //     if(status == loc.PermissionStatus.granted) {
    //       setState(() {
    //         _status = status;
    //       });
    //       _checkLocationServiceStatus();
    //     } else {
    //       //Start activity to ask to enter it manually
    //       _askPermission();
    //     }
    //   });
    // }
    if (_status == null) {
      Geolocator.requestPermission().then((status) {
        if (status == LocationPermission.always ||
            status == LocationPermission.whileInUse) {
          setState(() {
            _status = status;
          });
          _checkLocationServiceStatus();
        } else {
          //Start activity to ask to enter it manually
          _askPermission();
        }
      });
    }
  }

  void _checkLocationServiceStatus() async {
    // if(await location.serviceEnabled())
    // {
    //   _con.getUserLocation();
    // }
    // else
    // {
    //   if(await location.requestService())
    //   {
    //     _con.getUserLocation();
    //   }
    //   else
    //   {
    //     _checkLocationServiceStatus();
    //   }
    // }
    if (await Geolocator.isLocationServiceEnabled()) {
      _con!.getUserLocation();
    } else {
      if (await Geolocator.openLocationSettings()) {
        _con!.getUserLocation();
      } else {
        //Enter your Location Manually
        _checkLocationServiceStatus();
      }
    }
  }

}

Column container({category, context, ontap}) {
  var theme = Theme.of(context);
  var textTheme = theme.textTheme;
  var size = MediaQuery.of(context).size;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
        child: GestureDetector(
          onTap: ontap,
          child: Text(
            '... Search in ' + category,
            style: textTheme.headline4!
                .merge(TextStyle(color: theme.colorScheme.secondary)),
          ),
        ),
      ),
      Container(
        width: size.width - 20,
        height: 0.5,
        color: theme.focusColor,
        margin: EdgeInsets.symmetric(vertical: 10),
      ),
    ],
  );
}
