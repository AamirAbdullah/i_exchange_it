import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:iExchange_it/src/models/review.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

Future<Stream<Review>> getReviewsOfProduct(String productID) async {
  final String _id = '?product_id=$productID';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}product/reviews$_id';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getReviewsData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return Review.fromJson(data);
  });
}

Future<Review?> createReview(Review _review) async {
  Review? rev;
  User _currentUser = await userRepo.getCurrentUser();
  final String _apiToken = '?api_token=${_currentUser.apiToken}';
  final String _prodId = '&product_id=${_review.productId.toString()}';
  final String _cmnt = '&comment=${_review.comment.toString()}';
  Map<String, String> body = Map<String, String>();
  body['api_token'] = _currentUser.apiToken.toString();
  body['product_id'] = _review.productId.toString();
  body['comment'] = _review.comment.toString();
  final String url = '${GlobalConfiguration().getValue('api_base_url')}make/review$_apiToken$_prodId$_cmnt';
  print(url);
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);
    if (json.decode(body)['review'] != null) {
      rev = Review.fromJson(json.decode(body)['review']);
    }
  } else {
    print(response.body);
  }
  return rev;
}

Future<Review?> changeReviewStatus(Review _review) async {
  Review? rev;
  User _currentUser = await userRepo.getCurrentUser();
  final String _apiToken = '?api_token=${_currentUser.apiToken}';
  final String _reviewId = '&review_id=${_review.id.toString()}';
  Map<String, String> body = Map<String, String>();
  body['api_token'] = _currentUser.apiToken.toString();
  body['review_id'] = _review.id.toString();
  final String url = '${GlobalConfiguration().getValue('api_base_url')}review/status/change$_apiToken$_reviewId';
  print(url);
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);
    if (json.decode(body)['review'] != null) {
      rev = Review.fromJson(json.decode(body)['review']);
    }
  } else {
    print(response.body);
  }
  return rev;
}