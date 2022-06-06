import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/chat_controller.dart';
import 'package:iExchange_it/src/elements/CircularLoadingWidget.dart';
import 'package:iExchange_it/src/elements/chat_message_item.dart';
import 'package:iExchange_it/src/models/chat.dart';
import 'package:iExchange_it/src/models/route_argument.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:io';


class UserChatWidget extends StatefulWidget {

 final RouteArgument? argument;

  UserChatWidget({this.argument});

  @override
  _UserChatWidgetState createState() => _UserChatWidgetState();
}

class _UserChatWidgetState extends StateMVC<UserChatWidget> {

  ChatController? _con;

  _UserChatWidgetState() : super(ChatController()) {
    _con = controller as ChatController?;
  }

  @override
  void initState() {
    _con!.currentUser = widget.argument!.currentUser;
    if(widget.argument != null) {
      if(widget.argument!.chat != null) {
        _con!.chat = widget.argument!.chat;
        _con!.getOpponentUser(widget.argument!.chat!.opponentId);
      }
      else if(widget.argument!.user != null) {
        _con!.user = widget.argument!.user;
        _con!.getOpponentUser(widget.argument!.user!.id);
      }

      if(widget.argument!.product != null) {
        _con!.item = widget.argument!.product;
        _con!.showItem = true;
      }
    }
    super.initState();
    if(widget.argument!.chat != null) {
      _con!.getChatMessages();
    } else {
      _con!.getChatMessagesByUserId();
    }

    Future.delayed(Duration(seconds: 1), (){
      _con!.scrollController!.animateTo(_con!.scrollController!.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("John Smith", style: textTheme.headline4,),
        backgroundColor: theme.primaryColor,
        leading: IconButton(icon: Icon(CupertinoIcons.back), onPressed: (){Navigator.of(context).pop();},),
        actions: [
          PopupMenuButton(
              color: theme.scaffoldBackgroundColor,
              onSelected: (dynamic value) {
                _con!.onOptions(value, true, _con!.chat);
              },
              icon: Icon(Icons.more_horiz_outlined, color: theme.primaryColorDark,),
              itemBuilder: (context) => List.generate(_con!.options.length, (index) {
                return PopupMenuItem(
                    value: _con!.options[index],
                    child: Text(_con!.options[index], style: textTheme.bodyText2,));
              })
          ),
        ],
      ),
      body: Stack(
        children: [

          SingleChildScrollView(
              controller: _con!.scrollController,
              child: Column(
                children: [
                  _con!.loadingMessages
                      ? CircularLoadingWidget(height: 100,)
                      : _con!.messages.isEmpty
                      ? Container(
                    height: size.height-100,
                    child: Center(
                      child: Opacity(
                        opacity: 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Opacity(
                                opacity: 0.2,
                                child: Image.asset("assets/img/no_message.png", width: 200, height: 200,)
                            ),
                            Opacity(
                              opacity: 0.4,
                              child: Text(
                                "No messages yet",
                                style: textTheme.headline3,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      : ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 70),
                      itemCount: _con!.messages.length,
                      itemBuilder: (context, index) {

                        Message message = _con!.messages[index];

                        return ChatMessageItem(message: message, user: _con!.chat!.opponent,);
                      }
                  ),


                  SizedBox(height: 50),


                ],
              )
          ),

          // (_con.chat == null || _con.chat.chat == null || _con.chat.chat.length < 1)
          //     ? Align(
          //   alignment: Alignment.center,
          //   child: Column(
          //     children: [
          //       Opacity(
          //           opacity: 0.2,
          //           child: Image.asset("assets/img/no_message.png", width: 200, height: 200,)
          //       ),
          //       Opacity(
          //         opacity: 0.4,
          //         child: Text(
          //           "No messages yet",
          //           style: textTheme.headline3,
          //         ),
          //       )
          //     ],
          //   ),
          // )
          // : Padding(
          //   padding: const EdgeInsets.only(bottom: 55.0),
          //   child: SingleChildScrollView(
          //     controller: _con.scrollController,
          //     child: Column(
          //       children: [
          //         ListView.builder(
          //           // reverse: true,
          //             shrinkWrap: true,
          //             primary: false,
          //             itemCount: _con.chat.chat.length,
          //             itemBuilder: (context, index) {
          //               return ChatMessageItem(message: _con.chat.chat[index], user: _con.chat.user,);
          //             }
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // height: 50,
              color: theme.primaryColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  _con!.showItem ? Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                          child: FadeInImage.assetNetwork(
                              placeholder: "assets/placeholders/image.jpg",
                              image: _con!.item!.images![0].path,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _con!.item!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyText1!.merge(TextStyle(color: theme.focusColor)),
                              ),
                              Text(
                                _con!.item!.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyText2!.merge(TextStyle(color: theme.focusColor)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            _con!.closeImageNow();
                          },
                          icon: Icon(CupertinoIcons.clear, color: theme.colorScheme.secondary,)
                        )
                      ],
                    ),
                  ) : SizedBox(height: 0),

                  _con!.showImg
                      ? Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                          child: Image.file(File(_con!.message.imgLink), height: 80, width: 80, fit: BoxFit.cover,)
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyText1!.merge(TextStyle(color: theme.focusColor)),
                              ),
                              Text(
                                "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyText2!.merge(TextStyle(color: theme.focusColor)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              _con!.closeImageNow();
                            },
                            icon: Icon(CupertinoIcons.clear, color: theme.colorScheme.secondary,)
                        )
                      ],
                    ),
                  )
                      : SizedBox(height: 0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: (){ _con!.getImage(); },
                        icon: Icon(CupertinoIcons.add),
                        splashColor: theme.focusColor,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: TextFormField(
                            controller: _con!.textController,
                            textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "Type your message",
                                border: InputBorder.none
                              ),
                            ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap: _con!.sendANewMessage,
                        splashColor: theme.focusColor,
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: Center(
                            child: Icon(Icons.send, size: 20, color: Colors.white,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}
