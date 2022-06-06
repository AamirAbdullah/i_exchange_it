import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/user_controller.dart';
import 'package:iExchange_it/src/elements/custom_form_field.dart';
import 'package:iExchange_it/src/elements/custom_solid_button.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/config/app_config.dart' as config;
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends StateMVC<Signup> {
  UserController? _con;

  _SignupState() : super(UserController()) {
    _con = controller as UserController?;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: _con!.scaffoldKey,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/img/img3.jpg"),
              fit: BoxFit.cover,
            )),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,

              /// Set gradient color in image (Click to open code)
              decoration: BoxDecoration(
                gradient: config.Colors().appGradient(),
              ),

              /// Set component layout
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _con!.formKey,
                      child: Column(
                        children: <Widget>[
                          /// padding logo
                          Padding(
                              padding: EdgeInsets.only(
                                  top: mediaQueryData.padding.top + 20.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Hero(
                                tag: "iExchangeItLogo",
                                child: Image(
                                  image: AssetImage(
                                      "assets/app_icon/iexchangeit.png"),
                                  height: 70.0,
                                ),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0)),
                              Hero(
                                tag: "iExchangeIt",
                                child: Text(
                                  "iexchangeit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .merge(TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),

                          /// TextFromField Name
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0)),
                          CustomFormField(
                            formField: TextFormField(
                              validator: (val) =>
                                  (val!.isEmpty) ? "Name can't be empty" : null,
                              obscureText: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Name",
                                  icon: Icon(
                                    Icons.person_pin,
                                    color: Colors.black38,
                                  ),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              keyboardType: TextInputType.text,
                              onSaved: (value) {
                                _con!.currentUser.name = value;
                              },
                            ),
                          ),

                          /// TextFromField Email
                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                          CustomFormField(
                            formField: TextFormField(
                              validator: (val) =>
                                  (val!.isEmpty || !val.contains("@"))
                                      ? "Invalid Email"
                                      : null,
                              obscureText: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Email",
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.black38,
                                  ),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) {
                                _con!.currentUser.email = value;
                              },
                            ),
                          ),

                          /// TextFromField Phone
                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                          CustomFormField(
                            formField: TextFormField(
                              validator: (val) =>
                                  (val!.isEmpty || val.length < 5)
                                      ? "Invalid Phone"
                                      : null,
                              obscureText: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Phone",
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.black38,
                                  ),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              keyboardType: TextInputType.phone,
                              onSaved: (value) {
                                _con!.currentUser.phone = value;
                              },
                            ),
                          ),

                          /// TextFromField Password
                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                          CustomFormField(
                            formField: TextFormField(
                              controller: _con!.passwordController,
                              validator: (val) => (val!.isEmpty)
                                  ? "Password can't be empty"
                                  : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Password",
                                  icon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.black38,
                                  ),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              keyboardType: TextInputType.text,
                              onSaved: (value) {
                                _con!.currentUser.password = value;
                              },
                            ),
                          ),

                          /// TextFromField Confirm Password
                          Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                          CustomFormField(
                            formField: TextFormField(
                              validator: (val) => (val!.isEmpty ||
                                      val != _con!.passwordController!.text)
                                  ? "Passwords didn't match"
                                  : null,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Confirm Password",
                                  icon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.black38,
                                  ),
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyText1),
                              keyboardType: TextInputType.text,
                              onSaved: (value) {
                                // _con.currentUser.password = value;
                              },
                            ),
                          ),

                          /// Button Signup
                          MaterialButton(
                              padding: EdgeInsets.only(top: 10.0),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed("/Login");
                              },
                              child: Text(
                                "Have account? Sign In",
                                style: Theme.of(context).textTheme.subtitle2,
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                top: mediaQueryData.padding.top - 15,
                                bottom: 0.0),
                          )
                        ],
                      ),
                    ),

                    /// Set Animaion after user click buttonLogin
                    InkWell(
                      splashColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                      onTap: () {
                        //Login Here
                        _con!.register();
                      },
                      child: CustomSolidButton(
                        txt: "SIGN UP",
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(top: 15.0)),

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
