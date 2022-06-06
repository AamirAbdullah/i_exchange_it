import 'package:iExchange_it/src/models/attribute.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/images.dart';
import 'package:iExchange_it/src/models/sub_category.dart';
import 'package:iExchange_it/src/models/user.dart';

class Product {
  var id;
  var userId;
  var categoryId;
  var subCategoryId;
  var childCategoryId;
  var name;
  var description;
  var price;
  var type;
  var phone;
  var country;
  var city;
  var address;
  var postcode;
  var video;
  var buynow;
  var bidding;
  var exchange;
  var createdAt;
  var updatedAt;
  var condition;
  List<Images>? images;
  Category? category;
  SubCategory? subCategory;
  ChildCategory? childCategory;
  User? user;
  var location;
  String? latitude;
  String? longitude;
  bool isFavorite = false;
  var biddingEnd;

  List<Attribute> attrs = <Attribute>[];



  /// For Excahnge Products Attributes

  List<Attribute>? attributes;


  ///


  var wishCategoryId;
  var wishSubCategoryId;
  var wishChildCategoryId;
  var keyword;
  var range;
  var minPrice;
  var maxPrice;
  var wishLocation; ///City
  var wishCondition;
  var viewsCount = "0";
  List<Attribute> wishAttrs = <Attribute>[];
  List<Product> relatedProducts = <Product>[];
  Category? wishCategory;
  SubCategory? wishSubCategory;
  ChildCategory? wishChildCategory;

  Product(
      {this.id,
        this.categoryId,
        this.subCategoryId,
        this.childCategoryId,
        this.name,
        this.isFavorite = false,
        this.description,
        this.price,
        this.type,
        this.phone,
        this.country,
        this.city,
        this.address,
        this.postcode,
        this.video,
        this.buynow,
        this.bidding,
        this.exchange,
        this.createdAt,
        this.updatedAt,
        this.images,
        this.category,
        this.subCategory,
        this.childCategory});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    childCategoryId = json['child_category_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    type = json['type'];
    phone = json['phone'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    postcode = json['postcode'];
    video = json['video'];
    buynow = json['buynow'];
    bidding = json['bidding'];
    exchange = json['exchange'];
    condition = json['condition'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    biddingEnd = json['bid_end'];
    location = json['location'];
    this.viewsCount = json['views'] != null ? json['views'].toString() : "0";

    if(this.type.toString().toLowerCase().contains("exchange") && json['exchange_product_attributes'] != null) {
      wishCategory = json['exchange_product_attributes']['category'] != null
          ? new Category.fromJson(json['exchange_product_attributes']['category'])
          : null;
      wishSubCategory = json['exchange_product_attributes']['sub_category'] != null
          ? new SubCategory.fromJson(json['exchange_product_attributes']['sub_category'])
          : null;
      wishChildCategory = json['exchange_product_attributes']['child_category'] != null
          ? new ChildCategory.fromJson(json['exchange_product_attributes']['child_category'])
          : null;

      this.keyword = json['exchange_product_attributes']['keyword'];
      this.range = json['exchange_product_attributes']['range'];
      this.minPrice = json['exchange_product_attributes']['minprice'];
      this.maxPrice = json['exchange_product_attributes']['maxprice'];
      this.wishLocation = json['exchange_product_attributes']['location'];
      this.wishCondition = json['exchange_product_attributes']['condition'];

      if(json['exchange_product_attributes']['attributes'] != null) {
        wishAttrs = <Attribute>[];
        json['exchange_product_attributes']['attributes'].forEach((v) {
          var attr = Attribute.fromJson(v['attribute']);
          attr.valueToSend = v['value'];
          wishAttrs.add(attr);
        });
      }
    }

    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
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
    user = json['user'] != null
        ? new User.fromJson(json['user'])
        : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['attributes'] != null) {
      attrs = <Attribute>[];
      json['attributes'].forEach((v) {
        var attr = Attribute.fromJson(v['attribute']);
        attr.valueToSend = v['value'];
        attrs.add(attr);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['child_category_id'] = this.childCategoryId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['type'] = this.type;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['city'] = this.city;
    data['address'] = this.address;
    data['postcode'] = this.postcode;
    data['video'] = this.video;
    data['buynow'] = this.buynow;
    data['bidding'] = this.bidding;
    data['exchange'] = this.exchange;
    data['condition'] = this.condition;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
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


  setRelatedProducts(List json) {
    relatedProducts = <Product>[];
    json.forEach((v) {
      relatedProducts.add(new Product.fromJson(v));
    });
  }

}