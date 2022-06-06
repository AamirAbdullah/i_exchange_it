import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/user_controller.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends StateMVC<MyAccount> {

  UserController? _con;

  _MyAccountState() : super(UserController()) {
    _con = controller as UserController?;
  }

  @override
  void initState() {
    super.initState();
    _con!.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Account", style: textTheme.headline6, ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 20,),
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _con!.currentUser.image != null && _con!.currentUser.image.length > 0
                        ? CachedNetworkImage(
                      imageUrl: _con!.currentUser.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                    ) : Image.asset("assets/placeholders/profile.png",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    _con!.currentUser.name ?? "NOT LOGGED IN",
                    style: textTheme.subtitle1,
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
              child: Column(
                children: [
                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/MyProducts");
                    },
                    title: Text("My Ads", style: textTheme.bodyText2,),
                    leading: Icon(CupertinoIcons.collections_solid, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                  : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? Container(
                    height: 0.3,
                    color: theme.focusColor,
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/Favorites", arguments: RouteArgument(user: _con!.currentUser));
                    },
                    title: Text("Favorites", style: textTheme.bodyText2,),
                    leading: Icon(CupertinoIcons.heart_solid, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? Container(
                    height: 0.3,
                    color: theme.focusColor,
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/MyWishlist", arguments: RouteArgument(user: _con!.currentUser));
                    },
                    title: Text("My Wishlist", style: textTheme.bodyText2,),
                    leading: Icon(Icons.person_pin_rounded, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? Container(
                    height: 0.3,
                    color: theme.focusColor,
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/CreateWishlist", arguments: RouteArgument(user: _con!.currentUser));
                    },
                    title: Text("Create Wishlist Item", style: textTheme.bodyText2,),
                    leading: Icon(CupertinoIcons.create_solid, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? Container(
                    height: 0.3,
                    color: theme.focusColor,
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    dense: true,
                    title: Text("Preferences", style: textTheme.subtitle2,),
                    // leading: Icon(CupertinoIcons.heart_solid, color: Colors.white, size: 20,),
                    // trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/ViewProfile", arguments: RouteArgument(user: _con!.currentUser));
                    },
                    title: Text("My Profile", style: textTheme.bodyText2,),
                    leading: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? Container(
                    height: 0.3,
                    color: theme.focusColor,
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/OffersSubmitted", arguments: RouteArgument(user: _con!.currentUser));
                    },
                    title: Text("Offers Submitted", style: textTheme.bodyText2,),
                    leading: Icon(Icons.assignment_turned_in, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? Container(
                    height: 0.3,
                    color: theme.focusColor,
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/OffersReceived", arguments: RouteArgument(user: _con!.currentUser));
                    },
                    title: Text("Offers Received", style: textTheme.bodyText2,),
                    leading: Icon(Icons.assignment_returned_sharp, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? Container(
                    height: 0.3,
                    color: theme.focusColor,
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/QnAList", arguments: RouteArgument(user: _con!.currentUser));
                    },
                    title: Text("Q & A Forum", style: textTheme.bodyText2,),
                    leading: Icon(Icons.question_answer_rounded, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                  _con!.currentUser.apiToken != null
                      ? Container(
                    height: 0.3,
                    color: theme.focusColor,
                  )
                      : SizedBox(height: 0),


                  // ListTile(
                  //   title: Text("Help & Support", style: textTheme.bodyText2,),
                  //   leading: Icon(CupertinoIcons.news_solid, color: Colors.white, size: 20,),
                  //   trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  // ),
                  //
                  // Container(
                  //   height: 0.3,
                  //   color: theme.focusColor,
                  // ),

                  ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/HelpAndSupport");
                    },
                    title: Text("Help & Support", style: textTheme.bodyText2,),
                    leading: Icon(Icons.help_outlined, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  ),
                  Container(
                    height: 0.3,
                    color: theme.focusColor,
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/TermsOfUse");
                    },
                    title: Text("Terms of use", style: textTheme.bodyText2,),
                    leading: Icon(Icons.filter_frames, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  ),
                  Container(
                    height: 0.3,
                    color: theme.focusColor,
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/PrivacyPolicy");
                    },
                    title: Text("Privacy Policy", style: textTheme.bodyText2,),
                    leading: Icon(Icons.lock, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  ),
                  Container(
                    height: 0.3,
                    color: theme.focusColor,
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.of(context).pushNamed("/About");
                    },
                    title: Text("About", style: textTheme.bodyText2,),
                    leading: Icon(Icons.info, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  ),
                  Container(
                    height: 0.3,
                    color: theme.focusColor,
                  ),

                  _con!.currentUser.apiToken != null
                      ? ListTile(
                    onTap: (){
                      userRepo.logout().then((value) {
                        Navigator.of(context).pushNamedAndRemoveUntil("/ChooseLogin", (Route<dynamic> route) => false);
                      });
                    },
                    title: Text("Log out", style: textTheme.bodyText2,),
                    leading: Icon(Icons.power_settings_new, color: Colors.white, size: 20,),
                    trailing: Icon(CupertinoIcons.forward, color: Colors.white, size: 15,),
                  )
                      : SizedBox(height: 0),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
