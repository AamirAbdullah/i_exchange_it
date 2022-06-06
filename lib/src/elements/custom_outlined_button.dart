import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {

 final String? txt;
  

  CustomOutlinedButton({this.txt});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.white,
        child: LayoutBuilder(builder: (context, constraint) {
          return Container(
            width: 300.0,
            height: 52.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 1)),
            child: Center(
                child: Text(
                  txt!,
                  style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(fontSize: 15)),
                )),
          );
        }),
      ),
    );
  }
}
