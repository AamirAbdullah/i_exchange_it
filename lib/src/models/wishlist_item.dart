import 'package:iExchange_it/src/models/attribute.dart';

class WishlistItem {

  var keyword;
  var postCode;
  var categoryId;
  var subCategoryId;
  var childCategoryId;
  var location; //City name
  var condition;
  var type;
  var minPrice;
  var maxPrice;
  var latitude;
  var longitude;
  var duration = "all";
  List<Attribute> attrs = <Attribute>[];
  var range;

  WishlistItem({this.duration = "all", this.minPrice=0, this.maxPrice = 0});


  Map<String, String?> toJson() {
    Map<String, dynamic> map = Map<String, String>();
    map['keyword'] = this.keyword.toString();
    map['postcode'] = this.postCode.toString();
    map['category_id'] = this.categoryId.toString();
    map['sub_category_id'] = this.subCategoryId.toString();
    map['child_category_id'] = this.childCategoryId.toString();
    map['location'] = this.location.toString();
    map['condition'] = this.condition.toString();
    map['type'] = this.type.toString();
    map['minprice'] = this.minPrice.toString();
    map['maxprice'] = this.maxPrice.toString();
    map['latitude'] = this.latitude.toString();
    map['longitude'] = this.longitude.toString();
    map['range'] = this.range.toString();
    map['duration'] = this.duration.toString();
    if(this.attrs.isNotEmpty) {
      this.attrs.forEach((element) {

        if(element.type == 'input') {
          map['attrs[${element.id}][0]'] = element.valueToSend.toString();
          map['attrs[${element.id}][1]'] = element.valueToSend2.toString();
        } else {
          map['attrs[${element.id}]'] = element.valueToSend.toString();
        }
      });
    }
    return map as Map<String, String?>;
  }

}