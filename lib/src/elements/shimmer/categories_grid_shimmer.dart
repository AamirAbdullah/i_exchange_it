import 'package:flutter/material.dart';
import 'package:iExchange_it/src/elements/shimmer/category_shimmer_item.dart';

class CategoriesGridShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return GridView.count(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: isPortrait ? 4 : 7,
      children: List.generate(9,
              (index) {
            return CategoryShimmerItem();
          }
      ),
    );
  }
}
