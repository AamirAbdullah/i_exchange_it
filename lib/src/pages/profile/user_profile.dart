// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/profile_controller.dart';
import 'package:iExchange_it/src/elements/CircularLoadingWidget.dart';
import 'package:iExchange_it/src/elements/home_grid_widget_item.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileWidget extends StatefulWidget {

 final RouteArgument? argument;

  UserProfileWidget({this.argument});

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends StateMVC<UserProfileWidget> {

  ProfileController? _con;

  _UserProfileWidgetState() : super(ProfileController()) {
    _con = controller as ProfileController?;
  }

  @override
  void initState() {
    _con!.user = widget.argument!.user;
    _con!.getCurrentUser();
    _con!.getUserDetails(widget.argument!.user!.id.toString());
    _con!.isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;


    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final double itemWidth = (size.width / 2);
    final double landscapeItemWidth =  (size.width / 3);

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Profile", style: textTheme.headline6, ),
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(CupertinoIcons.back),),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _con!.user != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 20,),
            Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _con!.user!.image != null && _con!.user!.image.length > 0
                        ? CachedNetworkImage(
                      imageUrl: _con!.user!.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                    )
                        : Image.asset("assets/placeholders/profile.png",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,),
                  ),

                ],
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
                    width: 100,
                    child: _con!.currentUser.id != _con!.user!.id
                        ? _con!.loadingFollow
                        ? CircularLoadingWidget(
                            height: 40,
                          )
                        : _con!.user!.followed
                            ? MaterialButton(
                                color: theme.primaryColor,
                                onPressed: () {
                                  _con!.followUser();
                                },
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      'Un Follow',
                                      style: textTheme.subtitle1,
                                    ),
                                  ),
                                ),
                              )
                            : MaterialButton(
                                color: theme.colorScheme.secondary,
                                onPressed: () {
                                  _con!.followUser();
                                },
                                child: Center(
                                  child: Text(
                                    'Follow',
                                    style: textTheme.subtitle1,
                                  ),
                                ),
                              ) : SizedBox(height: 40,),
                  ),
                  SizedBox(height: 10,),


            _con!.user != null && _con!.user!.name != null ?
            ListTile(
              leading: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 20,),
              title: Text("Name", style: textTheme.subtitle1,),
              subtitle: Text(_con!.user == null ? "" : _con!.user!.name, style: textTheme.subtitle2,),
              onTap: (){

              },
            ) : SizedBox(height: 0,),

            _con!.user != null && _con!.user!.phone != null ?
            ListTile(
              leading: Icon(CupertinoIcons.phone_solid, color: Colors.white, size: 20,),
              title: Text("Phone", style: textTheme.subtitle1,),
              subtitle: Text(_con!.user==null && _con!.user!.phone ==null ? "" : _con!.user!.phone, style: textTheme.subtitle2,),
              trailing: Icon(Icons.arrow_forward_ios, size: 15, color: theme.focusColor,),
              onTap: () async {
                if(_con!.user!.phone != null && _con!.currentUser.id.toString() != _con!.user!.id.toString()) {
                  if (await canLaunch("tel:${_con!.user!.phone}")) {
                    await launch("tel:${_con!.user!.phone}");
                    }
                }
              },
            ) : SizedBox(height: 0,),

            _con!.user != null && _con!.user!.phone != null ?
            ListTile(
              leading: Icon(CupertinoIcons.phone_solid, color: Colors.white, size: 20,),
              title: Text("Address", style: textTheme.subtitle1,),
              subtitle: Text(_con!.user==null || _con!.user!.address==null ? "" : _con!.user!.phone, style: textTheme.subtitle2,),
            ) : SizedBox(height: 0,),




            _con!.user != null && _con!.user!.products != null && _con!.user!.products!.isNotEmpty
            ? ListTile(
              title: Text("Ads by user", style: textTheme.subtitle2,),
              leading: Icon(CupertinoIcons.alt, color: theme.accentColor,),
              tileColor: theme.focusColor.withOpacity(0.4),
            )
            : SizedBox(height: 0),


            _con!.user != null && _con!.user!.products != null && _con!.user!.products!.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GridView.count(
                childAspectRatio: isPortrait
                    ? (itemWidth / 251)
                    : (landscapeItemWidth / 251),
                crossAxisCount: isPortrait ? 2 : 3,
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 10),
                children: List.generate(
                    _con!.user!.products!.length, (index) {
                  Product product =
                  _con!.user!.products![index];
                  return HomeGridWidgetItem(
                    product: product,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          "/ItemDetails",
                          arguments: RouteArgument(
                              product: product, isMine: true));
                    },
                    onFav: () {
                      // _con.toggleFavoriteById(product);
                    },
                  );
                }),
              ),
            )

                : SizedBox(height: 0),


          ],
        )
            : Container(
          width: size.width,
          height: size.height,
          child: Center(
            child: CircularLoadingWidget(height: 100,),
          ),
        ),


      ),
    );
  }
}
