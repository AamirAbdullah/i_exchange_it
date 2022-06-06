import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:http/http.dart' as http;
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/models/wishlist_got.dart';
import 'package:iExchange_it/src/models/wishlist_item.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

Future<bool> addWishlistItem(WishlistItem item) async {
  User _currentUser = await userRepo.getCurrentUser();
  Map body = item.toJson();
  body['api_token'] = _currentUser.apiToken;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}wishlist/add';
  http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse(url));
  request.fields.addAll(body as Map<String, String>);
  var response = await request.send();

  if(response.statusCode == 200) {
    return true;
  } else {
    response.stream
    .handleError((e){
      print(e);
    })
        .transform(utf8.decoder)
        .transform(json.decoder)
    .expand((element) {
      return element as Iterable;
    })
        .map((event) {
          print(event.toString());
    });
    return false;
  }

  // return response.stream
  //     .transform(utf8.decoder)
  //     .transform(json.decoder)
  // .cast();
  //     // .map((data) {
  //     //   print(data);
  //     //   var d = data;
  //     //   return true;
  //     // });

  // final client = new http.Client();
  // var jsonBdy = json.encode(body);
  // final response = await client.post(
  //   url,
  //   headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //   body: json.encode(body),
  // );
  // if (response.statusCode == 200) {
  //   print(response.body);
  //   isAdded = true;
  // } else {
  //   print(response.body);
  // }
  // return isAdded;
}

Future<Stream<WishlistGot>> getMyWishlist() async {
  User _currentUser = await userRepo.getCurrentUser();
  final String _apiToken = '?api_token=${_currentUser.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}wishlist/user$_apiToken';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
        Helper.getWishlistData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
        return WishlistGot.fromJson(data);
      });
}

Future<bool> deleteWishlistItem(WishlistGot item) async {
  bool isDeleted = false;
  User _currentUser = await userRepo.getCurrentUser();
  Map<String, String> body = Map<String, String>();
  body['api_token'] = _currentUser.apiToken.toString();
  body['wishlist_id'] = item.id.toString();
  final String url = '${GlobalConfiguration().getValue('api_base_url')}wishlist/delete';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    print(response.body);
    isDeleted = true;
  } else {
    print(response.body);
  }
  return isDeleted;
}