import 'package:iExchange_it/src/models/user.dart';

class Chat {

  var fireStoreChatId ;
  bool? isRead;

  User? user;
  DateTime? time;
  var lastMessage;


  var id;
  var ownerId;
  var opponentId;
  String? createdAt;
  String? updatedAt;
  var unread;
  User? opponent;

  Chat({this.id,
    this.fireStoreChatId,
    this.isRead,
    this.user,
    this.time,
    this.lastMessage,
    this.ownerId,
    this.opponentId,
    this.createdAt,
    this.updatedAt,
    this.unread,
    this.opponent});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['owner_id'];
    opponentId = json['opponent_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    unread = json['unread'];
    opponent = json['opponent'] != null
        ? new User.fromJson(json['opponent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner_id'] = this.ownerId;
    data['opponent_id'] = this.opponentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['unread'] = this.unread;
    if (this.opponent != null) {
      data['opponent'] = this.opponent!.toJson();
    }
    return data;
  }


}

class Message {

  var chatId;
  var type;
  bool? isRead;
  var txt;
  String? updatedAt;
  String? createdAt;
  var id;
  var receiverId;
  User? opponent;

  var isItemMsg = false;
  var itemImgLink;
  var isImg = false;
  var imgLink; //Will be used as ImageIdentifier when sending a pic

  DateTime? time;

  Message(
      {this.chatId,
        this.type,
        this.isRead,
        this.txt,
        this.opponent,
        this.isItemMsg = false,
        this.isImg = false,
        this.itemImgLink = "",
        this.imgLink = "",
        this.updatedAt,
        this.createdAt,
        this.receiverId,
        this.time,
        this.id});

  Message.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    type = json['type'];
    isRead = json['isRead'];
    isItemMsg = json['isItemMsg'] ?? false;
    isImg = json['isImg'] ?? false;
    txt = json['txt'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['type'] = this.type;
    data['txt'] = this.txt;
    data['isItemMsg'] = this.isItemMsg;
    data['itemImgLink'] = this.isItemMsg;
    data['isImg'] = this.isImg;
    data['imgLink'] = this.isItemMsg;
    data['receiver_id'] = this.receiverId;
    data['id'] = this.id;
    return data;
  }

}