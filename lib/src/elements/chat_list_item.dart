import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/chat.dart';
import 'package:intl/intl.dart';

class ChatListItem extends StatelessWidget {

 final Chat? chat;
 final VoidCallback? onTap;

  ChatListItem({this.chat, this.onTap});

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var dateTime = chat!.time!;
    var day = DateFormat('EEEE').format(dateTime);


    return InkWell(
        onTap: this.onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: theme.colorScheme.secondary
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: chat!.opponent != null && chat!.opponent!.image !=null && chat!.opponent!.image.length > 0
                        ? FadeInImage.assetNetwork(
                      placeholder: "assets/placeholders/profile.png",
                      image: chat!.opponent!.image,
                      fit: BoxFit.cover,
                    )
                        : Image.asset("assetls/placeholders/profile.png"),
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 150,
                          child: Text(
                            chat!.opponent!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyText1,)
                      ),
                      SizedBox(height: 5,),
                      Container(
                        width: 160,
                        child: Text(
                          chat!.lastMessage ?? "",
                          style: textTheme.bodyText2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                Text('$day', style: textTheme.caption,)
              ],
            )
        )
    );
  }
}
