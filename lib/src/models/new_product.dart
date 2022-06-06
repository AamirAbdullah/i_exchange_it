// ignore_for_file: unnecessary_statements

import 'package:iExchange_it/src/models/attribute.dart';
import 'package:iExchange_it/src/models/images.dart';
import 'package:iExchange_it/src/models/media.dart';

class NewProduct {

  var id;
  var name;
  var description;
  var type;
  String? phone = "";
  var price;
  var video;

  var country;
  var city;
  var address;
  var location;
  var lat;
  var long;
  var postalCode;

  var condition;
  List<Media>? mediaList = <Media>[];
  List<Images>? images;

  var categoryId;
  var subCategoryId;
  var childCategoryId;

  List<Attribute> attrs = <Attribute>[];

  var bidding;
  var biddingEnd;

  var wishCategoryId;
  var wishSubCategoryId;
  var wishChildCategoryId;
  var keyword;
  var range;
  var minPrice;
  var maxPrice;
  var wishLocation; ///City
  var wishCondition;
  List<Attribute> wishAttrs = <Attribute>[];

  List<String> imagesToRemove = <String>[]; ///Ids of images to remove

  NewProduct({this.name,
    this.description, this.type,
    this.phone = "", this.price = 0,
    this.mediaList,
    this.video = "",
    this.bidding = 0,
    this.biddingEnd = "",
  });


  Map<String, String> toJson() {
    Map<String, String> map = Map<String, String>();
    this.id != null ? map['product_id'] = this.id.toString() : null;
    map['name'] = this.name.toString();
    map['description'] = this.description.toString();
    map['type'] = this.type.toString().toLowerCase();
    map['price'] = this.price.toString();
    map['phone'] = this.phone.toString();
    map['video'] = this.video.toString();
    map['postcode'] = this.postalCode.toString();
    map['address'] = this.address.toString();
    map['country'] = this.country.toString();
    map['city'] = this.city.toString();
    map['location'] = this.location.toString();
    map['category_id'] = this.categoryId.toString();
    map['sub_category_id'] = this.subCategoryId.toString();
    map['child_category_id'] = this.childCategoryId.toString();
    map['bidding'] = this.bidding.toString();
    map['condition'] = this.condition.toString();
    map['latitude'] = this.lat.toString();
    map['longitude'] = this.long.toString();
    this.biddingEnd != null ? map['bid_end'] = this.biddingEnd.toString() : null;

    if(this.type.toString().toLowerCase().contains("exchange")) {
      this.wishCategoryId != null ? map['wish_category_id'] = this.wishCategoryId.toString() : null;
      this.wishSubCategoryId != null ? map['wish_sub_category_id'] = this.wishSubCategoryId.toString() : null;
      this.wishChildCategoryId != null ? map['wish_child_category_id'] = this.wishChildCategoryId.toString() : null;
      this.keyword != null ? map['keyword'] = this.keyword.toString() : null;
      this.range != null ? map['range'] = this.range.toString() : null;
      this.minPrice != null ? map['minprice'] = this.minPrice.toString() : null;
      this.maxPrice != null ? map['maxprice'] = this.maxPrice.toString() : null;
      this.wishLocation != null ? map['wish_location'] = this.wishLocation.toString() : null;
      this.wishCondition != null ? map['wish_condition'] = this.wishCondition.toString() : null;

      if(this.wishAttrs.isNotEmpty) {
        this.wishAttrs.forEach((element) {
          map['wish_attrs[${element.id}]'] = element.valueToSend.toString();
        });
      }
    }

    if(this.attrs.isNotEmpty) {
      this.attrs.forEach((element) {
        map['attrs[${element.id}]'] = element.valueToSend.toString();
      });
    }
    return map;
  }

}