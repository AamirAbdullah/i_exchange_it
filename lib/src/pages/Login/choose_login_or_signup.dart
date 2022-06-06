import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:iExchange_it/src/controller/user_controller.dart';
import 'package:iExchange_it/src/elements/custom_outlined_button.dart';
import 'package:iExchange_it/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/config/app_config.dart' as config;
import 'package:provider/provider.dart';

class ChooseLoginOrSignup extends StatefulWidget {
  @override
  _ChooseLoginOrSignupState createState() => _ChooseLoginOrSignupState();
}

class _ChooseLoginOrSignupState extends StateMVC<ChooseLoginOrSignup> {
  UserController? _con;

  _ChooseLoginOrSignupState() : super(UserController()) {
    _con = controller as UserController?;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: _con!.scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            /// Set Background image in layout (Click to open code)
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/img1_1.jpeg'),
                    fit: BoxFit.cover)),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,

              /// Set gradient color in image (Click to open code)
              decoration:
                  BoxDecoration(gradient: config.Colors().appGradient()),

              /// Set component layout
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(top: mediaQuery.padding.top + 50.0),
                    ),
                    Center(
                      /// Animation text treva shop accept from splashscreen layout (Click to open code)
                      child: Hero(
                        tag: "iExchangeIt",
                        child: Text(
                          "iexchangeit",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .merge(TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),

                    Hero(
                      tag: "iExchangeItLogo",
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Image.asset(
                          "assets/app_icon/iexchangeit_notitle.png",
                          height: 150,
                        ),
                      ),
                    ),

                    Padding(
                        padding: EdgeInsets.only(
                            left: 160.0,
                            right: 160.0,
                            top: mediaQuery.padding.top + 30.0,
                            bottom: 10.0),
                        child: Container(
                          color: Colors.white,
                          height: 0.5,
                        )),

                    /// to set Text "get best product...." (Click to open code)
                    Text(
                      "Save while you Exchange here",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Padding(padding: EdgeInsets.only(top: 30.0)),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor:
                                  Theme.of(context).colorScheme.secondary,
                              onTap: () {
                                // OnTap
                                Navigator.of(context).pushNamed("/Signup");
                              },
                              child: CustomOutlinedButton(txt: "Signup"),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 15.0)),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                height: 0.2,
                                width: 80.0,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text(
                                  "OR",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                height: 0.2,
                                width: 80.0,
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 15.0)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor:
                                  Theme.of(context).colorScheme.secondary,
                              onTap: () {
                                //Open Login Page
                                Navigator.of(context).pushNamed("/Login");
                              },
                              child: CustomOutlinedButton(txt: "Login"),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(padding: EdgeInsets.only(top: 30.0)),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Continue with ",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: MaterialButton(
                                    onPressed: () {
                                      _con?.signUpWithFacebook(context);
                                    },
                                    color: Color(0xFF3b5998),
                                    child: Center(
                                        child: Text(
                                      "f",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .merge(
                                              TextStyle(color: Colors.white)),
                                    )),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  "OR",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: MaterialButton(
                                      onPressed: () {
                                        final provider =
                                            Provider.of<GoogleSignInController>(
                                                context,
                                                listen: false);
                                        provider.googleLogin(context);
                                      },
                                      color: Colors.white,
                                      splashColor: Color(0xFFF4B400),
                                      child: Center(
                                          child: Text(
                                        "G",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .merge(TextStyle(
                                                color: Color(0xFFDB4437))),
                                      ))),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 15)
                  ],
                ),
              ),
            ),
          ),

          ///Loader
          _con!.isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text("Please wait...",
                              style: Theme.of(context).textTheme.bodyText2)
                        ],
                      ),
                    ),
                  ),
                )
              : Positioned(bottom: 10, child: SizedBox(height: 0)),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('some thing got wrong'),
              );
            } else if (snapshot.hasData) {
              return PagesWidget();
            } else {
              return ChooseLoginOrSignup();
            }
          }),
    );
  }
}
