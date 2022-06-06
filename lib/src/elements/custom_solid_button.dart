import 'package:flutter/material.dart';
import 'package:iExchange_it/config/app_config.dart' as config;

class CustomSolidButton extends StatelessWidget {

final  String? txt;
  CustomSolidButton({this.txt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 55.0,
        width: 600.0,
        child:
        Text(
          txt!,
          style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(fontSize: 15)),
        ),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
            borderRadius: BorderRadius.circular(30.0),
            gradient: config.Colors().primaryGradient()),
      ),
    );
  }
}
