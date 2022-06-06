
import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/chat.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:intl/intl.dart';

class ChatMessageItem extends StatelessWidget {
 final Message? message;
 final User? user;

  ChatMessageItem({this.message, this.user});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;


    bool isMe = message!.type == 1;

    var dateTime = message!.time!;
    // var day = DateFormat('EEEE').format(dateTime);
    var time = DateFormat('hh:mm aa').format(dateTime);

    // var day = DateFormat('EEEE').format(message.dateTime);
    // var time = DateFormat('hh:mm aa').format(dateTimeFormatted);

    var constraints = BoxConstraints(maxWidth: (size.width / 2) + 15);

    var textualPadding =
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12);

    var boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 20 : 0),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(isMe ? 0 : 20),
            bottomLeft: Radius.circular(20)),
        color: isMe ? theme.colorScheme.secondary : theme.primaryColor);

    var clipRectBorder = BorderRadius.only(
        topLeft: Radius.circular(isMe ? 20 : 0),
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(isMe ? 0 : 20),
        bottomLeft: Radius.circular(20));


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        textDirection: isMe ? c.TextDirection.rtl : c.TextDirection.ltr,
        children: [
          isMe
              ? !message!.isImg && !message!.isItemMsg
                  ? Container(
                      constraints: constraints,
                      decoration: boxDecoration,
                      child: Padding(
                        padding: textualPadding,
                        child: Text(
                          message!.txt ?? "",
                          style: textTheme.bodyText2!.merge(TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  : Container(
                      constraints: constraints,
                      padding: EdgeInsets.all(3),
                      decoration: boxDecoration,
                      child: message!.isImg
                          ? ClipRRect(
                        borderRadius: clipRectBorder,
                        child: FadeInImage.assetNetwork(
                            placeholder:
                            "assets/placeholders/image.jpg",
                            image: message!.isImg ? message!.imgLink : message!.itemImgLink),
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: clipRectBorder,
                            child: FadeInImage.assetNetwork(
                                placeholder:
                                "assets/placeholders/image.jpg",
                                image: message!.isImg ? message!.imgLink : message!.itemImgLink),
                          ),
                          Padding(
                            padding: textualPadding,
                            child: Text(
                              message!.txt ?? "",
                              style: textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                    )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: theme.colorScheme.secondary),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: user!.image != null && user!.image.length > 0
                            ? FadeInImage.assetNetwork(
                                placeholder: "assets/placeholders/profile.png",
                                image: user!.image,
                                fit: BoxFit.cover,
                              )
                            : Image.asset("assetls/placeholders/profile.png"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 40,
                            child: Text(
                              user!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.caption,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        !message!.isImg && !message!.isItemMsg
                            ? Container(
                                constraints: constraints,
                                decoration: boxDecoration.copyWith(boxShadow: [
                                  BoxShadow(
                                      color: theme.focusColor.withOpacity(0.2),
                                      blurRadius: 2,
                                      offset: Offset(0.2, 0.2))
                                ]),
                                child: Padding(
                                  padding: textualPadding,
                                  child: Text(
                                    message!.txt ?? "",
                                    style: textTheme.bodyText2,
                                  ),
                                ),
                              )
                            : Container(
                                constraints: constraints,
                                padding: EdgeInsets.all(3),
                                decoration: boxDecoration,
                                child: message!.isImg
                                    ? ClipRRect(
                                  borderRadius: clipRectBorder,
                                  child: FadeInImage.assetNetwork(
                                      placeholder:
                                          "assets/placeholders/image.jpg",
                                      image: message!.isImg ? message!.imgLink : message!.itemImgLink),
                                )
                                    : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: clipRectBorder,
                                      child: FadeInImage.assetNetwork(
                                          placeholder:
                                          "assets/placeholders/image.jpg",
                                          image: message!.isImg ? message!.imgLink : message!.itemImgLink),
                                    ),
                                    Padding(
                                      padding: textualPadding,
                                      child: Text(
                                        message!.txt ?? "",
                                        style: textTheme.bodyText2,
                                      ),
                                    )
                                  ],
                                )
                        ),
                      ],
                    )
                  ],
                ),
          SizedBox(
            width: 10,
          ),
          Container(
              width: 50,
              child: Text(
                "$time",
                style: textTheme.caption,
              ))
        ],
      ),
    );
  }
}
