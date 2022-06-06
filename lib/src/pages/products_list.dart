import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/product_list_controller.dart';
import 'package:iExchange_it/src/elements/category/general_category_list_icon.dart';
import 'package:iExchange_it/src/elements/home_section_header.dart';
import 'package:iExchange_it/src/elements/products_grid.dart';
import 'package:iExchange_it/src/elements/shimmer/categories_grid_shimmer.dart';
import 'package:iExchange_it/src/elements/shimmer/grid_product_shimmer_list.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/config/app_config.dart' as config;

class ProductListWidget extends StatefulWidget {

 final RouteArgument? argument;
  ProductListWidget({this.argument});

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends StateMVC<ProductListWidget> {
  ProductListController? _con;

  _ProductListWidgetState() : super(ProductListController()) {
    _con = controller as ProductListController?;
  }

  @override
  void initState() {
    _con!.category = widget.argument!.category;
    _con!.title = widget.argument!.category!.name.toString().toUpperCase();
    _con!.getSubCategories();
    _con!.getProductsByCategory();
    super.initState();
  }

  bool checkPop() {
    if(_con!.selectedChildCat != null) {
      setState((){
        _con!.selectedChildCat = null;
        _con!.title = '${_con!.category!.name.toString().toUpperCase()} > ${_con!.selectedSubCat!.name.toString().toUpperCase()}';
      });
      return false;
    }
    else if(_con!.selectedSubCat != null) {
      setState((){
        _con!.selectedSubCat = null;
        _con!.title = '${_con!.category!.name.toString().toUpperCase()}';
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;


    return WillPopScope(
      onWillPop: () async {
        return checkPop();
      },
      child: Scaffold(
        key: _con!.scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(_con!.category!.name ?? "", style: textTheme.headline4,),
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: (){
              if(checkPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              _con!.isLoadingCats
                  ? CategoriesGridShimmer()
                  : ((_con!.selectedChildCat == null)
                      ? _con!.subCats.isEmpty
                      : _con!.childCats.isEmpty)
                          ? SizedBox(height: 0,)
                          : GridView.count(
                              primary: false,
                              shrinkWrap: true,
                              crossAxisCount: isPortrait ? 4 : 7,
                              children: List.generate(
                                  (_con!.selectedSubCat == null)
                                      ? _con!.subCats.length
                                      : _con!.childCats.length, (index) {

                                var _name = (_con!.selectedSubCat == null)
                                    ? _con!.subCats[index].name
                                    : _con!.childCats[index].name;

                                var _img = (_con!.selectedSubCat == null)
                                    ? _con!.subCats[index].image
                                    : _con!.childCats[index].image;

                                return GeneralCategoryListIconItem(
                                  name: _name,
                                  image: _img,
                                  onTap: () {
                                    if (_con!.selectedSubCat == null) {
                                      //Go for Child Categories &  Products in SubCategroy
                                      _con!.getChildCategories(_con!.subCats[index]);
                                    } else {
                                      //Go for Items in ChildCategory
                                      _con!.getProductsByChildCategory(_con!.childCats[index]);
                                    }
                                  },
                                );
                              }),
                            ),


              HomeSectionHeader(icon: Icons.play_arrow,
                text: _con!.title,
                color: config.Colors().recentColor(1),
                textColor: Colors.black,
                isShowSeeAll: false,
                onSeeAll: (){},),


              _con!.isLoadingProducts
              ? GridProductShimmerList()
              : (_con!.selectedSubCat == null && _con!.selectedChildCat == null)
                ? ProductsGrid(products: _con!.catProducts,)
                  : (_con!.selectedSubCat != null && _con!.selectedChildCat == null)
                  ? ProductsGrid(products: _con!.subCatProducts,)
                  : (_con!.selectedSubCat != null && _con!.selectedChildCat != null)
                  ? ProductsGrid(products: _con!.chilCatProducts,)
                  :SizedBox(height: 0,)



            ],
          ),
        ),
      ),
    );
  }
}
