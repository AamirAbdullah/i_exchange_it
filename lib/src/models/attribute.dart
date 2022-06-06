import 'package:iExchange_it/src/models/option.dart';

class Attribute {
  var id;
  var categoryId;
  var subCategoryId;
  var childCategoryId;
  var title;
  var type;
  var handler;
  var createdAt;
  var updatedAt;
  List<Option>? options;

  var valueToSend;

  var valueToSend2;

  Attribute(
      {this.id,
        this.categoryId,
        this.subCategoryId,
        this.childCategoryId,
        this.title,
        this.type,
        this.handler,
        this.createdAt,
        this.updatedAt});

  Attribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    childCategoryId = json['child_category_id'];
    title = json['title'];
    type = json['type'];
    handler = json['handler'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['options'] != null) {
      options = <Option>[];
      json['options'].forEach((v) {
        options!.add(new Option.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['child_category_id'] = this.childCategoryId;
    data['title'] = this.title;
    data['type'] = this.type;
    data['handler'] = this.handler;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}