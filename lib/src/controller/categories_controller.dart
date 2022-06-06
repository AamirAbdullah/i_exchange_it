import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iExchange_it/config/condition_enum.dart';
import 'package:iExchange_it/config/strings.dart';
import 'package:iExchange_it/src/models/choose_location_model.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/category_repository.dart' as catRepo;
import 'package:iExchange_it/src/repository/product_repository.dart' as proRepo;
// import 'package:location/location.dart' as l;
import '../models/attribute.dart';
import '../models/category.dart';
import '../models/child_category.dart';
import '../models/option.dart';
import '../models/product.dart';
import '../models/sub_category.dart';
import 'package:iExchange_it/src/repository/search_repository.dart' as searchRepo;
import 'package:iExchange_it/src/repository/add_product_repository.dart' as repo;

class CategoriesController extends ControllerMVC {
  GlobalKey? searchFieldKey;

  List<Category>? categories = <Category>[];
  List<SubCategory>? subCats = <SubCategory>[];
  List<ChildCategory>? childCats = <ChildCategory>[];
  Category? selectedCat;
  SubCategory? selectedSubCat;
  ChildCategory? selectedChildCat;
  List<DropdownMenuItem<Category>>? catDropdownMenuItems;
  List<DropdownMenuItem<SubCategory>>? subCatDropdownMenuItems;
  List<DropdownMenuItem<ChildCategory>>? childCatDropdownMenuItems;


  Category? category;
  String title = "";
  bool isLoadingCats = false;
  bool isLoadingProducts = false;


  List<Product> catProducts = <Product>[];


  List<DropdownMenuItem<String>>? itemTypeDropdownMenuItems;
  List<String> itemTypes = [FREE, EXCHANGE, SALE];
  ChooseLocationModel loc = ChooseLocationModel();
  ConditionEnum? condition = ConditionEnum.newCondition;
  TextEditingController? minPriceController;
  TextEditingController? maxPriceController;
  TextEditingController? searchTextController;
  bool applyFilter = false;
  String? selectedItemType;
  String? selectedCondition;
  String? minPrice;
  String? maxPrice;


  List<Attribute> attributes = <Attribute>[]; ///All available attributes
  List<Attribute> attrs = <Attribute>[]; ///Applied Attributes



  User? currentUser;
  GlobalKey<ScaffoldState>? scaffoldKey;

  CategoriesController() {
    this.searchFieldKey = LabeledGlobalKey('searchFieldKey');
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    minPriceController = TextEditingController();
    maxPriceController = TextEditingController();
    searchTextController = TextEditingController();
    selectedCondition = "new";
    itemTypeDropdownMenuItems = buildItemTypeDropDownMenuItems(itemTypes);
  }

  searchNow() async {
    removeOverlay();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    Stream<Product> stream;

    setState((){
      catProducts.clear();
      isLoadingProducts = true;
    });

    // if (applyFilter) {
    var minPrice = "0";
    var maxPrice = "100000000";
    if(minPriceController!.text.length > 0) {
      minPrice = minPriceController!.text;
    }
    if(maxPriceController!.text.length > 0) {
      maxPrice = maxPriceController!.text;
    }
    stream = await searchRepo.searchProductWithFilters(searchTextController!.text, "", this.selectedItemType ?? "", this.loc.city ??"Islamabad",
        (this.selectedCat != null ? this.selectedCat!.id : ""),
        (this.selectedSubCat != null ? this.selectedSubCat!.id : ""),
        (this.selectedChildCat != null ? this.selectedChildCat!.id : ""),
        selectedCondition, minPrice, maxPrice, "all", this.loc.lat, this.loc.long, "10000", attrs: this.attrs);
    // } else {
    //   stream = await searchRepo.searchProductWithoutFilters(searchTextController.text, this.loc.lat, this.loc.long, "50");
    // }

    stream.listen((_prod) {
      setState((){
        catProducts.add(_prod);
      });
    },
        onError: (e){
          print(e);
          setState((){isLoadingProducts = false;});
          showToast("Error searching items");
        },
        onDone: (){
          setState((){isLoadingProducts = false; });
        });

  }


