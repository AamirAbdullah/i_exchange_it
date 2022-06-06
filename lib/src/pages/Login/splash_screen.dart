// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:iExchange_it/src/controller/controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends StateMVC<SplashScreen> {

  double _width = 0;
  double _height = 0;
  BorderRadius _radius = BorderRadius.circular(1000);
  bool _visible = false;

  _SplashScreenState() : super(Controller());

  startTime() async {
    return new Timer(Duration(milliseconds: 1500), () {
      print("Changed");
      setState(() {
        _radius = BorderRadius.circular(0);
        _width = MediaQuery.of(context).size.width - 5;
        _height = MediaQuery.of(context).size.height - 5;
        _visible = true;
      });
      Timer(Duration(milliseconds: 3000), NavigatorPage);
    });
  }

  void NavigatorPage() {
    // Navigator.of(context).pushReplacementNamed("/ChooseLogin");
    // Navigator.of(context).pushNamedAndRemoveUntil("/Pages", (route) => false, arguments: 0);
    if (userRepo.currentUser.apiToken == null) {
      Navigator.of(context).pushReplacementNamed('/ChooseLogin');
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/Pages', (route) => false, arguments: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
              child: AnimatedContainer(
            width: _width,
            height: _height,
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
                // color: Theme.of(context).accentColor,
                color: Colors.orange,
                borderRadius: _radius),
          )),
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1000),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "WELCOME",
                  style: Theme.of(context).textTheme.bodyText1!.merge(TextStyle(
                        fontSize: 14,
                        letterSpacing: 3,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/app_icon/iexchangeit_title.png",
                  width: 140,
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 1000),
                      child: Hero(
                        tag: "iExchangeIt",
                        child: Text(
                          "iexchangeit",
                          style: Theme.of(context).textTheme.headline4!.merge(
                              TextStyle(fontSize: 22, color: Colors.black87)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 1500),
                child: Text(
                  "Copyright © 2018 iExchangeIt.\nAll rights reserved ",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2!.merge(TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      letterSpacing: 1)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
