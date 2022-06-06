import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/review_controller.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CreateReviewWidget extends StatefulWidget {
 final RouteArgument? argument;

  CreateReviewWidget({this.argument});

  @override
  _CreateReviewWidgetState createState() => _CreateReviewWidgetState();
}

class _CreateReviewWidgetState extends StateMVC<CreateReviewWidget> {

  ReviewController? _con;

  _CreateReviewWidgetState() : super(ReviewController()) {
    _con = controller as ReviewController?;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Review", style: textTheme.headline6, ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: theme.colorScheme.secondary),
          onPressed: (){
            // if(!_con.isLoading) {
            //   Navigator.of(context).pop();
            // }
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
