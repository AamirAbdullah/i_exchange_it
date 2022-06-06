// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/bid.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/bids_repository.dart' as repo;
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class BidController extends ControllerMVC {

  User? currentUser;
  Product? product;
  Bid bid = Bid();
  bool isLoading = false;

  List<Bid> bids = <Bid>[];


  GlobalKey<ScaffoldState>? scaffoldKey;
  GlobalKey<FormState>? formKey;

  BidController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.formKey = new GlobalKey<FormState>();
  }

  placeBid() async {
    if(this.formKey!.currentState!.validate()) {

      this.formKey!.currentState!.save();

      bid.productId = this.product!.id;
      bid.userId = this.product!.userId;

      setState((){ isLoading = true; });

      repo.placeBid(bid).then((value) {
        setState(() {
          isLoading = false;
        });
        if (value != null) {
          showToast("Bid Placed Successfully");
          Navigator.of(this.scaffoldKey!.currentContext!).pop();
        } else {
          showToast("You can't bid twice on a product");
        }
      }, onError: (e) {
        print(e);
        
        scaffoldKey!.currentState!.showSnackBar(
            SnackBar(content: Text("Verify your internet connection")));
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  getBidsPlaced() async {
    bids.clear();
    setState((){
      isLoading = true;
    });
    Stream<Bid> stream = await repo.getOffersPlaced();
    stream.listen((event) {
      setState(() {
        this.bids.add(event);
      });
    }, onError: (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      scaffoldKey!.currentState!.showSnackBar(
          SnackBar(content: Text("Verify your internet connection")));
    }, onDone: () {
      setState(() {
        isLoading = false;
      });
    });
  }

  getBidsReceived() async {
    bids.clear();
    setState((){
      isLoading = true;
    });
    Stream<Bid> stream = await repo.getOffersReceived();
    stream.listen((event) {
      setState(() {
        this.bids.add(event);
      });
    }, onError: (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      scaffoldKey!.currentState!.showSnackBar(
          SnackBar(content: Text("Verify your internet connection")));
    }, onDone: () {
      setState(() {
        isLoading = false;
      });
    });
  }

  getCurrentUser() async {
    userRepo.getCurrentUser().then((value) {
      setState((){
        this.currentUser = value;
      });
    });
  }

}
