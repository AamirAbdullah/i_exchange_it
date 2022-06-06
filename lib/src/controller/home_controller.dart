import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/banner.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/item.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/sorting_type.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/product_repository.dart' as prodRepo;
import 'package:iExchange_it/src/repository/category_repository.dart' as catRepo;
import 'package:iExchange_it/src/repository/banner_repository.dart' as bannerRepo;

class HomeController extends ControllerMVC {

  List images = <dynamic>[];
  List<Item> items = <Item>[];
  List<Item> topItems = <Item>[];

  List<Category> categories = <Category>[];
  bool isLoadingCats = false;
  List<Product> featuredProducts = <Product>[];
  bool isLoadingFeatured = false;
  List<Product> popularProducts = <Product>[];
  bool isLoadingPopular = false;
  List<MyBanner> myBanners = <MyBanner>[];

  List<Product> recentProducts = <Product>[];
  List<Product> followingsProducts = <Product>[];

  List<SortingType> sortingTypes = <SortingType>[];
  //Sort By price , date (created_at), name, type, condition
  ///desc, asc
  bool showRecent = false;
  bool showSortDialog = false;
  bool isAscending = true;
  SortingType? selectedType;
  List<Product> products = <Product>[];
  bool isLoading = false;

  GlobalKey<ScaffoldState>? scaffoldKey;
  GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  HomeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

    sortingTypes.add(SortingType(name: "Name", field: "name"));
    sortingTypes.add(SortingType(name: "Price", field: "price"));
    sortingTypes.add(SortingType(name: "Date", field: "created_at"));
    sortingTypes.add(SortingType(name: "Type", field: "type"));
    sortingTypes.add(SortingType(name: "Condition", field: "condition"));
    selectedType = sortingTypes[0];
    isAscending = true;
  }

  getFeaturedProducts() async {
    setState((){isLoadingFeatured = true;});
    Stream<Product> stream = await prodRepo.getFeaturedProducts();
    stream.listen((_product) {
      setState((){
        featuredProducts.add(_product);
      });
    },
        onError: (e){
      print(e);
          setState((){isLoadingFeatured = false;});
          },
        onDone: (){
          setState((){isLoadingFeatured = false;});
    });
  }

  getPopularProducts() async {
    setState((){isLoadingPopular = true;});
    Stream<Product> stream = await prodRepo.getPopularProducts();
    stream.listen((_product) {
      setState((){
        popularProducts.add(_product);
      });
    },
        onError: (e){
          print(e);
          setState((){isLoadingPopular = false;});
        },
        onDone: (){
          setState((){isLoadingPopular = false;});
        });
  }

  getRecentProducts() async {
    Stream<Product> stream = await prodRepo.getRecentProducts();
    stream.listen((_product) {
      setState((){
        this.recentProducts.add(_product);
      });
    },
        onError: (e){
          print(e);
        },
        onDone: (){
        });
  }

  getFollowedUsersProducts() async {
    followingsProducts.clear();
    setState((){
      this.isLoading = false;
    });
    Stream<Product> stream = await prodRepo.getFollowedUsersProducts();
    stream.listen((_product) {
      setState((){
        this.isLoading = false;
        this.followingsProducts.add(_product);
      });
    },
        onError: (e){
          print(e);
        },
        onDone: (){
        });
  }

  getRecentProductsSort() async {
    setState((){recentProducts.clear(); isLoading = true;});
    Stream<Product> stream = await prodRepo.getRecentProducts(sortby: selectedType!.field, order: isAscending ? "asc" : "desc");
    stream.listen((_product) {
      setState((){isLoading = false;});
      setState((){
        this.recentProducts.add(_product);
      });
    },
        onError: (e){
          setState((){isLoading = false;});
          print(e);
        },
        onDone: (){
          setState((){isLoading = false;});
        });
  }

  getFeaturedProductsSort() async {
    setState((){recentProducts.clear(); isLoading = true;});
    Stream<Product> stream = await prodRepo.getFeaturedProducts();
    stream.listen((_product) {
      setState((){isLoading = false;});
      setState((){
        this.recentProducts.add(_product);
      });
    },
        onError: (e){
          setState((){isLoading = false;});
          print(e);
        },
        onDone: (){
          setState((){isLoading = false;});
        });
  }

  getPopularProductsSort() async {
    setState((){recentProducts.clear(); isLoading = true;});
    Stream<Product> stream = await prodRepo.getPopularProducts(sortby: selectedType!.field, order: isAscending ? "asc" : "desc");
    stream.listen((_product) {
      setState((){isLoading = false;});
      setState((){
        this.recentProducts.add(_product);
      });
    },
        onError: (e){
          setState((){isLoading = false;});
          print(e);
        },
        onDone: (){
          setState((){isLoading = false;});
        });
  }

  sortProducts(SortingType type) {
    if(this.selectedType!.name == type.name) {
      setState(() {
        this.isAscending = false;
        showSortDialog = false;
      });
    } else {
      setState(() {
        this.selectedType = type;
        this.isAscending = true;
        showSortDialog = false;
      });
    }
    if(showRecent) {
      getRecentProductsSort();
    } else {
      getFeaturedProductsSort();
    }
  }

  getCategories() async {
    setState((){isLoadingCats = true;});
    Stream<Category> stream = await catRepo.getCategories();
    stream.listen((_cat) {
      setState((){
        categories.add(_cat);
      });
    },
        onError: (e){
      print(e);
      setState((){isLoadingCats = false;});
        },
        onDone: (){
          setState((){isLoadingCats = false;});
    });
  }

  getBanners() async {
    Stream<MyBanner> stream = await bannerRepo.getHomeBanners();
    stream.listen((_banner) {
      setState((){
        this.myBanners.add(_banner);
      });
    },
        onError: (e){
      print(e);
      },
        onDone: (){});
  }

  toggleFavorite(Product _prod) async {
    if(_prod.isFavorite) {
      //Delete Favorite
      prodRepo.removeFavorite(_prod.id).then((value){
        if(value) {
          showToast("Item removed from favorites");
          featuredProducts.forEach((element) {
            if(element.id.toString() == _prod.id.toString()) {
              setState((){
                element.isFavorite = false;
              });
            }
          });
          recentProducts.forEach((element) {
            if(element.id.toString() == _prod.id.toString()) {
              setState((){
                element.isFavorite = false;
              });
            }
          });
          followingsProducts.forEach((element) {
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
      prodRepo.addToFavorite(_prod.id).then((value){
        if(value) {
          showToast("Item added to favorites");
          featuredProducts.forEach((element) {
            if(element.id.toString() == _prod.id.toString()) {
              setState((){
                element.isFavorite = true;
              });
            }
          });
          recentProducts.forEach((element) {
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

  Future<bool> onRefresh() async  {
    this.categories.clear();
    this.featuredProducts.clear();
    this.myBanners.clear();
    this.recentProducts.clear();
    getFeaturedProducts();
    getRecentProducts();
    getCategories();
    getBanners();
    return true;
  }


}