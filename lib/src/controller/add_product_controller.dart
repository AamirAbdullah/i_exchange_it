// ignore_for_file: deprecated_member_use, duplicate_ignore, unnecessary_null_comparison

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:iExchange_it/config/condition_enum.dart';
import 'package:iExchange_it/config/strings.dart';
import 'package:iExchange_it/src/models/attribute.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/media.dart';
import 'package:iExchange_it/src/models/new_product.dart';
import 'package:iExchange_it/src/models/option.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/sub_category.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;
import 'package:iExchange_it/src/repository/category_repository.dart'
    as catRepo;
import 'package:iExchange_it/src/repository/add_product_repository.dart'
    as repo;
import 'package:path_provider/path_provider.dart';

class AddProductController extends ControllerMVC {
  late User currentUser;
  NewProduct newProd = NewProduct();
  GlobalKey<ScaffoldState>? scaffoldKey;
  GlobalKey<FormState>? formKey;
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

  //////////////////////////////////////////////////////////////////////////////
  ConditionEnum? wishCondition = ConditionEnum.newCondition;
  List<Category> wishCategories = <Category>[];
  List<SubCategory> wishSubCats = <SubCategory>[];
  List<ChildCategory> wishChildCats = <ChildCategory>[];

  Category? wishSelectedCat;
  SubCategory? wishSelectedSubCat;
  ChildCategory? wishSelectedChildCat;

  List<DropdownMenuItem<Category>>? wishCatDropdownMenuItems;
  List<DropdownMenuItem<SubCategory>>? wishSubCatDropdownMenuItems;
  List<DropdownMenuItem<ChildCategory>>? wishChildCatDropdownMenuItems;

  List<Attribute> wishAttributes = <Attribute>[];
  //////////////////////////////////////////////////////////////////////////////

  TextEditingController? addressController;

  List<Asset>? images = <Asset>[];

  List<Attribute> attributes = <Attribute>[];

  bool? isBidding = false;

  bool isLoading = false;
  bool isUploaded = false;

  List<DropdownMenuItem<Option>>? optionDropdownMenuItems;
  Option? selectedOption;

  AddProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.formKey = new GlobalKey<FormState>();
    addressController = TextEditingController();
    itemTypeDropdownMenuItems = buildItemTypeDropDownMenuItems(itemTypes);
    newProd.condition = "new";
    newProd.wishCondition = "new";
  }

  uploadProduct() async {
    if (formKey!.currentState!.validate()) {
      formKey!.currentState!.save();

      NewProduct _prod = this.newProd;

      if (_prod.mediaList == null || _prod.mediaList!.isEmpty) {
        // scaffoldKey!.currentState!
        //     .showSnackBar(SnackBar(content: Text("Select item images")));
      } else if (_prod.type == null) {
        ///Select Type first
        showToast("Please select type");
      } else if (_prod.categoryId == null) {
        ///Select Category Please
        showToast("Please select a category");
      } else if ((this.subCats.length > 0 &&
              (this
                      .subCats[this.subCats.length - 1]
                      .name
                      .toString()
                      .toLowerCase() !=
                  "all")) &&
          _prod.subCategoryId == null) {
        ///Select SubCategory Please
        showToast("Please select a subcategory");
      } else if ((this.childCats.length > 0 &&
              (this
                      .childCats[this.childCats.length - 1]
                      .name
                      .toString()
                      .toLowerCase() !=
                  "all")) &&
          _prod.childCategoryId == null) {
        ///Select ChildCategory Please
        showToast("Please select a child category");
      }

      ///Check Location Also (Country & City)
      else if (this.newProd.city == null || this.newProd.country == null) {
        showToast("Please select a city & country");
      }

      ///Check if selected for bidding but not choosen date
      else if (this.isBidding! &&
          (this.newProd.biddingEnd == null ||
              this.newProd.biddingEnd.toString().length < 1)) {
        showToast("Please select date to end bidding");
      } else if (this.newProd.type == EXCHANGE &&
          (this.newProd.wishLocation == null ||
              this.newProd.wishLocation.length < 1)) {
        showToast("Please select city for your wish Item");
      } else {
        setState(() {
          isLoading = true;
        });

        ///Ad Product Now
        Stream<Product> stream = await repo.addProduct(_prod);
        stream.listen((event) {
          setState(() {
            isUploaded = true;
          });
        }, onError: (e) {
          print(e);
          setState(() {
            isLoading = false;
          });
          // scaffoldKey!.currentState!.showSnackBar(SnackBar(
          //   content: Text("Error uploading item"),
          // ));
        }, onDone: () {
          if (isUploaded) {
            showToast("Item uploaded successfully");
            setState(() {
              isLoading = false;
            });
            Navigator.of(this.scaffoldKey!.currentContext!).pop();
          }
        });
      }

      print("Adding");
    }
  }

  getCurrentUser() async {
    userRepo.getCurrentUser().then((value) {
      setState(() {
        this.currentUser = value;
        this.newProd.phone = this.currentUser.phone;
      });
    });
  }

  getCategories() async {
    Stream<Category> stream = await catRepo.getCategories();
    stream.listen((_cat) {
      setState(() {
        categories.add(_cat);
        wishCategories.add(_cat);
      });
    }, onError: (e) {
      print(e);
    }, onDone: () {
      if (newProd.attrs != null) {
        newProd.attrs.clear();
      } else {
        newProd.attrs = <Attribute>[];
      }
      if (this.categories.length > 0) {
        setState(() {
          catDropdownMenuItems = buildCatDropDownMenuItems(categories);
          wishCatDropdownMenuItems =
              buildWishCatDropDownMenuItems(wishCategories);
        });
      }
    });
  }

  getSubCategories() async {
    Stream<SubCategory> stream =
        await catRepo.getSubCategories(this.selectedCat!.id.toString());
    stream.listen((_subCat) {
      setState(() {
        this.subCats.add(_subCat);
      });
    }, onError: (e) {
      print(e);
    }, onDone: () {
      if (this.subCats.length > 0) {
        setState(() {
          subCatDropdownMenuItems = buildSubCatDropDownMenuItems(this.subCats);
        });
      }
      if (newProd.attrs != null) {
        newProd.attrs.clear();
      } else {
        newProd.attrs = <Attribute>[];
      }

      if (this.subCats.length == 1) {
        if (this
                .subCats[this.subCats.length - 1]
                .name
                .toString()
                .toLowerCase() ==
            "all") {
          setState(() {
            this.selectedSubCat = this.subCats[0];
            this.newProd.subCategoryId = this.subCats[0].id;
          });
        }
        getChildCategories();
      }
    });
  }

  getChildCategories() async {
    Stream<ChildCategory> stream =
        await catRepo.getChildCategories(this.selectedSubCat!.id.toString());
    stream.listen((_subCat) {
      setState(() {
        this.childCats.add(_subCat);
      });
    }, onError: (e) {
      print(e);
    }, onDone: () {
      if (this.childCats.length > 0) {
        setState(() {
          childCatDropdownMenuItems =
              buildChildCatDropDownMenuItems(this.childCats);
        });
      }

      if (newProd.attrs != null) {
        newProd.attrs.clear();
      } else {
        newProd.attrs = <Attribute>[];
      }
      if (this.childCats.length == 1) {
        if (this
                .childCats[this.childCats.length - 1]
                .name
                .toString()
                .toLowerCase() ==
            "all") {
          setState(() {
            this.selectedChildCat = this.childCats[0];
            this.newProd.childCategoryId = this.childCats[0].id;
          });
          getAttributes();
        }
      }
    });
  }

  ///select
  getAttributes() async {
    newProd.attrs = <Attribute>[];
    Stream<Attribute> stream =
        await repo.getAttributes(this.selectedChildCat!.id.toString());
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

  onAttributeOptionSelect(Attribute _attr, Option _opt) {
    for (int i = 0; i < this.attributes.length; i++) {
      if (this.attributes[i].id == _attr.id &&
          this.attributes[i].type == 'select') {
        setState(() {
          this.attributes[i].valueToSend = _opt.option;
        });

        if (newProd.attrs.length < 1) {
          newProd.attrs = <Attribute>[];
          newProd.attrs.add(this.attributes[i]);
        } else if (newProd.attrs.length > 0) {
          var exists = false;
          for (int j = 0; j < newProd.attrs.length; j++) {
            if (newProd.attrs[j].id == this.attributes[i].id) {
              exists = true;
              setState(() {
                newProd.attrs[j] = this.attributes[i];
              });
            }
          }
          if (!exists) {
            newProd.attrs.add(this.attributes[i]);
          }
        }
      }
    }
  }

  onCategorySelected(Category? _category) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState(() {
      this.selectedCat = _category;
      this.subCats.clear();
      this.selectedSubCat = null;
      this.childCats.clear();
      this.selectedChildCat = null;
      this.newProd.categoryId = _category!.id;
      attributes.clear();
    });
    getSubCategories();
  }

  onSubCategorySelected(SubCategory? _subCategory) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState(() {
      this.selectedSubCat = _subCategory;
      this.childCats.clear();
      this.selectedChildCat = null;
      this.newProd.subCategoryId = _subCategory!.id;
      attributes.clear();
    });
    getChildCategories();
  }

  onChildCategorySelected(ChildCategory? _childCategory) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState(() {
      this.selectedChildCat = _childCategory;
      this.newProd.childCategoryId = _childCategory!.id;
      attributes.clear();
    });
    getAttributes();
  }

  void getCameraImage() async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    var _rand = Random();
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      debugPrint("pickedFile: " + pickedFile.path);
      setState(() {
        if (newProd.mediaList == null) {
          newProd.mediaList = <Media>[];
        }
        newProd.mediaList!.add(Media(
            identifier: pickedFile.path,
            name: "Image_${_rand.nextInt(100000)}"));
      });
    }
  }

  void getGalleryImages() async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    List<Asset>? resultList;
    String? error;

    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 10,
          enableCamera: true,
          selectedAssets: images ?? <Asset>[],
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            statusBarColor: "#25d366",
            actionBarColor: "#25d366",
            actionBarTitle: "Pick image",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ));
    } on Exception catch (e) {
      error = e.toString();
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    if (resultList != null) {
      setState(() {
        images = resultList;
        if (newProd.mediaList == null) {
          newProd.mediaList = <Media>[];
        }
        newProd.mediaList!.clear();
        if (error == null) {}
      });
    }
    //TODO
    if (images != null) {
      images!.forEach((e) async {
        // var path = await FlutterAbsolutePath.getAbsolutePath(e.identifier);
        var path1 = await getImageFileFromAssets(e);
        var path=path1.path;
        setState(() {
          newProd.mediaList!.add(Media(name: e.name, identifier: path));
        });
      });
    }
  }

  ///////////////////////////////////////////////////////////////////////
  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  //////////////////////////////////////////////////////////////////////////

  getWishSubCategories() async {
    Stream<SubCategory> stream =
        await catRepo.getSubCategories(this.wishSelectedCat!.id.toString());
    stream.listen((_subCat) {
      setState(() {
        this.wishSubCats.add(_subCat);
      });
    }, onError: (e) {
      print(e);
    }, onDone: () {
      if (this.wishSubCats.length > 0) {
        setState(() {
          wishSubCatDropdownMenuItems =
              buildWishSubCatDropDownMenuItems(this.wishSubCats);
        });
      }
      newProd.wishAttrs = <Attribute>[];

      if (this.wishSubCats.length == 1) {
        if (this
                .wishSubCats[this.wishSubCats.length - 1]
                .name
                .toString()
                .toLowerCase() ==
            "all") {
          setState(() {
            this.wishSelectedSubCat = this.wishSubCats[0];
            this.newProd.wishSubCategoryId = this.wishSubCats[0].id;
          });
        }
      }
    });
  }

  getWishChildCategories() async {
    Stream<ChildCategory> stream = await catRepo
        .getChildCategories(this.wishSelectedSubCat!.id.toString());
    stream.listen((_subCat) {
      setState(() {
        this.wishChildCats.add(_subCat);
      });
    }, onError: (e) {
      print(e);
    }, onDone: () {
      if (this.wishChildCats.length > 0) {
        setState(() {
          wishChildCatDropdownMenuItems =
              buildWishChildCatDropDownMenuItems(this.wishChildCats);
        });
      }

      newProd.wishAttrs = <Attribute>[];
      if (this.wishChildCats.length == 1) {
        if (this
                .wishChildCats[this.wishChildCats.length - 1]
                .name
                .toString()
                .toLowerCase() ==
            "all") {
          setState(() {
            this.wishSelectedChildCat = this.wishChildCats[0];
            this.newProd.wishChildCategoryId = this.wishChildCats[0].id;
          });
          getWishAttributes();
        }
      }
    });
  }

  ///select
  getWishAttributes() async {
    newProd.wishAttrs = <Attribute>[];
    Stream<Attribute> stream =
        await repo.getAttributes(this.wishSelectedChildCat!.id.toString());
    stream.listen((_attr) {
      setState(() {
        wishAttributes.add(_attr);
      });
      if (_attr.type != null &&
          _attr.type == 'select' &&
          _attr.options != null &&
          _attr.options!.length > 0) {
        onWishAttributeOptionSelect(_attr, _attr.options![0]);
        // _attr.valueToSend = _attr.options[0].option.toLowerCase();
      }
    }, onError: (e) {
      print(e);
    }, onDone: () {});
  }

  onWishAttributeOptionSelect(Attribute _attr, Option _opt) {
    for (int i = 0; i < this.wishAttributes.length; i++) {
      if (this.wishAttributes[i].id == _attr.id &&
          this.wishAttributes[i].type == 'select') {
        setState(() {
          this.wishAttributes[i].valueToSend = _opt.option;
        });

        if (newProd.wishAttrs.length < 1) {
          newProd.wishAttrs = <Attribute>[];
          newProd.wishAttrs.add(this.wishAttributes[i]);
        } else if (newProd.wishAttrs.length > 0) {
          var exists = false;
          for (int j = 0; j < newProd.wishAttrs.length; j++) {
            if (newProd.wishAttrs[j].id == this.wishAttributes[i].id) {
              exists = true;
              setState(() {
                newProd.wishAttrs[j] = this.wishAttributes[i];
              });
            }
          }
          if (!exists) {
            newProd.wishAttrs.add(this.wishAttributes[i]);
          }
        }
      }
    }
  }

  onWishCategorySelected(Category? _category) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState(() {
      this.wishSelectedCat = _category;
      this.wishSubCats.clear();
      this.wishSelectedSubCat = null;
      this.wishChildCats.clear();
      this.wishSelectedChildCat = null;
      this.newProd.wishCategoryId = _category!.id;
      wishAttributes.clear();
    });
    getWishSubCategories();
  }

  onWishSubCategorySelected(SubCategory? _subCategory) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState(() {
      this.wishSelectedSubCat = _subCategory;
      this.wishChildCats.clear();
      this.wishSelectedChildCat = null;
      this.newProd.wishSubCategoryId = _subCategory!.id;
      wishAttributes.clear();
    });
    getWishChildCategories();
  }

  onWishChildCategorySelected(ChildCategory? _childCategory) async {
    FocusScope.of(this.scaffoldKey!.currentContext!).unfocus();
    setState(() {
      this.wishSelectedChildCat = _childCategory;
      this.newProd.wishChildCategoryId = _childCategory!.id;
      wishAttributes.clear();
    });
    getWishAttributes();
  }

  //////////////////////////////////////////////////////////////////////////

  List<DropdownMenuItem<String>> buildItemTypeDropDownMenuItems(
      List listItems) {
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

  List<DropdownMenuItem<Category>> buildCatDropDownMenuItems(
      List<Category> _categories) {
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

  List<DropdownMenuItem<SubCategory>> buildSubCatDropDownMenuItems(
      List<SubCategory> _subCats) {
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

  List<DropdownMenuItem<ChildCategory>> buildChildCatDropDownMenuItems(
      List<ChildCategory> _childCats) {
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

  List<DropdownMenuItem<Category>> buildWishCatDropDownMenuItems(
      List<Category> _categories) {
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

  List<DropdownMenuItem<SubCategory>> buildWishSubCatDropDownMenuItems(
      List<SubCategory> _subCats) {
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

  List<DropdownMenuItem<ChildCategory>> buildWishChildCatDropDownMenuItems(
      List<ChildCategory> _childCats) {
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
