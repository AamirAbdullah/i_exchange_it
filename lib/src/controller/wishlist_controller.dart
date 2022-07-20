// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iExchange_it/config/condition_enum.dart';
import 'package:iExchange_it/config/strings.dart';
import 'package:iExchange_it/src/models/attribute.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/option.dart';
import 'package:iExchange_it/src/models/sub_category.dart';
import 'package:iExchange_it/src/models/wishlist_got.dart';
import 'package:iExchange_it/src/models/wishlist_item.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/category_repository.dart' as catRepo;
import 'package:iExchange_it/src/repository/wishlist_repository.dart' as repo;
import 'package:iExchange_it/src/repository/add_product_repository.dart' as prodRepo;


class WishlistController extends ControllerMVC {

  WishlistItem item = WishlistItem();
  ConditionEnum? condition = ConditionEnum.newCondition;

  List<DropdownMenuItem<String>>? itemTypeDropdownMenuItems;
  List<String> itemTypes = [FREE, EXCHANGE, SALE, BUY];
  String? selectedItem;

  List<Category> categories = <Category>[];
  List<SubCategory> subCats = <SubCategory>[];
  List<ChildCategory> childCats = <ChildCategory>[];

  Category? selectedCat;
  SubCategory? selectedSubCat;
  ChildCategory? selectedChildCat;

  List<DropdownMenuItem<Category>>? catDropdownMenuItems;
  List<DropdownMenuItem<SubCategory>>? subCatDropdownMenuItems;
  List<DropdownMenuItem<ChildCategory>>? childCatDropdownMenuItems;

  TextEditingController? addressController;

  List<Attribute> attributes = <Attribute>[];

  bool isBidding = false;

  bool isLoading = false;

  List<WishlistGot> wishlists = <WishlistGot>[];

  WishlistGot? toDelete;
  bool showDeleteDialog = false;

  GlobalKey<ScaffoldState>? scaffoldKey;
  GlobalKey<FormState>? formKey;

