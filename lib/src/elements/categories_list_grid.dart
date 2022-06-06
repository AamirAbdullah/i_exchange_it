import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/home_controller.dart';

import 'package:iExchange_it/src/elements/category/category_list_icon_item.dart';
import 'package:iExchange_it/src/elements/shimmer/categories_grid_shimmer.dart';
import 'package:iExchange_it/src/models/route_argument.dart';

class CategoriesListGrid extends StatelessWidget {

 final HomeController? con;

  CategoriesListGrid({this.con});

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return con!.isLoadingCats
        ? CategoriesGridShimmer()
        : con!.categories.isEmpty
    ? SizedBox(height: 0,)
    : GridView.count(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: isPortrait ? 4 : 7,
      children: List.generate(con!.categories.length,
              (index) {
            return CategoryListIconItem(cat: con!.categories[index], 
              onTap: (){
                // Navigator.of(context).pushNamed("/ProductListByCategory", arguments: RouteArgument(category: con.categories[index]));
                Navigator.of(context).pushNamed("/ShowSubcategories", arguments: RouteArgument(category: con!.categories[index], categories: con!.categories));
              },
            );
          }
      ),
    );
  }
}
