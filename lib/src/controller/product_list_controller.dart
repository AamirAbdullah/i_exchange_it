import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/sub_category.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/category_repository.dart' as catRepo;
import 'package:iExchange_it/src/repository/product_repository.dart' as proRepo;

class ProductListController extends ControllerMVC {

  Category? category;
  String title = "";
  bool isLoadingCats = false;
  bool isLoadingProducts = false;

  List<SubCategory> subCats = <SubCategory>[];
  List<Product> catProducts = <Product>[];

  SubCategory? selectedSubCat;
  List<Product> subCatProducts = <Product>[];

  List<ChildCategory> childCats = <ChildCategory>[];

  ChildCategory? selectedChildCat;
  List<Product> chilCatProducts = <Product>[];

  GlobalKey<ScaffoldState>? scaffoldKey;

  ProductListController() {
    this.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  getSubCategories() async {
    setState((){
      isLoadingCats = true;
      this.childCats.clear();
      this.subCats.clear();
    });
    Stream<SubCategory> stream = await catRepo.getSubCategories(this.category!.id);
    stream.listen((_subCat) {
      setState((){
        this.subCats.add(_subCat);
      });
    },
      onError: (e){
        print(e);
        setState((){ isLoadingCats = false; });
      },
      onDone: (){
        setState((){ isLoadingCats = false; });
      }
    );
  }

  getChildCategories(SubCategory _selectedSubCat) async {
    setState((){
      isLoadingCats = true;
      this.childCats.clear();
      this.selectedSubCat = _selectedSubCat;
    });
    Stream<ChildCategory> stream = await catRepo.getChildCategories(_selectedSubCat.id);
    stream.listen((_subCat) {
      setState((){
        this.childCats.add(_subCat);
      });
    },
        onError: (e){
          print(e);
          setState((){ isLoadingCats = false; });
        },
        onDone: (){
          setState((){ isLoadingCats = false; });
          getProductsBySubCategory();
        }
    );
  }

  getProductsByCategory() async {
    setState((){
      isLoadingProducts = true;
      this.catProducts.clear();
    });
    Stream<Product> stream = await proRepo.getProductsByCategory(this.category!.id);
    stream.listen((_product) {
      setState((){
        this.catProducts.add(_product);
      });
    },
        onError: (e){
      print(e);
      setState((){isLoadingProducts = false;});
        },
        onDone: (){
          setState((){
            isLoadingProducts = false;
          });
    });
  }

  getProductsBySubCategory() async {
    setState((){
      isLoadingProducts = true;
      title = '${this.category!.name.toString().toUpperCase()} > ${this.selectedSubCat!.name.toString().toUpperCase()}';
      this.subCatProducts.clear();
    });
    Stream<Product> stream = await proRepo.getProductsBySubCategory(this.selectedSubCat!.id);
    stream.listen((_product) {
      setState((){
        this.subCatProducts.add(_product);
      });
    },
        onError: (e){
          print(e);
          setState((){isLoadingProducts = false;});
        },
        onDone: (){
          setState((){isLoadingProducts = false;});});
  }

  getProductsByChildCategory(ChildCategory _selectedChildCat) async {
    setState((){
      isLoadingProducts = true;
      selectedChildCat = _selectedChildCat;
      title = '${this.category!.name.toString().toUpperCase()} > ${this.selectedSubCat!.name.toString().toUpperCase()} > ${this.selectedChildCat!.name.toString().toUpperCase()}';
      this.chilCatProducts.clear();
    });
    Stream<Product> stream = await proRepo.getProductsByChildCategory(this.selectedChildCat!.id);
    stream.listen((_product) {
      setState((){
        this.chilCatProducts.add(_product);
      });
    },
        onError: (e){
          print(e);
          setState((){isLoadingProducts = false;});
        },
        onDone: (){
          setState((){isLoadingProducts = false;});});
  }

}