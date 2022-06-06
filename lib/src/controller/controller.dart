
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;
import 'package:iExchange_it/src/repository/settings_repository.dart'
    as settingRepo;

class Controller extends ControllerMVC {
  User? currentUser;
  GlobalKey<ScaffoldState>? scaffoldKey;

  Controller() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    userRepo.getCurrentUser().then((user) {
      setState(() {
        userRepo.currentUser = user;
        this.currentUser = user;
      });
    });
    Firebase.initializeApp();
    getSuggestions();
    super.initState();
  }

  getSuggestions() async {
    Stream<String> stream = await settingRepo.getSuggestions();
    stream.listen((event) {
      print(event);
      settingRepo.suggestions.add(event);
    }, onError: (e) {
      print(e);
    }, onDone: () {});
  }

  void initFCM() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    if (this.currentUser != null) {
      _firebaseMessaging.getToken().then((_token) async {
        this.currentUser!.firebaseToken = _token;
        Stream<User> stream = await userRepo.updateUser(currentUser!);
        stream.listen((event) {}, onError: (e) {}, onDone: () {});
      });

      _firebaseMessaging.requestPermission(alert: true);
      FirebaseMessaging.onMessage.listen((event) {
        onMessage(event.data);
      });
    }
  }

  static void onMessage(Map<String, dynamic> message) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('noti_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // icon: android?.smallIcon,
              // other properties...
            ),
            iOS: IOSNotificationDetails(
                badgeNumber: 0,
                presentAlert: true,
                presentSound: true,
                presentBadge: true)));
  }

  static Future<dynamic>? onDidReceiveLocalNotification(
      int id, String? a, String? b, String? c) {
        return null;
      
    
  }

  static Future<dynamic> myBackgroundMessageHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    Controller.onMessage(message.data);

    // Or do other work.
  }
}
