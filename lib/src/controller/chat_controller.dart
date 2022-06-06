// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/config/my_firestore.dart';
import 'package:iExchange_it/src/models/chat.dart';

import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class ChatController extends ControllerMVC {
  Message message = Message();
  Product? item;

  User? opponentProfile;

  User? currentUser;
  User? user;
  Chat? chat;
  List<Chat> chats = <Chat>[];
  bool loadingChats = false;
  List<Message> messages = <Message>[];
  bool loadingMessages = true;

  bool showImg = false;
  bool showItem = false;

  ScrollController? scrollController;

  TextEditingController? textController;


  GlobalKey<ScaffoldState>? scaffoldKey;

  ChatController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    scrollController = ScrollController();
    textController = TextEditingController();
  }


  getCurrentUser() async {
    userRepo.getCurrentUser().then((_user) {
      setState(() {
        currentUser = _user;
      });
      getAllChats();
    });
  }

  getOpponentUser(var id) async {
    // userRepo.getUserProfile(id).then((_user) {
    //   setState(() {
    //     opponentProfile = _user;
    //   });
    // });
  }

  List<String> options = <String>["Delete Chat"];
  void onOptions(var value, bool moveBack, Chat? _chat) {
    if(value==options[0]) {
      if(this.chat != null) {
        deleteThisChat(_chat!, moveBack);
      }
    }
  }

  deleteThisChat(Chat _chat, bool moveBack) async {
    setState(() {
      loadingChats = true;
    });
    MyFirestore.deleteChat(_chat.id).then((value) {
      if(moveBack) {
        Navigator.of(this.scaffoldKey!.currentContext!).pop(true);
      }
    });
  }

  getAllChats() async {
    chats.clear();
    setState((){
      loadingChats = true;
    });

    Stream<QuerySnapshot> stream = MyFirestore.getChatsList(currentUser!.id);
    stream.listen((_querySnaps) {
      chats.clear();
      setState((){
        loadingChats = false;
      });
      _querySnaps.docs.forEach((_chatItem) {
        Map<String, dynamic> data = _chatItem.data() as Map<String, dynamic>;

        Chat _chat = Chat(
          fireStoreChatId: data['chatId'],
          lastMessage: data['lastMessage'],
          isRead: data['lastBy'].toString() == currentUser!.id.toString(),
          id: data['serverChatId'],
          ownerId: currentUser!.id,
          time: DateTime.fromMillisecondsSinceEpoch(data['updatedAt']),
        );

        for(String key in data.keys) {
          if (key.toString() != currentUser!.id.toString() &&
              key.toString() != "users" &&
              key.toString() != "chatId" &&
              key.toString() != "serverChatId" &&
              key.toString() != "updatedAt" &&
              key.toString() != "lastBy" &&
              key.toString() != "lastMessage") {
            User opponentUser = User(
                id: key, name: data[key]['name'], image: data[key]['image']);

            _chat.opponent = opponentUser;
            _chat.opponentId = key;
            setState((){
              chats.add(_chat);
            });
          }
        }
      });
    }, onError: (e) {
      print(e);
      setState(() {
        loadingChats = false;
      });
    }, onDone: () {
      setState(() {
        loadingChats = false;
      });
    });
  }

  getChatMessages() async {
    if(chat != null) {

      Stream<QuerySnapshot> stream = MyFirestore.getChatMessages(chat!.fireStoreChatId);
      stream.listen((_querySnaps) {
        messages.clear();
        setState(() {
          loadingMessages = false;
        });
        _querySnaps.docs.forEach((_messageItem) {
          Map<String, dynamic> data = _messageItem.data() as Map<String, dynamic>;
          var isMe = data['sender'].toString() == currentUser!.id.toString() ? 1 : 0;

          Message myMessage = Message(type: isMe,
              time: DateTime.fromMillisecondsSinceEpoch(data['time']),
              txt: data['txt'],
              isItemMsg: data['isItemMsg'] ?? false,
              isImg: data['isImg'] ?? false,
            itemImgLink: data['itemImgLink'],
            imgLink: data['imgLink']
          );

          setState(() {
            messages.add(myMessage);
            loadingMessages = false;
            scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
          });
        });
      }, onError: (e) {
        setState(() {
          loadingMessages = false;
        });
      }, onDone: (){
        setState(() {
          loadingMessages = false;
        });
      });

    }
    else {
      setState(() {
        loadingMessages = false;
      });
    }
  }

  getChatMessagesByUserId() async {
    if(user != null) {

      var chat1 = '${currentUser!.id.toString()}_${user!.id.toString()}';
      var chat2 = '${user!.id.toString()}_${currentUser!.id.toString()}';

      bool isExist1 = await MyFirestore.checkExist(chat1);
      var fireStoreChatId = isExist1 ? chat1 : chat2;

      MyFirestore.getChatMessages(fireStoreChatId).listen((_querySnaps) {
        messages.clear();
        setState(() {
          loadingMessages = false;
        });
        _querySnaps.docs.forEach((_messageItem) {
          Map<String, dynamic> data = _messageItem.data() as Map<String, dynamic>;
          var isMe = data['sender'].toString() == currentUser!.id.toString() ? 1 : 0;
          Message myMessage = Message(type: isMe,
              time: DateTime.fromMillisecondsSinceEpoch(data['time']),
              txt: data['txt'],
              isItemMsg: data['isItemMsg'] ?? false,
              isImg: data['isImg'] ?? false,
              itemImgLink: data['itemImgLink'],
              imgLink: data['imgLink']
          );
          setState(() {
            chat = Chat(opponent:  this.user, opponentId: this.user!.id, fireStoreChatId: fireStoreChatId);
            messages.add(myMessage);
            loadingMessages = false;
            scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
          });
        });
      }, onError: (e){
        setState(() {
          loadingMessages = false;
        });
      }, onDone: (){
        setState(() {
          loadingMessages = false;
        });
      });

    } else {
      setState(() {
        loadingMessages = false;
      });
    }
  }

  sendANewMessage() async {
    if((textController!.text.length > 0) || message.isImg) {
      Message _message = Message(txt: textController!.text);
      if(chat != null)
      {
        _message.receiverId = chat!.opponentId;
      }
      else {
        setState((){
          chat = Chat(opponent: user, opponentId: user!.id);
        });
        _message.receiverId = user!.id;

        var chat1 = '${currentUser!.id.toString()}_${user!.id.toString()}';
        var chat2 = '${user!.id.toString()}_${currentUser!.id.toString()}';

        bool isExist1 = await MyFirestore.checkExist(chat1);
        bool isExist2 = isExist1 ? false : await MyFirestore.checkExist(chat2);
        chat!.fireStoreChatId = isExist1 ? chat1 : chat2;

        if(!isExist1 && !isExist2) {
          Map<String, dynamic> data = new Map<String, dynamic>();
          data['users'] = [currentUser!.id.toString(), user!.id.toString()];
          data['chatId'] = chat!.fireStoreChatId;

          Map<String, dynamic> userMap = new Map<String, dynamic>();
          userMap['name'] = currentUser!.name ?? "";
          userMap['image'] = currentUser!.image ?? "";
          data[currentUser!.id.toString()] = userMap;

          userMap = new Map<String, dynamic>();
          userMap['name'] = user!.name ?? "";
          userMap['image'] = user!.image ?? "";
          data[user!.id.toString()] = userMap;

          MyFirestore.createUserChatRoom(chat!.fireStoreChatId, data);

        }

      }

      textController!.text = "";
      Map<String, dynamic> msgData = new Map<String, dynamic>();
      msgData['txt'] = _message.txt;
      msgData['sender'] = currentUser!.id;
      msgData['isItemMsg'] = this.item != null ? true : false;
      msgData['isImg'] = message.isImg;
      msgData['itemImgLink'] = (this.item != null && this.item!.images != null) ? this.item!.images![0].path : "";
      msgData['imgLink'] = message.isImg ? message.imgLink : ""; //Identifier

      MyFirestore.createChatRoomMessage(chat!.fireStoreChatId, _message.txt, chat!.fireStoreChatId, msgData, currentUser);
      closeImageNow();

      // if(this.opponentProfile != null) {
        // notiRepo.sendNotification(message.txt, "Message from ${this.currentUser.name}", this.opponentProfile.firebaseToken).then((value) {});
      // }

      setState((){
        chat!.id = chat!.fireStoreChatId;
        scrollController!.jumpTo(scrollController!.position.maxScrollExtent);
      });
    }
  }

  void getImage() async {
    final pickedFile = await (ImagePicker().getImage(source: ImageSource.gallery) as FutureOr<PickedFile>);
    debugPrint("pickedFile: " + pickedFile.path);
    closeImageNow();
    setState((){
      showImg = true;
      message.isImg = true;
      message.imgLink = pickedFile.path;
    });
  }

  closeImageNow() {
    setState((){
      this.showImg = false;
      this.showItem = false;
      message.isImg = false;
      this.item = null;
    });
  }




}