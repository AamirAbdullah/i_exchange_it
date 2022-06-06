// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iExchange_it/src/models/item.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/review.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/product_repository.dart' as repo;
import 'package:iExchange_it/src/repository/review_repository.dart' as reviewRepo;

import '../models/child_category.dart';

class ItemController extends ControllerMVC {

  User? currentUser;
  Item? item;
  PageController? controller;
  PageController? secondaryController;
  double? index = 0;

  Product? product;
  bool isMine = false;
  bool showImage = false;

  bool showDeleteDialog = false;
  bool isLoading = false;

  List<Product> favorites = <Product>[];
  bool isLoadingProducts = false;
  List<Review> reviews = <Review>[];
  int reviewsCount = 0; //Total Enabled Reviews

  ChildCategory? selectedChildCat;
  List<Product> catProducts = <Product>[];

  GlobalKey<ScaffoldState>? scaffoldKey;

  ItemController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    controller = PageController();
    secondaryController = PageController();
    controller!.addListener(() {
      setState((){
        index = controller!.page;
      });
    });
  }

  getFavoriteProducts() async {
    setState((){isLoadingProducts = true; this.favorites.clear();});
    Stream<Product> stream = await repo.getFavoriteProducts();
    stream.listen((_prod) {
      _prod.isFavorite = true;
      setState((){
        this.favorites.add(_prod);
      });
    },
        onError: (e){
      print(e);
      setState((){isLoadingProducts = false; });
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Varify your internet connection")));
        },
        onDone: (){
          setState((){isLoadingProducts = false; });
    });
  }

  getProductDetails() async {
    Stream<Product> stream = await repo.getProductDetails(product!.id.toString());
    stream.listen((_product) {
      setState((){
        this.product = _product;
      });
    },
        onError: (e){
      print(e);
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Verify your internet connection")));
        },
        onDone: (){
      if(this.product!.latitude != null && this.product!.longitude != null) {
        var lat = double.parse(this.product!.latitude.toString());
        var long = double.parse(this.product!.longitude.toString());
        updateCurrentMarker(LatLng(lat, long));
      }
        });
  }

  getProductsByChildCategory(var id) async {
    setState((){
      isLoadingProducts = true;
      this.catProducts.clear();
    });
    Stream<Product> stream = await repo.getProductsByChildCategory(id);
    stream.listen((_product) {
      if(this.product!.id.toString() != _product.id.toString()) {
        setState(() {
          this.catProducts.add(_product);
        });
      }
    },
        onError: (e){
          print(e);
          setState((){isLoadingProducts = false;});
        },
        onDone: (){
          setState((){isLoadingProducts = false;});});
  }

  getProductReviews() async {
    Stream<Review> stream = await reviewRepo.getReviewsOfProduct(product!.id.toString());
    stream.listen((_review) {
      setState((){
        this.reviews.add(_review);
        if(_review.status == true || _review.status == 1 || _review.status == "1") {
          reviewsCount++;
        }
      });
    },
        onError: (e){
          print(e);
        },
        onDone: (){
        });
  }

  deleteProduct() async {
    repo.deleteProduct(this.product!.id.toString()).then((value) {
      showToast(value ? "Deleted Successfully" : "Unable to delete");
      if(value) {
        Navigator.of(this.scaffoldKey!.currentContext!).pop(true);
      }
    }, onError: (e){
      print(e);
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Verify your internet connection")));
    });
  }

  getOpponentUser(var id) async {
    // userRepo.getUserProfile(id).then((_user) {
    //   setState(() {
    //     Owner = _user;
    //   });
    // });
  }

  changeReviewStatus(Review _review) async {
    setState((){this.isLoading = true;});
    reviewRepo.changeReviewStatus(_review).then((value) {
      setState((){this.isLoading = false;});
      if (value != null) {
        for(int i = 0; i<this.reviews.length; i++) {
          if(this.reviews[i].id.toString() == value.id.toString()) {
            setState((){
              this.reviews[i] = value;
              if(value.status == true || value.status == 1 || value.status == "1") {
                reviewsCount++;
              } else {
                reviewsCount--;
              }
            });
          }
        }
      } else {
        scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Some Error Occurred, Try later please")));
      }
    }, onError: (e) {
      setState((){this.isLoading = false;});
      print(e);
      scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Verify your internet connection")));
    });
  }

  toggleFavorite() async {
    if(this.product!.isFavorite) {
      //Remove Favorite
      repo.removeFavorite(this.product!.id).then((value){
        if(value) {
          showToast("Item removed from favorites");
          setState((){
            this.product!.isFavorite = false;
          });
        }
      });
    } else {
      //Add Favorite
      repo.addToFavorite(this.product!.id).then((value){
        if(value) {
          showToast("Item added to favorites");
          setState((){
            this.product!.isFavorite = true;
          });
        }
      });
    }
  }

  toggleFavoriteById(Product _prod) async {
    if(_prod.isFavorite) {
      //Delete Favorite
      repo.removeFavorite(_prod.id).then((value){
        if(value) {
          showToast("Item removed from favorites");
          favorites.forEach((element) {
            if(element.id.toString() == _prod.id.toString()) {
              setState((){
                element.isFavorite = false;
              });
            }
          });
        }
      });
    }
    else {
      //Add Favorite
      repo.addToFavorite(_prod.id).then((value){
        if(value) {
          showToast("Item added to favorites");
          favorites.forEach((element) {
            if(element.id.toString() == _prod.id.toString()) {
              setState((){
                element.isFavorite = true;
              });
            }
          });
        }
      });
    }
  }

  downloadImage(String url) async {
    // //comment out the next two lines to prevent the device from getting
    // // the image from the web in order to prove that the picture is
    // // coming from the device instead of the web.
    // var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg"; // <-- 1
    // var response = await get(url); // <--2
    // var documentDirectory = await getApplicationDocumentsDirectory();
    // var firstPath = documentDirectory.path + "/images";
    // var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    // //comment out the next three lines to prevent the image from being saved
    // //to the device to show that it's coming from the internet
    // await Directory(firstPath).create(recursive: true); // <-- 1
    // File file2 = new File(filePathAndName);             // <-- 2
    // file2.writeAsBytesSync(response.bodyBytes);         // <-- 3
    // setState(() {
    //   imageData = filePathAndName;
    //   dataLoaded = true;
    // });
  }


  late GoogleMapController mapController;
  BitmapDescriptor? customIcon;
  bool isMapCreated = false;
  String? mapStyle;
  List<Marker> allMarkers = [];

  initiateLocationController() async {
    rootBundle.loadString('assets/map/darkmap.txt').then((string) {
      mapStyle = string;
    });
  }
  void setMapStyle(String mapStyle) {
    mapController.setMapStyle(mapStyle);
  }

  updateCurrentMarker(LatLng location) {
    // Marker m = Marker(markerId: MarkerId('1'),
    //     position: location,
    //     infoWindow: InfoWindow(
    //         title: "Here it is",
    //         snippet: "Seller is Here"
    //     ),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(
    //       BitmapDescriptor.hueRed,
    //     )
    // );
    setState(() {
      mapController.animateCamera(CameraUpdate.newLatLng(location));
      allMarkers.clear();
      // allMarkers.add(m);
    });
  }

}