  getSubCategories() async {
    setState((){
      isLoadingCats = true;
      this.subCats!.clear();
    });
    Stream<SubCategory> stream = await catRepo.getSubCategories(this.category!.id);
    stream.listen((_subCat) {
      setState((){
        this.subCats!.add(_subCat);
      });
    },
        onError: (e){
          print(e);
          setState((){ isLoadingCats = false; });
        },
        onDone: (){
          setState((){ isLoadingCats = false; });
        }
    );
  }

  getChildCategories() async {
    setState((){
      isLoadingCats = true;
      this.childCats!.clear();
    });
    Stream<ChildCategory> stream = await catRepo.getChildCategories(this.selectedSubCat!.id);
    stream.listen((_subCat) {
      setState((){
        this.childCats!.add(_subCat);
      });
    },
        onError: (e){
          print(e);
          setState((){ isLoadingCats = false; });
        },
        onDone: (){
          setState((){ isLoadingCats = false; });
        }
    );
  }

  getProductsByChildCategory() async {
    setState((){
      isLoadingProducts = true;
      this.catProducts.clear();
    });
    Stream<Product> stream = await proRepo.getProductsByChildCategory(this.selectedChildCat!.id);
    stream.listen((_product) {
      setState((){
        this.catProducts.add(_product);
      });
    },
        onError: (e){
          print(e);
          setState((){isLoadingProducts = false;});
        },
        onDone: (){
          setState((){isLoadingProducts = false;});});
  }


  ///select
  getAttributes() async {
    this.attrs = <Attribute>[];
    Stream<Attribute> stream = await repo.getAttributes(this.selectedChildCat!.id.toString());
    stream.listen((_attr) {
      setState(() {
        attributes.add(_attr);
      });
      if (_attr.type != null &&
          _attr.type == 'select' &&
          _attr.options != null &&
          _attr.options!.length > 0) {
        onAttributeOptionSelect(_attr, _attr.options![0]);
        // _attr.valueToSend = _attr.options[0].option.toLowerCase();
      }
    }, onError: (e) {
      print(e);
    }, onDone: () {});
  }

  onAttributeOptionSelect(Attribute _attr, Option _opt){
    for(int i = 0; i<this.attributes.length; i++) {
      if(this.attributes[i].id == _attr.id && this.attributes[i].type=='select') {
        setState((){
          this.attributes[i].valueToSend = _opt.option;
        });

        if(this.attrs.length < 1) {
          this.attrs = <Attribute>[];
          this.attrs.add(this.attributes[i]);
        } else if (this.attrs.length > 0) {
          var exists = false;
          for(int j = 0; j<this.attrs.length; j++) {
            if(this.attrs[j].id == this.attributes[i].id) {
              exists = true;
              setState((){
                this.attrs[j] = this.attributes[i];
              });
            }
          }
          if(!exists) {
            this.attrs.add(this.attributes[i]);
          }
        }
      }
    }
  }



