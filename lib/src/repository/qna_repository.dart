import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:iExchange_it/src/models/question.dart';
import 'package:iExchange_it/src/models/user.dart';

import 'package:http/http.dart' as http;

import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

Future<Stream<Question>> getAllQuestions() async {
  String url = '${GlobalConfiguration().getValue('api_base_url')}all/question';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('post', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getQuestionData(data as Map<String, dynamic>))
      .expand((element) => element)
      .map((data) {
    // ignore: unused_local_variable
    var d = data;
    return Question.fromJson(data);
  });
}

Future<Question?> createQuestion(String? _question) async {
  Question? ques;
  User _currentUser = await userRepo.getCurrentUser();
  Map<String, String> body = Map<String, String>();
  body['api_token'] = _currentUser.apiToken.toString();
  body['question'] = _question.toString();
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}question/add';
  print(url);
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: "application/json"},
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);
    if (json.decode(body)['question'] != null) {
      ques = Question.fromJson(json.decode(body)['question']);
    }
  } else {
    print(response.body);
  }
  return ques;
}
