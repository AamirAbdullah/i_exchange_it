import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/choose_location_model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/controller/profile_controller.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:flutter/cupertino.dart';

class ViewProfile extends StatefulWidget {
 final RouteArgument? argument;

  ViewProfile({this.argument});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends StateMVC<ViewProfile> {

  ProfileController? _con;

  _ViewProfileState() : super(ProfileController()) {
    _con = controller as ProfileController?;
  }

  @override
  void initState() {
    _con!.getCurrentUser();
    _con!.user = widget.argument!.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return WillPopScope(
      onWillPop: () async {
        if(_con!.isLoading) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _con!.scaffoldKey,
        appBar: AppBar(
          title: Text("Profile", style: textTheme.headline6, ),
          backgroundColor: theme.scaffoldBackgroundColor,
          centerTitle: true,
          leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(CupertinoIcons.back),),
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: 20,),
                  Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _con!.user!.isNewImage 
                              ? Image.file(File(_con!.user!.newImgIdentifier),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,)
                              : _con!.user!.image != null && _con!.user!.image.length > 0
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

                        _con!.user!.id == _con!.currentUser.id
                            ? Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: (){
                              _con!.getGalleryImage();
                            },
                            color: theme.focusColor,
                            icon: Icon(CupertinoIcons.camera_fill, color: theme.colorScheme.secondary,),
                          ),
                        )
                            : SizedBox(height: 0, width: 0)
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),

