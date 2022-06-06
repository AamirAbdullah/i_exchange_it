import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:location/location.dart' as l;

class ChooseLocationController extends ControllerMVC {

  GlobalKey<ScaffoldState>? scaffoldKey;


  late GoogleMapController controller;
  BitmapDescriptor? customIcon;
  bool isMapCreated = false;
  String? mapStyle;
  List<Marker> allMarkers = [];

  String? city = "";
  String? country = "";
  String? address = "";
  var lat;
  var long;

  ChooseLocationController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }





  initiateLocationController() async {
    rootBundle.loadString('assets/map/darkmap.txt').then((string) {
      mapStyle = string;
    });
  }
  void setMapStyle(String mapStyle) {
    controller.setMapStyle(mapStyle);
  }
  // TO GET THE USER LOCATION
  void getUserLocation() async {
    print("Getting user location: 2");
    // l.LocationData position = await l.Location().getLocation();
    final position = await Geolocator.getCurrentPosition();
    LatLng pos = LatLng(position.latitude, position.longitude);
    getAddressAndLocation(pos);
  }

  void getAddressAndLocation(LatLng position) async {
    double latitude = position.latitude;
    double longitude = position.longitude;
   List<Placemark> addresses =
        await placemarkFromCoordinates(latitude, longitude);

    var addressGot = addresses.first.administrativeArea! +
        ", " +
        addresses.first.subAdministrativeArea! +
        " " +
        addresses.first.country!;

    setState((){
      this.address = addresses.first.administrativeArea;
      this.city = addresses.first.subAdministrativeArea;
      this.country = addresses.first.country;
      this.lat = latitude.toString();
      this.long = longitude.toString();
    });

    print("Getting user location: 34 " + addressGot);
    updateCurrentMarker(position, addressGot);
  }

  updateCurrentMarker(LatLng location, String address) {
    Marker m = Marker(markerId: MarkerId('1'),
        position: location,
        infoWindow: InfoWindow(
            title: address,
            snippet: "You're Here"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        )
    );
    setState(() {
      controller.animateCamera(CameraUpdate.newLatLng(location));
      allMarkers.clear();
      allMarkers.add(m);
    });
  }

}