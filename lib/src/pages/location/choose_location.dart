import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iExchange_it/src/controller/choose_location_controller.dart';
import 'package:iExchange_it/src/models/choose_location_model.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:location/location.dart' as loc;

class ChooseLocationWidget extends StatefulWidget {

 final RouteArgument? argument;

  ChooseLocationWidget({this.argument});

  @override
  _ChooseLocationWidgetState createState() => _ChooseLocationWidgetState();
}

class _ChooseLocationWidgetState extends StateMVC<ChooseLocationWidget> {

  ChooseLocationController? _con;
  // var location = loc.Location();
  // loc.PermissionStatus _status;
  LocationPermission? _status;

  _ChooseLocationWidgetState() : super(ChooseLocationController()) {
    _con = controller as ChooseLocationController?;
  }

  @override
  void initState() {
    super.initState();
    _con!.initiateLocationController();
    // location.hasPermission()
    //     .then(_updateStatus);
    Geolocator.checkPermission().then(_updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Select Location", style: textTheme.headline6, ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: theme.colorScheme.secondary),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(target: LatLng(40.7237765, -74.017617), zoom: 13.0),
                // markers: markers,
                onTap: (pos) {
                  _con!.getAddressAndLocation(pos);
                },
                markers: Set.from(_con!.allMarkers),
                onMapCreated: (GoogleMapController controller) {
                  _con!.isMapCreated = true;
                  _con!.controller = controller;
                  _con!.controller.setMapStyle(_con!.mapStyle);
                },
              ),
            ),

            Positioned(
              bottom: 0,
              child: _con!.allMarkers.length > 0
                  ? Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(width: 70, child: Text("City: ", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),)),
                              Text("${_con!.city}", style: textTheme.bodyText1,)
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Container(width: 70, child: Text("Country: ", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),)),
                              Text("${_con!.country}", style: textTheme.bodyText1,)
                            ],
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: (){
                        ChooseLocationModel loc = ChooseLocationModel();
                        loc.city = _con!.city;
                        loc.country = _con!.country;
                        loc.address = _con!.address;
                        loc.lat = _con!.lat;
                        loc.long = _con!.long;
                        Navigator.of(context).pop(loc);
                      },
                      icon: Icon(CupertinoIcons.checkmark_circle_fill, color: theme.colorScheme.secondary,),
                    )
                  ],
                ),
              )
              : SizedBox(height: 0, width: 0),
            )

          ],
        ),
      ),
    );
  }



  // void _updateStatus(loc.PermissionStatus status) async {
  void _updateStatus(LocationPermission status) async {
    if(_status != status) {
      setState(() {
        _status = status;
      });
      //Check if user location turned On or not
      //then call this function
      _checkLocationServiceStatus();
    } else {
      _askPermission();
    }
  }

  void _askPermission() {
    // if (_status == null) {
    //   location.requestPermission().then((status) {
    //     if(status == loc.PermissionStatus.granted) {
    //       setState(() {
    //         _status = status;
    //         _titleText = "Your Current location";
    //       });
    //       _checkLocationServiceStatus();
    //     } else {
    //       //Start activity to ask to enter it manually
    //       setState(() {
    //         _titleText = "Pick your current location";
    //       });
    //     }
    //   });
    // }
    if(_status == null) {
      Geolocator.requestPermission().then((status) {
        if(status == LocationPermission.always || status == LocationPermission.whileInUse) {
          setState(() {
            _status = status;
          });
          _checkLocationServiceStatus();
        } else {
          //Start activity to ask to enter it manually
          setState(() {
          });
        }
      });
    }
  }

  void _checkLocationServiceStatus() async {
    // if(await location.serviceEnabled())
    // {
    //   _con.getUserLocation();
    // }
    // else
    // {
    //   if(await location.requestService())
    //   {
    //     _con.getUserLocation();
    //   }
    //   else
    //   {
    //     //Enter your Location Manually
    //     setState(() {
    //       _titleText = "Search your location manually";
    //     });
    //   }
    // }
    if(await Geolocator.isLocationServiceEnabled()) {
      _con!.getUserLocation();
    } else {
      if (await Geolocator.openLocationSettings()) {
        _con!.getUserLocation();
      }
      else {
        //Enter your Location Manually
        setState(() {
        });
      }
    }
  }

}