                  ListTile(
                    leading: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 20,),
                    title: Text("Name", style: textTheme.subtitle1,),
                    subtitle: Text(_con!.user==null ? "" : _con!.user!.name, style: textTheme.subtitle2,),
                    trailing: _con!.user!.id == _con!.currentUser.id
                        ? Icon(_con!.isEditingName ? Icons.keyboard_arrow_down
                        : Icons.arrow_forward_ios, size: _con!.isEditingName ? 22 : 15, color: theme.focusColor,) : null,
                    onTap: (){
                      setState((){
                        _con!.isEditingName = true;
                        _con!.isEditingPhone = false;
                        _con!.isEditingAddress = false;
                      });
                    },
                    selectedTileColor: theme.focusColor.withOpacity(0.2),
                    selected: _con!.isEditingName,
                  ),


                  _con!.isEditingName ? Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update your name", style: textTheme.subtitle1!.merge(TextStyle(color: theme.colorScheme.secondary)),),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _con!.nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: "Name",
                            labelStyle: TextStyle(color: theme.colorScheme.secondary),
                            contentPadding: EdgeInsets.all(12),
                            prefixIcon: Icon(CupertinoIcons.person_solid, color: Colors.white, size: 20,),
                            prefixIconConstraints: BoxConstraints(maxWidth: 100, minWidth: 50),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                            children: [
                              Spacer(),
                              MaterialButton(
                                onPressed: (){
                                  setState((){
                                    _con!.isEditingName = false;
                                  });
                                },
                                color: theme.focusColor,
                                child: Text("Cancel", style: textTheme.subtitle2,),
                              ),
                              SizedBox(width: 10,),
                              MaterialButton(
                                onPressed: (){
                                  _con!.updateName();
                                },
                                color: theme.colorScheme.secondary,
                                child: Text("Update", style: textTheme.subtitle2!.merge(TextStyle(color: Colors.white)),),
                              ),
                            ]
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  ) : SizedBox(height: 0),



                  ListTile(
                    leading: Icon(CupertinoIcons.phone_solid, color: Colors.white, size: 20,),
                    title: Text("Phone", style: textTheme.subtitle1,),
                    subtitle: Text(_con!.user==null ? "" : _con!.user!.phone, style: textTheme.subtitle2,),
                    trailing: _con!.user!.id == _con!.currentUser.id
                        ? Icon(_con!.isEditingPhone ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios, size: _con!.isEditingPhone ? 22 : 15, color: theme.focusColor,)
                    : null,
                    onTap: (){
                      setState((){
                        _con!.isEditingName = false;
                        _con!.isEditingAddress = false;
                        _con!.isEditingPhone = true;
                      });
                    },
                    selectedTileColor: theme.focusColor.withOpacity(0.2),
                    selected: _con!.isEditingPhone,
                  ),

                  _con!.isEditingPhone ? Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update your Phone", style: textTheme.subtitle1!.merge(TextStyle(color: theme.colorScheme.secondary)),),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _con!.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: "Phone",
                            labelStyle: TextStyle(color: theme.colorScheme.secondary),
                            contentPadding: EdgeInsets.all(12),
                            prefixIcon: Icon(CupertinoIcons.phone_solid, color: Colors.white, size: 20,),
                            prefixIconConstraints: BoxConstraints(maxWidth: 100, minWidth: 50),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                            children: [
                              Spacer(),
                              MaterialButton(
                                onPressed: (){
                                  setState((){
                                    _con!.isEditingPhone = false;
                                  });
                                },
                                color: theme.focusColor,
                                child: Text("Cancel", style: textTheme.subtitle2,),
                              ),
                              SizedBox(width: 10,),
                              MaterialButton(
                                onPressed: (){
                                  _con!.updateEmail();
                                },
                                color: theme.colorScheme.secondary,
                                child: Text("Update", style: textTheme.subtitle2!.merge(TextStyle(color: Colors.white)),),
                              ),
                            ]
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  ) : SizedBox(height: 0),



                  ListTile(
                    leading: Icon(CupertinoIcons.location_solid, color: Colors.white, size: 20,),
                    title: Text("Address", style: textTheme.subtitle1,),
                    subtitle: Text(_con!.user==null ? "" : _con!.user!.address ?? "", style: textTheme.subtitle2,),
                    trailing: _con!.user!.id == _con!.currentUser.id
                        ? Icon(_con!.isEditingAddress ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
                      size: _con!.isEditingAddress ? 22 : 15, color: theme.focusColor,)
                        : null,
                    onTap: (){
                      setState((){
                        _con!.isEditingName = false;
                        _con!.isEditingPhone = false;
                        _con!.isEditingAddress = true;
                      });
                    },
                    selectedTileColor: theme.focusColor.withOpacity(0.2),
                    selected: _con!.isEditingAddress,
                  ),

                  _con!.isEditingAddress
                      ? Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update your Address", style: textTheme.subtitle1!.merge(TextStyle(color: theme.colorScheme.secondary)),),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _con!.addressController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: "Address",
                                  labelStyle: TextStyle(color: theme.colorScheme.secondary),
                                  contentPadding: EdgeInsets.all(12),
                                  prefixIcon: Icon(CupertinoIcons.location_solid, color: Colors.white, size: 20,),
                                  prefixIconConstraints: BoxConstraints(maxWidth: 100, minWidth: 50),
                                ),
                              ),
                            ),

                            IconButton(
                                icon: Icon(CupertinoIcons.location_solid, color: theme.colorScheme.secondary,),
                                onPressed: (){
                                  Navigator.of(context).pushNamed("/ChooseLocation").then((value) {
                                    if(value != null) {
                                      var loc = value as ChooseLocationModel;
                                      setState((){
                                        _con!.addressController!.text = loc.address;
                                      });
                                    }
                                  });
                                })
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                            children: [
                              Spacer(),
                              MaterialButton(
                                onPressed: (){
                                  setState((){
                                    _con!.isEditingAddress = false;
                                  });
                                },
                                color: theme.focusColor,
                                child: Text("Cancel", style: textTheme.subtitle2,),
                              ),
                              SizedBox(width: 10,),
                              MaterialButton(
                                onPressed: (){
                                  _con!.updateAddress();
                                },
                                color: theme.colorScheme.secondary,
                                child: Text("Update", style: textTheme.subtitle2!.merge(TextStyle(color: Colors.white)),),
                              ),
                            ]
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  ) : SizedBox(height: 0),


                ],
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
                : Positioned(bottom: 0, child: SizedBox(height: 0)),
          ],
        ),
      ),
    );
  }
}
