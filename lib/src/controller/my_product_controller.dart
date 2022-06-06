import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/product_repository.dart' as repo;

class MyProductController extends ControllerMVC {

  User? user;

  bool isLoadingProducts = false;

  List<Product> products = <Product>[];

  GlobalKey<ScaffoldState>? scaffoldKey;

  MyProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }


  getUserProducts() async {
    setState((){isLoadingProducts = true; products.clear();});
    Stream<Product> stream = await repo.getUserProducts(this.user!.id);
    stream.listen((_prod) {
      setState((){
        products.add(_prod);
      });
    },
        onError: (e){
          print(e);
          setState((){isLoadingProducts = false;});
        },
        onDone: (){
          setState((){isLoadingProducts = false;});
        });
  }

  getMyProducts() async {
    setState((){isLoadingProducts = true; products.clear();});
    Stream<Product> stream = await repo.getMyProducts();
    stream.listen((_prod) {
      setState((){
       products.add(_prod);
      });
    },
        onError: (e){
      print(e);
      setState((){isLoadingProducts = false;});
        },
        onDone: (){
          setState((){isLoadingProducts = false;});
        });
  }

  toggleFavoriteById(Product _prod) async {
    if(_prod.isFavorite) {
      //Delete Favorite
      repo.removeFavorite(_prod.id).then((value){
        if(value) {
          showToast("Item removed from favorites");
          products.forEach((element) {
            if(element.id.toString() == _prod.id.toString()) {
              setState((){
                element.isFavorite = false;
              });
            }
          });
        }
      });
    } else {
      //Add Favorite
      repo.addToFavorite(_prod.id).then((value){
        if(value) {
          showToast("Item added to favorites");
          products.forEach((element) {
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


}