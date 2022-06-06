
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/notifications_controller.dart';
import 'package:iExchange_it/src/models/notification_model.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MyNotifications extends StatefulWidget {
  @override
  _MyNotificationsState createState() => _MyNotificationsState();
}

class _MyNotificationsState extends StateMVC<MyNotifications>
    with AutomaticKeepAliveClientMixin   {

  NotificationsController? _con;

  _MyNotificationsState() : super(NotificationsController()) {
    _con = controller as NotificationsController?;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Notifications", style: textTheme.headline6, ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: _con!.notifications.length,
                itemBuilder: (context, index) {
                NotificationModel noti = _con!.notifications[index];
                var day = DateFormat('EEEE').format(noti.dateTime!);
                var time = DateFormat('hh:mm aa').format(noti.dateTime!);
                  return InkWell(
                    onTap: (){},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                margin: EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                  color: noti.status == 0 ? theme.colorScheme.secondary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(100)
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      noti.message,
                                      style: textTheme.bodyText1,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '$day $time',
                                      style: textTheme.caption,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 10,),

                              noti.image != null && noti.image.length > 0
                                  ? FadeInImage.assetNetwork(
                                height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  placeholder: "assets/placeholders/image.jpg",
                                  image: noti.image
                              )
                                  : SizedBox(width: 0,)

                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 0.3,
                            color: theme.focusColor,
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