  List<DropdownMenuItem<String>> buildItemTypeDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = [];
    for (String listItem in listItems as Iterable<String>) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Category>> buildCatDropDownMenuItems(List<Category> _categories) {
    List<DropdownMenuItem<Category>> items = [];
    for (Category cat in _categories) {
      items.add(
        DropdownMenuItem(
          child: Text(cat.name),
          value: cat,
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<SubCategory>> buildSubCatDropDownMenuItems(List<SubCategory> _subCats) {
    List<DropdownMenuItem<SubCategory>> items = [];
    for (SubCategory cat in _subCats) {
      items.add(
        DropdownMenuItem(
          child: Text(cat.name),
          value: cat,
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<ChildCategory>> buildChildCatDropDownMenuItems(List<ChildCategory> _childCats) {
    List<DropdownMenuItem<ChildCategory>> items = [];
    for (ChildCategory cat in _childCats) {
      items.add(
        DropdownMenuItem(
          child: Text(cat.name),
          value: cat,
        ),
      );
    }
    return items;
  }


  // TO GET THE USER LOCATION
  void getUserLocation() async {
    print("Getting user location: 2");
    // l.LocationData position = await l.Location().getLocation();
    final position = await Geolocator.getCurrentPosition();
    LatLng pos = LatLng(position.latitude, position.longitude);
    getAddressAndLocation(pos);
  }

  void getAddressAndLocation(LatLng position) async {
    double latitude = position.latitude;
    double longitude = position.longitude;
   List<Placemark> addresses =
        await placemarkFromCoordinates(latitude, longitude);

    var addressGot = addresses.first.administrativeArea! +
        ", " +
        addresses.first.subAdministrativeArea! +
        " " +
        addresses.first.country!;

    setState((){
      this.loc.city = addresses.first.subAdministrativeArea;
      this.loc.lat = latitude.toString();
      this.loc.long = longitude.toString();
    });

    print("Getting user location: 34 " + addressGot);
  }


  ///To handle search suggestions
  bool isSuggestionsDropDownOpened = false;
  double? suggestionsHeight, suggestionsWidth, suggestionsxPos, suggestionsyPos;
  late OverlayEntry suggestionsFloatingDropDown;
  OverlayState? overlayState;
  bool isTapped = false;
  List<String> mySuggestions = [];

  removeOverlay(){
    setState(() {
      try {
        suggestionsFloatingDropDown.remove();
      } catch (e) {
        print("Removing DropDown Error");
        print(e);
      }
      this.isSuggestionsDropDownOpened = false;
    });
  }

  onSearchTextChange(String value) {
    if(value.length <1) {
      suggestionsFloatingDropDown.remove();
    } else {
      setState(() {
        mySuggestions = getMatchingSuggestions(value);
        if(mySuggestions.isNotEmpty && !isTapped) {
          try {
            suggestionsFloatingDropDown.remove();
          } catch (e) {
            print("Removing DropDown Error");
            print(e);
          }
          suggestionsFindDropDownData();
          suggestionsFloatingDropDown = suggestionsCreateFloatingDropDown();
          overlayState!.insert(suggestionsFloatingDropDown);
          this.isSuggestionsDropDownOpened = true;
        } else {
          try {
            suggestionsFloatingDropDown.remove();
          } catch (e) {
            print("Removing DropDown Error");
            print(e);
          }
          this.isSuggestionsDropDownOpened = false;
          this.isTapped = false;
        }
      });
    }
  }

  List<String> getMatchingSuggestions(String text) {
    List<String> _matching = [];
    for(String sug in suggestions) {
      if(sug.toLowerCase().contains(text.toLowerCase())) {
        _matching.add(sug);
      }
    }
    return _matching;
  }

  suggestionsFindDropDownData() {
    RenderBox renderBox = searchFieldKey!.currentContext!.findRenderObject() as RenderBox;
    suggestionsHeight = renderBox.size.height;
    suggestionsWidth = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    suggestionsxPos = offset.dx;
    suggestionsyPos = offset.dy;
  }

  suggestionsCreateFloatingDropDown() {
    return OverlayEntry(
        builder: (context) {
          return Positioned(
            top: suggestionsyPos! + suggestionsHeight!,
            left: suggestionsxPos,
            // width: constraints.maxWidth,
            // height: constraints.maxHeight,
            width: MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(this.mySuggestions.length, (index) {
                    return Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            this.isTapped = true;
                            this.searchTextController!.text = this.mySuggestions[index];
                            suggestionsFloatingDropDown.remove();
                            this.isSuggestionsDropDownOpened = false;
                          });
                          searchNow();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.forward, color: Theme.of(context).focusColor,),
                              SizedBox(width: 8,),
                              Text(this.mySuggestions[index], style: Theme.of(context).textTheme.bodyText1,)
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
        }
    );
  }

}