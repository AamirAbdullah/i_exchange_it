import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/sub_category.dart';

import 'package:http/http.dart' as http;
// Todo
Future<Stream<Category>> getCategories() async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}category';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getCategoriesData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    // print(data);
    return Category.fromJson(data);
  });
}

Future<Stream<SubCategory>> getSubCategories(var catId) async {
  var categoryId = '?category_id=$catId';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}subcategory/fetch$categoryId';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getSubCategoriesData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return SubCategory.fromJson(data);
  });
}

Future<Stream<ChildCategory>> getChildCategories(var subCatId) async {
  var categoryId = '?subcategory_id=$subCatId';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}childcategory/fetch$categoryId';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map(
          (data) => Helper.getChildCategoriesData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return ChildCategory.fromJson(data);
  });
}
