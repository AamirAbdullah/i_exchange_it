// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:http/http.dart' as http;
import 'package:iExchange_it/src/models/category2.dart';
import 'package:iExchange_it/src/models/images.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/pages/search/detail_Search.dart';

import '../models/attribute.dart';

Future<Stream<Product>> searchProductWithoutFilters(
    String keyword, String? lat, String? long, String range) async {
  final String _keyword = '?keyword=$keyword';
  final String _lat = '&latitude=$lat';
  final String _long = '&longitude=$long';
  final String _range = '&range=$range';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}search$_keyword$_lat$_long$_range';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getProductsData(data as Map<String, dynamic>))
      .expand((element) {
    return element;
  }).map((data) {
    var d = data;
    return Product.fromJson(data);
  });
}

Future<Stream<Product>> searchProductWithFilters(
    var keyword,
    var postCode,
    var type,
    var location,
    var categoryId,
    var subCatId,
    var childCat,
    var condition,
    var minPrice,
    var maxPrice,
    var duration,
    String? lat,
    String? long,
    String range,
    {List<Attribute> attrs: const <Attribute>[]}) async {
  final String _keyword = '?keyword=$keyword';
  final String _postCode = '&postcode=$postCode';
  final String _type = '&type=$type';
  final String _location = '&location=$location';
  final String _catId = '&category_id=$categoryId';
  final String _subCat = '&sub_category_id=$subCatId';
  final String _childCat = '&child_category_id=$childCat';
  final String _condition = '&condition=$condition';
  final String _minPrice = '&minprice=$minPrice';
  final String _maxPrice = '&maxprice=$maxPrice';
  final String _duration = '&duration=$duration';

  final String _lat = '&latitude=$lat';
  final String _long = '&longitude=$long';
  final String _range = '&range=$range';

  Map<String, String> bodyMap = Map<String, String>();
  bodyMap['keyword'] = keyword.toString();
  bodyMap['postcode'] = postCode.toString();
  bodyMap['type'] = type.toString();
  bodyMap['location'] = location.toString();
  bodyMap['category_id'] = categoryId.toString();
  bodyMap['sub_category_id'] = subCatId.toString();
  bodyMap['child_category_id'] = childCat.toString();
  bodyMap['condition'] = condition.toString();
  bodyMap['minprice'] = minPrice.toString();
  bodyMap['maxprice'] = maxPrice.toString();
  bodyMap['duration'] = duration.toString();
  bodyMap['latitude'] = lat.toString();
  bodyMap['longitude'] = long.toString();
  bodyMap['range'] = range.toString();

  // bodyMap['keyword'] = "";
  // bodyMap['postcode'] = "";
  // bodyMap['type'] = "";
  // bodyMap['location'] = "";
  // bodyMap['category_id'] = "";
  // bodyMap['sub_category_id'] = "";
  // bodyMap['child_category_id'] = "";
  // bodyMap['condition'] = "";
  // bodyMap['minprice'] = "";
  // bodyMap['maxprice'] = "";
  // bodyMap['duration'] = "all";
  // bodyMap['latitude'] = "";
  // bodyMap['longitude'] = "";
  // bodyMap['range'] = "";

  String url = '${GlobalConfiguration().getValue('api_base_url')}detail/search';

  if (attrs.isNotEmpty) {
    attrs.forEach((element) {
      bodyMap['attrs[${element.id}]'] = element.valueToSend.toString();
    });
  }

  // final client = new http.Client();
  //
  // var req = http.Request('post', Uri.parse(url));
  // req.bodyFields = bodyMap;

  http.MultipartRequest request = http.MultipartRequest('post', Uri.parse(url));
  request.fields.addAll(bodyMap);
  var response = await request.send();

  // final streamedRest =await client.send(req);

  return response.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) {
        print(data);
        return Helper.getProductsData(data as Map<String, dynamic>);
      })
      .expand((element) => element)
      .map((data) {
        var d = data;
        return Product.fromJson(data);
      });
}

Future<List<CategorySearch>> searchbycategory({searchtext, categoryid}) async {
  List<Images> image = [];
  print('Enter in api');
  // print(searchtext+categoryid.toString());
  var apiURL = 'https://iexchangeit.nbrarts.com/api/categorybyid';

  var formData = FormData.fromMap({
    'category_id': categoryid,
    'search_text': searchtext,
  });
  Dio dio = Dio();
  Response responce;
  try {
    responce = await dio.post(
      apiURL,
      data: formData,
    );
    if (responce.statusCode == 200) {
      if (responce.data['error'] == false) {
        var res=responce.data['category'];
        var resp=res['products'];
        print(resp);
        for (var r in resp) {
          var id = r["id"];
          var name = r["name"] ?? '';
          var type = r["type"] ?? '';
          var price =r ['price']??'';
          var country = r["country"] ?? '';
          var images = r["images"] ?? '';
          for (var i in images ){
            var id1=i["id"] ?? '';
            var productId=i["product_id"] ?? '';
            var path=i["path"] ?? '';
            var createdAt=i["created_at"] ?? '';
            var updatedAt=i["updated_at"] ?? '';
            Images img=Images(
              id: id1,
              productId: productId,
              path: path,
              createdAt: createdAt,
              updatedAt: updatedAt
            );
            image.add(img);
            print('llllllllllllllllllllllllllll');
            print(image);
          }
          print(price);
          CategorySearch category = CategorySearch(
              id:id,
              name:name,
              type:type,
              price: price,
              country:country,
              images: image,
              );
          categorys.add(category);
        }
        print('llllllllllllllllll');
        print(categorys);
        return categorys;
      } else if (responce.data['error'] == true) {
        print('error in api');
      } else {
        return [];
      }
    }
  } catch (e) {
    // print(e);
    Fluttertoast.showToast(
      msg: "bad Internet request",
    );
    return [];
  }

  return [];
}
