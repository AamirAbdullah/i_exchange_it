import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/src/helper/helper.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;


User currentUser = new User();


Future<User> login(User user) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}login';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toJson()),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);
    if (json.decode(body)['user'] != null) {
      setCurrentUser(body);
      currentUser = User.fromJson(json.decode(body)['user']);
    }
  }
  return currentUser;
}

Future<User> register(User user) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toJson()),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);
    if (json.decode(body)['user'] != null) {
      setCurrentUser(body);
      currentUser = User.fromJson(json.decode(body)['user']);
    }
  }
  return currentUser;
}

Future<User> socialLogin(User user, String _method) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}social/login';
  final client = new http.Client();

  var body = user.toJson();
  body['type'] = _method;//facebook or google

  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);

    if(response.body.toString().toLowerCase().contains("already")) {

      currentUser = User();
      currentUser.alreadyExists = true;

    } else {

      if (json.decode(body)['user'] != null) {
        setCurrentUser(body);
        currentUser = User.fromJson(json.decode(body)['user']);
        currentUser.alreadyExists = false;
      }

    }
  }
  return currentUser;
}

Future<Stream<User>> updateUser(User _user) async {
  User _currentUser = await getCurrentUser();
  final String _apiToken = 'api_token=${_currentUser.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}user/update?$_apiToken';


  http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse(url));
  var mapBody = _user.toJson();
  request.fields.addAll(mapBody);
  request.fields["user_id"] = _user.id.toString();

  if(_user.isNewImage) {
    var file = await http.MultipartFile.fromPath(
        "image", _user.newImgIdentifier, filename: _user.newImgName,
        contentType: parser.MediaType.parse("application/octet-stream"));
    request.files.add(file);
  }


  Map<String, String> headers = {
    "Accept": "application/json",
  };

  request.headers.addAll(headers);
  var response = await request.send();

  return response.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) {
    // ignore: unused_local_variable
    var d = data;
    setCurrentUser(json.encode(data));
    return User.fromJson(Helper.getUserData(data as Map<String, dynamic>));
  });
}

Future<User?> getUserProfile(String userId) async {
  User? _user;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}userbyid';
  Map<String, String> body = Map<String, String>();
  body['user_id'] = userId;
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);
    if (json.decode(body)['user'] != null) {

      var _newUserDetails = json.decode(body)['user'];

      if(json.decode(body)['products'] != null) {
        _newUserDetails['products'] = json.decode(body)['products'];
      }

      _user = User.fromJson(_newUserDetails);
    }
  }
  return _user;
}

Future<bool> followUser(User user) async {
  bool isFollowed = false;
  User _currentUser = await getCurrentUser();
  final String url = '${GlobalConfiguration().getValue('api_base_url')}user/follow';
  Map<String, dynamic> body = Map<String, dynamic>();
  body['api_token'] = _currentUser.apiToken;
  body['user_id'] = user.id;
  final client = new http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    var body = response.body;
    print(body);
    if (json.decode(body)['error'] == 'false' || json.decode(body)['error'] == false) {
      isFollowed = true;
    }
  }
  return isFollowed;
}


void setCurrentUser(jsonString) async {
  if (json.decode(jsonString)['user'] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(json.decode(jsonString)['user']));
  }
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('current_user')) {
    currentUser = User.fromJson(json.decode(await (prefs.get('current_user') as FutureOr<String>)));
  }
  return currentUser;
}

Future<void> logout() async {
  currentUser = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

