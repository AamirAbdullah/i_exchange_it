// ignore_for_file: unnecessary_statements

import 'package:iExchange_it/src/models/product.dart';

class User {

  bool isNewImage = false;
  late var newImgIdentifier;
  var newImgName;

  var id;
  var name;
  var image;
  var phone;

  var email;
  var emailVerifiedAt;
  var apiToken;
  var password;
  var firebaseToken;

  var address;
  bool followed = false;

  List<Product>? products;

  bool alreadyExists = false;

  User({this.id, this.name, this.image, this.alreadyExists = false, this.followed = false,});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    address = json['address'];
    firebaseToken = json['firebase_token'];
    emailVerifiedAt = json['email_verified_at'];
    apiToken = json['api_token'];
    followed = json['followed'] != null ? json['followed'] == true || json['followed'] == 'true' ? true : false : false;

    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['id'] = this.id.toString();
    data['name'] = this.name.toString();
    data['email'] = this.email.toString();
    this.phone != null ? data['phone'] = this.phone.toString() : null;
    this.password != null ? data['password'] = this.password.toString() : null;
    this.address != null ? data['address'] = this.address.toString() : null;
    data['firebase_token'] = this.firebaseToken.toString();
    data['api_token'] = this.apiToken.toString();
    return data;
  }

}