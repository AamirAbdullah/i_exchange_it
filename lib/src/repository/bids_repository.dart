import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:iExchange_it/src/models/bid.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

Future<Stream<Bid>> getOffersPlaced() async {
  User _currentUser = await userRepo.getCurrentUser();
  final String _apiToken = '?api_token=${_currentUser.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}user/bids$_apiToken';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getBidsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Bid.fromJson(data);
  });

}

Future<Stream<Bid>> getOffersReceived() async {
  User _currentUser = await userRepo.getCurrentUser();
  final String _apiToken = '?api_token=${_currentUser.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}bids/user/products$_apiToken';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getBidsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Bid.fromJson(data);
  });

}

Future<Bid?> placeBid(Bid bid) async {
  Bid? _bid;
  User _currentUser = await userRepo.getCurrentUser();
  final String url = '${GlobalConfiguration().getValue('api_base_url')}make/bid';
  final client = new http.Client();
  Map<String, dynamic> body = Map<String, dynamic>();
  body['price'] = bid.price;
  body['message'] = bid.message;
  body['product_id'] = bid.productId;
  body['p_user_id'] = bid.userId;
  body['api_token'] = _currentUser.apiToken;
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);
    if (!body.toString().toLowerCase().contains("you cannot bid") && json.decode(body) != null && json.decode(body)['bid'] != null) {
      _bid = Bid.fromJson(json.decode(body)['bid']);
    }
  }
  return _bid;
}