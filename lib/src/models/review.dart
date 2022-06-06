import 'package:iExchange_it/src/models/product.dart';

class Review {
  var id;
  var userId;
  var productId;
  var comment;
  var status;
  var createdAt;
  var updatedAt;
  Product? product;

  Review(
          {
            this.id,
            this.userId,
            this.productId,
            this.comment,
            this.createdAt,
            this.updatedAt
          }
      );

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['comment'] = this.comment;
    return data;
  }

}