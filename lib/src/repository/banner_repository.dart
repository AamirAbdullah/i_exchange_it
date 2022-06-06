import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:iExchange_it/src/models/banner.dart';
import 'package:http/http.dart' as http;

Future<Stream<MyBanner>> getHomeBanners() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}banner/fetch';
  final client = new http.Client();
  final streamedRest =await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) =>
      Helper.getBannersData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    return MyBanner.fromJson(data);
  });

}