import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iExchange_it/src/controller/categories_controller.dart';
import 'package:iExchange_it/src/elements/category/category_search_filter_bottom_sheet.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../elements/products_grid.dart';
import '../../elements/shimmer/grid_product_shimmer_list.dart';
// import 'package:location/location.dart' as loc;


class ItemsByChildCategory extends StatefulWidget {

 final RouteArgument? argument;

  ItemsByChildCategory({this.argument});

  @override
  _ItemsByChildCategoryState createState() => _ItemsByChildCategoryState();
}

class _ItemsByChildCategoryState extends StateMVC<ItemsByChildCategory> {

  CategoriesController? _con;
  // var location = loc.Location();
  // loc.PermissionStatus _status;
  LocationPermission? _status;

  _ItemsByChildCategoryState() : super(CategoriesController()) {
    _con = controller as CategoriesController?;
  }

  @override
  void initState() {
    _con!.selectedCat = widget.argument!.category;
    _con!.categories = widget.argument!.categories;
    _con!.selectedSubCat = widget.argument!.subCategory;
    _con!.subCats = widget.argument!.subCats;
    _con!.childCats = widget.argument!.childCats;
    _con!.selectedChildCat = widget.argument!.childCategory;
    _con!.title = widget.argument!.childCategory!.name.toString().toUpperCase();

    _con!.buildCatDropDownMenuItems(_con!.categories!);
    _con!.buildSubCatDropDownMenuItems(_con!.subCats!);
    _con!.buildChildCatDropDownMenuItems(_con!.childCats!);
    _con!.buildItemTypeDropDownMenuItems(_con!.itemTypes);

    _con!.getProductsByChildCategory();
    _con!.getAttributes();
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


    return WillPopScope(
      onWillPop: () async {
        if(_con!.isSuggestionsDropDownOpened) {
          _con!.removeOverlay();
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _con!.scaffoldKey,
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text(_con.selectedChildCat.name ?? "", style: textTheme.headline4,),
        //   backgroundColor: theme.scaffoldBackgroundColor,
        //   elevation: 0,
        //   leading: IconButton(
        //     icon: Icon(CupertinoIcons.back),
        //     onPressed: (){
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
        appBar: AppBar(
          key: _con!.searchFieldKey,
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
          title: Container(
            color: theme.scaffoldBackgroundColor,
            child: Row(
              children: [
                InkWell(
                  onTap: (){
                    if(_con!.isSuggestionsDropDownOpened) {
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
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _con!.searchTextController,
                            keyboardType: TextInputType.text,
                            style: textTheme.bodyText1!.merge(TextStyle(color: theme.primaryColorDark)),
                            onChanged: (value) {
                              _con!.onSearchTextChange(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search in ${_con!.selectedChildCat!.name ?? ""}",
                              hintStyle: textTheme.bodyText1!
                                  .merge(TextStyle(color: theme.hintColor)),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _con!.searchNow();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                  onTap: (){
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
                        Text("Filters", style: textTheme.caption!.merge(TextStyle(color: theme.colorScheme.secondary)),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              _con!.isLoadingProducts
                  ? GridProductShimmerList()
                  : ProductsGrid(products: _con!.catProducts,),

            ],
          ),
        ),
      ),
    );
  }



  showSearchFiltersBottomSheet(BuildContext context, CategoriesController? _oldCon) {
    var theme = Theme.of(context);

    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: theme.primaryColorDark,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
              builder: (ctx, setModalState) {
                return CategorySearchFilterBottomSheetWidget(con: _oldCon,);
              }
          );
        }
    ).then((value) {
      if(value != null) {
        var _newCon = value as CategoriesController;
        setState((){
          if(_newCon.applyFilter) {
            // _con.categories = _newCon.categories;
            // _con.subCats = _newCon.subCats;
            // _con.childCats = _newCon.childCats;
            // _con.selectedCat = _newCon.selectedCat;
            // _con.selectedSubCat = _newCon.selectedSubCat;
            // _con.selectedChildCat = _newCon.selectedChildCat;
            // _con.catDropdownMenuItems = _newCon.catDropdownMenuItems;
            // _con.subCatDropdownMenuItems = _newCon.subCatDropdownMenuItems;
            // _con.childCatDropdownMenuItems = _newCon.childCatDropdownMenuItems;
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
    if(_status != status) {
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
    if(_status == null) {
      Geolocator.requestPermission().then((status) {
        if(status == LocationPermission.always || status == LocationPermission.whileInUse) {
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
    if(await Geolocator.isLocationServiceEnabled()) {
      _con!.getUserLocation();
    } else {
      if(await Geolocator.openLocationSettings())
      {
        _con!.getUserLocation();
      }
      else
      {
        //Enter your Location Manually
        _checkLocationServiceStatus();
      }
    }
  }

}
