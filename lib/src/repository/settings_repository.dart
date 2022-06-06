import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/models/setting.dart';
import 'package:http/http.dart' as http;

ValueNotifier<Settings> setting = new ValueNotifier(new Settings());

List<String> suggestions = [];


Future<Stream<String>> getSuggestions({String? sortby, String? order}) async {
  String url = '${GlobalConfiguration().getValue('api_base_url')}product/names';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      // .map((data) =>
      // Helper.getProductsData(data))
      .expand((element) => element as Iterable)
      .map((data) {
    return data;
  });

}


Future<bool> isInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    else
    {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

showToast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,

    backgroundColor: Colors.black38,
    textColor: Colors.white60,
    fontSize: 13.0,
  );
}