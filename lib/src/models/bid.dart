import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/user.dart';

class Bid {
  var buyerId;
  var userId;
  var price;
  var message;
  var productId;
  var updatedAt;
  var createdAt;
  var id;

  var status;
  Product? product;
  User? user;

  Bid(
      {this.buyerId,
        this.userId,
        this.price,
        this.message,
        this.productId,
        this.updatedAt,
        this.createdAt,
        this.id});

  Bid.fromJson(Map<String, dynamic> json) {
    buyerId = json['buyer_id'];
    userId = json['user_id'];
    price = json['price'];
    message = json['message'];
    productId = json['product_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    status = json['status'] ?? "";
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buyer_id'] = this.buyerId;
    data['user_id'] = this.userId;
    data['price'] = this.price;
    data['message'] = this.message;
    data['product_id'] = this.productId;
    data['id'] = this.id;
    return data;
  }
}