import 'package:iExchange_it/src/models/sub_category.dart';

class Category {
  var id;
  var name;
  var image;
  List<SubCategory>? subcategory;

  Category({this.id, this.name, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    if (json['subcategory'] != null) {
      subcategory = <SubCategory>[];
      json['subcategory'].forEach((v) {
        subcategory!.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}