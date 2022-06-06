class NotificationModel {

  var id;
  var status; //0=unread, 1=read
  var message;
  DateTime? dateTime;
  var image;

  NotificationModel({this.id, this.status, this.message, this.dateTime, this.image});

}