import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:iExchange_it/src/models/new_product.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/models/attribute.dart';

import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

Future<Stream<Attribute>> getAttributes(String childCatId) async {
  final String _catId = '?child_category_id=$childCatId';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}childcategory/attributes$_catId';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
          Helper.getChildCategoryAttributeData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Attribute.fromJson(data);
  });
}

Future<Stream<Product>> addProduct(NewProduct _product) async {
  User _currentUser = await userRepo.getCurrentUser();
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}product/add';
  var bodyMap = _product.toJson();
  bodyMap['api_token'] = _currentUser.apiToken;
  print(bodyMap);

  // create multipart request
  http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse(url));
  request.fields.addAll(bodyMap);
  for (int i = 0; i < _product.mediaList!.length; i++) {
    var element = _product.mediaList![i];
    var file = await http.MultipartFile.fromPath("images[]", element.identifier,
        filename: element.name,
        contentType: parser.MediaType.parse("application/octet-stream"));
    request.files.add(file);
  }

  Map<String, String> headers = {
    "Accept": "application/json",
  };
  request.headers.addAll(headers);
  var response = await request.send();

  return response.stream
      .handleError((e) {
        print(e);
      })
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) {
        print(data);
        var d = Helper.getProductData(data as Map<String, dynamic>);
        return Product.fromJson(d);
      });
}

Future<Stream<Product>> updateProduct(NewProduct _prod) async {
  User _currentUser = await userRepo.getCurrentUser();
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}product/update';
  // var bodyMap = _prod.toJson();
  // bodyMap['location'] = '${_prod.lat},${_prod.long}';
  // final client = new http.Client();
  // final response = await client.post(
  //   Uri.parse(url),
  //   headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //   body: json.encode(bodyMap),
  // );
  // if (response.statusCode == 200) {
  //   print(response.body);
  //   if (json.decode(response.body)['product'] != null) {
  //     _product = Product.fromJson(json.decode(response.body)['product']);
  //   }
  // } else {
  //   print(response.body);
  // }
  // return _product;

  var bodyMap = _prod.toJson();
  bodyMap['api_token'] = _currentUser.apiToken;
  bodyMap['location'] = '${_prod.lat},${_prod.long}';
  print(bodyMap);

  if (_prod.imagesToRemove.isNotEmpty) {
    // bodyMap['del_img_ids[]'] = '';
    for (int i = 0; i < _prod.imagesToRemove.length; i++) {
      bodyMap['del_img_ids[$i]'] = '${_prod.imagesToRemove[i]}';
      // bodyMap['del_img_ids[]'] += ',';
    }
    // bodyMap['del_img_ids[]'] = bodyMap['del_img_ids[]'].substring(0, bodyMap['del_img_ids[]'].length-1);
    // bodyMap['del_img_ids[]'] += ']';
  }

  // create multipart request
  http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse(url));
  request.fields.addAll(bodyMap);
  if (_prod.mediaList != null && _prod.mediaList!.isNotEmpty) {
    for (int i = 0; i < _prod.mediaList!.length; i++) {
      var element = _prod.mediaList![i];
      var file = await http.MultipartFile.fromPath(
          "images[]", element.identifier,
          filename: element.name,
          contentType: parser.MediaType.parse("application/octet-stream"));
      request.files.add(file);
    }
  }

  Map<String, String> headers = {
    "Accept": "application/json",
  };
  request.headers.addAll(headers);
  var response = await request.send();

  return response.stream
      .handleError((e) {
        print(e);
      })
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) {
        print(data);
        var d = Helper.getProductData(data as Map<String, dynamic>);
        return Product.fromJson(d);
      });
}
