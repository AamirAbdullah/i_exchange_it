import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/chat_controller.dart';
import 'package:iExchange_it/src/elements/CircularLoadingWidget.dart';
import 'package:iExchange_it/src/elements/chat_list_item.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class MyChats extends StatefulWidget {
  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends StateMVC<MyChats>
    with AutomaticKeepAliveClientMixin   {

  ChatController? _con;

  _MyChatsState() : super(ChatController()) {
    _con = controller as ChatController?;
  }

  @override
  void initState() {
    _con!.getCurrentUser();
    // _con.getAllChats();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Chats", style: textTheme.headline6, ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //You don't have any chats
            _con!.loadingChats
                ? CircularLoadingWidget(height: 100,)
            : _con!.chats.isEmpty
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
                          "You don't have any chats",
                          style: textTheme.headline3,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: _con!.chats.length,
                itemBuilder: (context, index) {
                  return ChatListItem(
                    onTap: (){
                      Navigator.of(context).pushNamed("/UserChat", arguments: RouteArgument(chat: _con!.chats[index], currentUser: _con!.currentUser));
                    },
                    chat: _con!.chats[index],
                  );
                }
            ),


          ],
        ),
      ),
    );
  }
}
