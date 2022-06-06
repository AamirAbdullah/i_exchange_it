import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/chat.dart';
import 'package:iExchange_it/src/models/item.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/user.dart';

import 'child_category.dart';
import 'sub_category.dart';

class RouteArgument {
  Item? item;
  Product? product;

  Chat? chat;

  User? user;
  User? currentUser;

  Category? category;
  SubCategory? subCategory;
  ChildCategory? childCategory;

  bool isMine = false;
  bool isEditingReview = false;

  bool showRecent = true;
  bool showPopular = false;
  bool showFeatured = false;
  bool showProductsByFollow = false;

  List<Category>? categories = <Category>[];
  List<SubCategory>? subCats = <SubCategory>[];
  List<ChildCategory>? childCats = <ChildCategory>[];

  RouteArgument({this.item,
    this.user,
    this.chat,
    this.product,
    this.category,
    this.subCategory,
    this.childCategory,
    this.currentUser,
    this.isMine = false,
    this.isEditingReview = false,
    this.showRecent = true,
    this.showPopular = false,
    this.showFeatured = false,
    this.showProductsByFollow = false,
    this.categories,
    this.subCats,
    this.childCats,
  });

}