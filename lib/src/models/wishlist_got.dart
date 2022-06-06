import 'package:iExchange_it/src/models/attribute.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/sub_category.dart';

class WishlistGot {
  var id;
  var userId;
  var categoryId;
  var subCategoryId;
  var childCategoryId;
  var latitude;
  var longitude;
  var keyword;
  var postcode;
  var range;
  var location;
  var condition;
  var type;
  var duration;
  var minprice;
  var maxprice;
  var createdAt;
  var updatedAt;
  List<Attribute>? attributes;
  Category? category;
  SubCategory? subCategory;
  ChildCategory? childCategory;

  WishlistGot(
      {this.id,
        this.userId,
        this.categoryId,
        this.subCategoryId,
        this.childCategoryId,
        this.latitude,
        this.longitude,
        this.keyword,
        this.postcode,
        this.range,
        this.location,
        this.condition,
        this.type,
        this.duration,
        this.minprice,
        this.maxprice,
        this.createdAt,
        this.updatedAt,
        this.attributes,
        this.category,
        this.subCategory,
        this.childCategory});

  WishlistGot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    childCategoryId = json['child_category_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    keyword = json['keyword'];
    postcode = json['postcode'];
    range = json['range'];
    location = json['location'];
    condition = json['condition'];
    type = json['type'];
    duration = json['duration'];
    minprice = json['minprice'];
    maxprice = json['maxprice'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['attributes'] != null) {
      attributes = <Attribute>[];
      json['attributes'].forEach((v) {
        Attribute _attr = Attribute.fromJson(v['attribute']);
        _attr.valueToSend = v['value'];
        attributes!.add(_attr);
      });
    }
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new SubCategory.fromJson(json['sub_category'])
        : null;
    childCategory = json['child_category'] != null
        ? new ChildCategory.fromJson(json['child_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['child_category_id'] = this.childCategoryId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['keyword'] = this.keyword;
    data['postcode'] = this.postcode;
    data['range'] = this.range;
    data['location'] = this.location;
    data['condition'] = this.condition;
    data['type'] = this.type;
    data['duration'] = this.duration;
    data['minprice'] = this.minprice;
    data['maxprice'] = this.maxprice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.toJson();
    }
    if (this.childCategory != null) {
      data['child_category'] = this.childCategory!.toJson();
    }
    return data;
  }
}