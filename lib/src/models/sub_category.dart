import 'package:iExchange_it/src/models/child_category.dart';

class SubCategory {
  var id;
  var categoryId;
  var name;
  var image;
  List<ChildCategory>? childCategory;

  SubCategory(
      {this.id,
        this.categoryId,
        this.name,
        this.childCategory});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    image = json['image'];
    if (json['child_category'] != null) {
      childCategory = <ChildCategory>[];
      json['child_category'].forEach((v) {
        childCategory!.add(new ChildCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    if (this.childCategory != null) {
      data['child_category'] =
          this.childCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}