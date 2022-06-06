import 'package:iExchange_it/src/models/product.dart';

class MyBanner {
  var id;
  var image;
  var productId;
  String? createdAt;
  String? updatedAt;
  Product? product;

  MyBanner(
      {this.id,
        this.image,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.product});

  MyBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}