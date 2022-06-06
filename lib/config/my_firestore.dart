import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:iExchange_it/src/models/user.dart';

class MyFirestore {

  static String chatsCollection = "chats";
  static String chatRoom = "chatroom";


  ///============================================= CHATS STUFF ======================================================


  static createChatRoomMessage(var chatId, String? lastMessage, var serverChatId, Map<String, dynamic> message, User? user) async {

    var link = "";
    if(message['isImg']) {
      File imgFile = File(message['imgLink']);
      link = await uploadImage(imgFile);
    }
    var doc  = FirebaseFirestore.instance.collection(chatsCollection).doc(chatId);
    message['time'] = DateTime.now().millisecondsSinceEpoch;
    message['imgLink'] = link;

    await doc.collection(chatRoom).doc().set(message).then((value) {
      Map<String, dynamic> currentUser = new Map<String, dynamic>();

      currentUser['id'] = user!.id.toString();
      currentUser['name'] = user.name.toString();
      currentUser['image'] = user.image.toString();

      doc.update({
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
        '${user.id}': currentUser,
        'serverChatId': serverChatId.toString(),
        'lastMessage': message['isImg'] ? "Image" : lastMessage,
        'lastBy': user.id.toString()
      });
    },
        onError: (e){
          print(e);
        });
  }

  static createUserChatRoom(var chatId, Map<String, dynamic> data) async  {
    await FirebaseFirestore.instance
        .collection(chatsCollection)
        .doc(chatId)
        .set(data);
  }

  static Stream<QuerySnapshot> getChatMessages(var chatId) {
    return FirebaseFirestore.instance
        .collection(chatsCollection)
        .doc(chatId)
        .collection(chatRoom)
    .orderBy("time")
        .snapshots();
  }

  static Stream<QuerySnapshot> getChatsList(var userId) {
    return FirebaseFirestore.instance
        .collection(chatsCollection)
        .where("users", arrayContains: userId.toString())
    .orderBy("updatedAt", descending: true)
        .snapshots();
  }

  static CollectionReference getChatsCollection() {
    return FirebaseFirestore.instance
        .collection(chatsCollection);
  }

  static Future<bool> checkExist(String docID) async {
    bool exists = false;
    try {
      await FirebaseFirestore.instance.collection(chatsCollection).doc("$docID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<void> deleteChat(String? docId) async {
    await FirebaseFirestore.instance
        .collection(chatsCollection)
        .doc(docId)
        .delete();
  }

  static Future<String> uploadImage(File path) async {
    var uid = DateTime.now().millisecondsSinceEpoch;
    var ref = FirebaseStorage.instance.ref().child("chat/images/$uid.jpg");
    try {
      ref.delete();
    } catch(e)
    {
      print(e.toString());
    }
    var uploadTask = ref.putFile(path);
    await uploadTask.whenComplete((){});
    var dowurl = await ref.getDownloadURL();
    var url = dowurl.toString();
    return url;
  }

}