  WishlistController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.formKey = new GlobalKey<FormState>();
    itemTypeDropdownMenuItems = buildItemTypeDropDownMenuItems(itemTypes);
    item.condition = "new";
  }

  getMyWishlist() async {
    setState((){isLoading = true;});
    Stream<WishlistGot> stream = await repo.getMyWishlist();
    stream.listen((event) {
      setState((){
        this.wishlists.add(event);
      });
    },
        onError: (e){
      print(e);
      setState((){isLoading = false;});
      
      // scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Verify your internet connection")));
        },
        onDone: (){
          setState((){isLoading = false;});
    });
  }

  promptToDelete(WishlistGot _wish) {
    setState((){
      this.toDelete = _wish;
      this.showDeleteDialog = true;
    });
  }

  deleteItemFromWishlist() async {
    setState((){ showDeleteDialog = false; });
    repo.deleteWishlistItem(this.toDelete!).then((value) {
      if(value) {
        for(int i=0; i<this.wishlists.length; i++) {
          if(this.wishlists[i].id.toString() == this.toDelete!.id.toString()) {
            setState((){
              this.wishlists.removeAt(i);
            });
          }
        }
        toDelete = null;
        showToast("Item removed from wishlist");
      } else {
        showToast("Error removing item now");
      }
    },
        onError: (e){
      print(e);
      showToast("Error removing item");
        });
  }

  createWishList() async {
    if(formKey!.currentState!.validate()) {
      formKey!.currentState!.save();
      if(item.type == null) {
        ///Select Type first
        showToast("Please select type");
      }
      else if(item.categoryId == null) {
        ///Select Category Please
        showToast("Please select a category");
      }
      else if((this.subCats.length > 0 && (this.subCats[this.subCats.length-1].name.toString().toLowerCase() != "all")) && item.subCategoryId == null) {
        ///Select SubCategory Please
        showToast("Please select a subcategory");
      }
      else if((this.childCats.length > 0 && (this.childCats[this.childCats.length-1].name.toString().toLowerCase() != "all")) && item.childCategoryId == null) {
        ///Select ChildCategory Please
        showToast("Please select a child category");
      }
      ///Check Location Also
      else if (this.item.location == null) {
        showToast("Please select Location/City");
      }
      else {
        setState((){ isLoading = true; });
        ///Ad WishlistNow Now
        // Stream<bool> stream = await repo.addWishlistItem(item);
        // stream.listen((event) {
        //   if(event) {
        //     showToast("Added to Wishlist");
        //     Navigator.of(context).pop();
        //   }
        // }, onError: (e){
        //   print(e);
        //   setState((){ isLoading = false; });
        //   scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Error adding Item to Wishlist"),));
        // });
        repo.addWishlistItem(item).then((value) {
          setState((){ isLoading = false; });
          if(value) {
            showToast("Added to Wishlist");
            Navigator.of(this.scaffoldKey!.currentContext!).pop();
          } else {
            showToast("Error adding Item to Wishlist");
          }
        },
            onError: (e){
          print(e);
          setState((){ isLoading = false; });
          // scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Error adding Item to Wishlist"),));
            });
      }
    }
  }

  getCategories() async {
    Stream<Category> stream = await catRepo.getCategories();
    stream.listen((_cat) {
      setState((){
        categories.add(_cat);
      });
    },
        onError: (e){
          print(e);
        },
        onDone: (){
          if(this.categories.length > 0) {
            setState((){
              catDropdownMenuItems = buildCatDropDownMenuItems(categories);
            });
          }
        });
  }
  getSubCategories() async {
    Stream<SubCategory> stream = await catRepo.getSubCategories(this.selectedCat!.id.toString());
    stream.listen((_subCat) {
      setState((){
        this.subCats.add(_subCat);
      });
    },
        onError: (e){
          print(e);
        },
        onDone: (){
          if(this.subCats.length > 0) {
            setState((){
              subCatDropdownMenuItems = buildSubCatDropDownMenuItems(this.subCats);
            });
          }


          if(this.subCats.length == 1) {
            if (this.subCats[this.subCats.length - 1].name.toString()
                .toLowerCase() == "all") {
              setState(() {
                this.selectedSubCat = this.subCats[0];
                this.item.subCategoryId = this.subCats[0].id;
              });
            }
            getChildCategories();
          }

        }
    );
  }
  getChildCategories() async {
    Stream<ChildCategory> stream = await catRepo.getChildCategories(this.selectedSubCat!.id.toString());
    stream.listen((_subCat) {
      setState((){
        this.childCats.add(_subCat);
      });
    },
        onError: (e){
          print(e);
        },
        onDone: (){
          if(this.childCats.length > 0) {
            setState((){
              childCatDropdownMenuItems = buildChildCatDropDownMenuItems(this.childCats);
            });
          }

          if(this.childCats.length == 1) {
            if (this.childCats[this.childCats.length - 1].name.toString()
                .toLowerCase() == "all") {
              setState(() {
                this.selectedChildCat = this.childCats[0];
                this.item.childCategoryId = this.childCats[0].id;
              });
              getAttributes();
            }
          }

        }
    );
  }

  getAttributes() async {
    Stream<Attribute> stream = await prodRepo.getAttributes(this.selectedChildCat!.id.toString());
    stream.listen((_attr) {
      setState((){
        attributes.add(_attr);
      });
      if (_attr.type != null &&
          _attr.type == 'select' &&
          _attr.options != null &&
          _attr.options!.length > 0) {
        onAttributeOptionSelect(_attr, _attr.options![0]);
        // _attr.valueToSend = _attr.options[0].option.toLowerCase();
      }
    },
        onError: (e){
          print(e);
        },
        onDone: (){});
  }

  onAttributeOptionSelect(Attribute _attr, Option _opt){
    for(int i = 0; i<this.attributes.length; i++) {
      if(this.attributes[i].id == _attr.id && this.attributes[i].type=='select') {
        setState((){
          this.attributes[i].valueToSend = _opt.option;
        });

        if(item.attrs.length < 1) {
          item.attrs = <Attribute>[];
          item.attrs.add(this.attributes[i]);
        } else if (item.attrs.length > 0) {
          var exists = false;
          for(int j = 0; j<item.attrs.length; j++) {
            if(item.attrs[j].id == this.attributes[i].id) {
              exists = true;
              setState((){
                item.attrs[j] = this.attributes[i];
              });
            }
          }
          if(!exists) {
            item.attrs.add(this.attributes[i]);
          }
        }
      }
    }
  }


  onCategorySelected(Category? _category) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState((){
      this.selectedCat = _category;
      this.subCats.clear();
      this.selectedSubCat = null;
      this.childCats.clear();
      this.selectedChildCat = null;
      this.item.categoryId = _category!.id;
      attributes.clear();
    });
    getSubCategories();
  }
  onSubCategorySelected(SubCategory? _subCategory) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState((){
      this.selectedSubCat = _subCategory;
      this.childCats.clear();
      this.selectedChildCat = null;
      this.item.subCategoryId = _subCategory!.id;
      attributes.clear();
    });
    getChildCategories();
  }
  onChildCategorySelected(ChildCategory? _childCategory) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState((){
      this.selectedChildCat = _childCategory;
      this.item.childCategoryId = _childCategory!.id;
      attributes.clear();
    });
    getAttributes();
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

}