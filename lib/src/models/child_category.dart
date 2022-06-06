class ChildCategory {
  var id;
  var categoryId;
  var subCategoryId;
  var name;
  var image;

  ChildCategory(
      {this.id,
        this.categoryId,
        this.subCategoryId,
        this.name,});

  ChildCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['name'] = this.name;
    return data;
  }
}