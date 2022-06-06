import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:iExchange_it/src/models/user.dart';

import 'package:http/http.dart' as http;

import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

Future<Stream<Product>> getFeaturedProducts({String? sortby, String? order}) async {
  String url = '${GlobalConfiguration().getValue('api_base_url')}product/featured';

  if(sortby != null && order != null && sortby.length >0 && order.length > 0) {
    String sort = "?by=$sortby";
    String ordr = "&order=$order";
    url+=sort;
    url+=ordr;
  }

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getProductsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Product.fromJson(data);
  });

}

Future<Stream<Product>> getPopularProducts({String? sortby, String? order}) async {
  String url = '${GlobalConfiguration().getValue('api_base_url')}product/papular';

  if(sortby != null && order != null && sortby.length >0 && order.length > 0) {
    String sort = "?by=$sortby";
    String ordr = "&order=$order";
    url+=sort;
    url+=ordr;
  }

  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getProductsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Product.fromJson(data);
  });

}

Future<Stream<Product>> getRecentProducts({String? sortby, String? order}) async {
  String url = '${GlobalConfiguration().getValue('api_base_url')}product/recent';

  if(sortby != null && order != null && sortby.length >0 && order.length > 0) {
    String sort = "?by=$sortby";
    String ordr = "&order=$order";
    url+=sort;
    url+=ordr;
  }

  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getProductsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Product.fromJson(data);
  });

}

Future<Stream<Product>> getFollowedUsersProducts() async {
  User _currentUser = await userRepo.getCurrentUser();
  var apiToken = '?api_token=${_currentUser.apiToken}';
  String url = '${GlobalConfiguration().getValue('api_base_url')}follow/user/products$apiToken';

  http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse(url));
  request.fields.addAll({'api_token': '${_currentUser.apiToken}'});

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
  request.headers.addAll(headers);
  var response = await request.send();
  return response.stream
      .handleError((e){
    print(e);
  })
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getProductsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .expand((element) => element)
  .map((data) {
    return Product.fromJson(data);
  });

}

Future<Stream<Product>> getProductDetails(var productId) async {
  var prodId = '?product_id=$productId';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}product/detail$prodId';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => data)
      .map((data) {

    var prodData = Helper.getProductData(data as Map<String, dynamic>);
    var relatedData = Helper.getRelatedProductData(data);

    Product _prod = Product.fromJson(prodData);
    if(relatedData != null && relatedData != "Not Found") {
      _prod.setRelatedProducts(relatedData);
    }

    return _prod;
  });

}

Future<Stream<Product>> getProductsByCategory(var catId) async {
  final String _catId = '?category_id=$catId';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}category/products$_catId';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getCategoryProductData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Product.fromJson(data);
  });

}

Future<Stream<Product>> getProductsBySubCategory(var catId) async {
  final String _catId = '?sub_category_id=$catId';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}subcategory/products$_catId';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getChildCategoryProductData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Product.fromJson(data);
  });

}

Future<Stream<Product>> getProductsByChildCategory(var catId) async {
  final String _catId = '?child_category_id=$catId';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}childcategory/products$_catId';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getChildCategoryProductData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    // ignore: unused_local_variable
    var d = data;
    return Product.fromJson(data);
  });

}

Future<Stream<Product>> getUserProducts(var userId) async {
  final String _userId = '?user_id=$userId';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}user/products$_userId';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getProductsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Product.fromJson(data);
  });

}

Future<Stream<Product>> getMyProducts() async {
  User _currentUser = await userRepo.getCurrentUser();
  final String _userId = '?user_id=${_currentUser.id}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}user/products$_userId';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getProductsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    // ignore: unused_local_variable
    var d = data;
    return Product.fromJson(data);
  });

}

Future<bool> deleteProduct(var productId) async {
  bool isDeleted = false;
  var prodId = '?product_id=$productId';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}product/delete$prodId';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  if (response.statusCode == 200) {
    isDeleted = true;
  }
  return isDeleted;

}

Future<bool> addToFavorite(var productId) async {
  bool isAdded = false;
  User _currentUser = await userRepo.getCurrentUser();
  var prodId = '?product_id=$productId';
  final String _userId = '&user_id=${_currentUser.id}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favourite/add$prodId$_userId';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  if (response.statusCode == 200) {
    isAdded = true;
  }
  return isAdded;
}

Future<bool> removeFavorite(var productId) async {
  bool isRemoved = false;
  User _currentUser = await userRepo.getCurrentUser();
  var prodId = '?product_id=$productId';
  final String _userId = '&user_id=${_currentUser.id}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favourite/delete$prodId$_userId';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  if (response.statusCode == 200) {
    isRemoved = true;
  }
  return isRemoved;
}

Future<Stream<Product>> getFavoriteProducts() async {
  User _currentUser = await userRepo.getCurrentUser();
  final String _userId = '?user_id=${_currentUser.id}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favourite/user$_userId';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getFavoritesData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    var d = data['product'];
    return Product.fromJson(d);
  });

}