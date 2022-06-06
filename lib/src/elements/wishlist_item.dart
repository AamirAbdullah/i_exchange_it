import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/wishlist_got.dart';
import 'package:intl/intl.dart';

class WishlistItemWidget extends StatelessWidget {

 final WishlistGot? wish;
 final VoidCallback? onDelete;

  WishlistItemWidget({this.wish, this.onDelete});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;


    var format = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ');
    var dateTime = format.parse(wish!.createdAt);
    var day = DateFormat('EEEE').format(dateTime);
    var dayOfMonth = DateFormat('dd').format(dateTime);
    var month = DateFormat('MMM').format(dateTime);
    var time = DateFormat('hh:mm aa').format(dateTime);


    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: theme.focusColor,
                blurRadius: 5,
                offset: Offset(0, 0)
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ListTile(
            leading: Icon(Icons.person_pin_outlined, color: theme.colorScheme.secondary, size: 20,),
            trailing: InkWell(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(CupertinoIcons.trash_fill, color: theme.colorScheme.secondary,),
            ),
                onTap: this.onDelete),
            title: Text("Details", style: textTheme.subtitle2,),
          ),

          Row(
            children: [
              Icon(CupertinoIcons.add_circled, color: theme.focusColor, size: 18,),
              SizedBox(width: 5,),
              Text("Item with keyword ", style: textTheme.subtitle2,),
              SizedBox(width: 10,),
              Text(wish!.keyword ?? "", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(CupertinoIcons.play, color: theme.focusColor, size: 20,),
              SizedBox(width: 5,),
              Text("Should be available for ", style: textTheme.subtitle2,),
              SizedBox(width: 5,),
              Text(wish!.type ?? "", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(CupertinoIcons.settings, color: theme.focusColor, size: 20,),
              SizedBox(width: 5,),
              Text("Item can be ", style: textTheme.subtitle2,),
              SizedBox(width: 5,),
              Text(wish!.condition ?? "", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(Icons.attach_money, color: theme.focusColor, size: 20,),
              SizedBox(width: 5,),
              Text("Within price range ", style: textTheme.subtitle2,),
              Text("from ", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
              Text('${wish!.minprice}', style: textTheme.subtitle2,),
              Text(" to ", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
              Text('${wish!.maxprice}', style: textTheme.subtitle2,),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(CupertinoIcons.collections, color: theme.focusColor, size: 19,),
              SizedBox(width: 5,),
              Text("From ", style: textTheme.subtitle2,),
              SizedBox(width: 5,),
              wish!.category != null
                  ? Text(wish!.category!.name ?? "", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),)
                  : SizedBox(width: 0),
              wish!.subCategory != null
                  ? Text(' > ${wish!.subCategory!.name}', style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),)
                  : SizedBox(width: 0),
              wish!.childCategory != null
                  ? Text(' > ${wish!.childCategory!.name}', style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),)
                  : SizedBox(width: 0),
            ],
          ),
          SizedBox(height: 5,),

          Row(
            children: [
              Icon(CupertinoIcons.location, color: theme.focusColor, size: 20,),
              SizedBox(width: 5,),
              Text("Location ", style: textTheme.subtitle2,),
              SizedBox(width: 5,),
              Text(wish!.location ?? "", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(Icons.map, color: theme.focusColor, size: 18,),
              SizedBox(width: 5,),
              Text("Within distance of ", style: textTheme.subtitle2,),
              Text('${wish!.range} (KM)', style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Icon(Icons.storage, color: theme.focusColor, size: 18,),
              SizedBox(width: 5,),
              Text("Post code can be ", style: textTheme.subtitle2,),
              SizedBox(width: 5,),
              Text(wish!.postcode ?? "", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
            ],
          ),
          wish!.attributes!.isNotEmpty && wish!.attributes!.length > 0
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text("Other Details: ", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
              SizedBox(height: 10,),
              GridView.count(
                childAspectRatio: 3.7,
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 2,
                children: List.generate(wish!.attributes!.length,
                        (idx) {
                      return Row(
                        children: [
                          Icon(CupertinoIcons.forward, color: theme.focusColor, size: 20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(wish!.attributes![idx].handler, style: textTheme.subtitle2,),
                              Text(" "+wish!.attributes![idx].valueToSend, style: textTheme.bodyText1,)
                            ],
                          )
                        ],
                      );
                    }
                ),
              )
            ],
          )
              : SizedBox(height: 0),

          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Created on ".toUpperCase(), style: textTheme.caption,),
                Text("$day ${dayOfMonth}th $month at $time", style: textTheme.caption,)
              ],
            ),
          ),

          SizedBox(height: 10,),

        ],
      ),
    );
  }
}
