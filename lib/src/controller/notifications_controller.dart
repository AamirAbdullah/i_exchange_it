import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/notification_model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class NotificationsController extends ControllerMVC {

  List<NotificationModel> notifications = <NotificationModel>[];

  GlobalKey<ScaffoldState>? scaffoldKey;

  NotificationsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    addNotifications();
  }

  void addNotifications(){
    notifications.add(NotificationModel(id: 0, status: 0, dateTime: DateTime.parse("20180626T170555"),
      message: "A similar item is just uploaded you were looking for.",
      image: ""
    ));
    notifications.add(NotificationModel(id: 1, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "You Ad is trending for last 24 hours. It seems like people loving to see your recent Ad. Boost your Ad performance now.",
        image: "https://i.ebayimg.com/images/g/ldoAAOSwDJZfTyeS/s-l500.jpg"
    ));
    notifications.add(NotificationModel(id: 2, status: 1, dateTime: DateTime.parse("20180626T170555"),
        message: "A similar item is just uploaded you were looking for.",
        image: "https://i.ebayimg.com/images/g/ATcAAOSw1zRekD1X/s-l1600.jpg"
    ));
    notifications.add(NotificationModel(id: 3, status: 1, dateTime: DateTime.parse("20180626T170555"),
        message: "Someone just placed a review on your item you can review his/her comments before showing under your item.",
        image: "https://i.ebayimg.com/images/g/2kkAAOSw~2FfSR~e/s-l500.jpg"
    ));
    notifications.add(NotificationModel(id: 4, status: 1, dateTime: DateTime.parse("20180626T170555"),
        message: "We are updating our policy, please review and leave a message over it with a short survey",
        image: ""
    ));

    notifications.add(NotificationModel(id: 0, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "A similar item is just uploaded you were looking for.",
        image: ""
    ));
    notifications.add(NotificationModel(id: 1, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "You Ad is trending for last 24 hours. It seems like people loving to see your recent Ad. Boost your Ad performance now.",
        image: "https://i.ebayimg.com/images/g/ldoAAOSwDJZfTyeS/s-l500.jpg"
    ));
    notifications.add(NotificationModel(id: 2, status: 1, dateTime: DateTime.parse("20180626T170555"),
        message: "A similar item is just uploaded you were looking for.",
        image: "https://i.ebayimg.com/images/g/ATcAAOSw1zRekD1X/s-l1600.jpg"
    ));
    notifications.add(NotificationModel(id: 3, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "Someone just placed a review on your item you can review his/her comments before showing under your item.",
        image: "https://i.ebayimg.com/images/g/2kkAAOSw~2FfSR~e/s-l500.jpg"
    ));
    notifications.add(NotificationModel(id: 4, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "We are updating our policy, please review and leave a message over it with a short survey",
        image: ""
    ));

    notifications.add(NotificationModel(id: 0, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "A similar item is just uploaded you were looking for.",
        image: ""
    ));
    notifications.add(NotificationModel(id: 1, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "You Ad is trending for last 24 hours. It seems like people loving to see your recent Ad. Boost your Ad performance now.",
        image: "https://i.ebayimg.com/images/g/ldoAAOSwDJZfTyeS/s-l500.jpg"
    ));
    notifications.add(NotificationModel(id: 2, status: 1, dateTime: DateTime.parse("20180626T170555"),
        message: "A similar item is just uploaded you were looking for.",
        image: "https://i.ebayimg.com/images/g/ATcAAOSw1zRekD1X/s-l1600.jpg"
    ));
    notifications.add(NotificationModel(id: 3, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "Someone just placed a review on your item you can review his/her comments before showing under your item.",
        image: "https://i.ebayimg.com/images/g/2kkAAOSw~2FfSR~e/s-l500.jpg"
    ));
    notifications.add(NotificationModel(id: 4, status: 0, dateTime: DateTime.parse("20180626T170555"),
        message: "We are updating our policy, please review and leave a message over it with a short survey",
        image: ""
    ));
  }


}