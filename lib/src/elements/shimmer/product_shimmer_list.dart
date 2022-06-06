import 'package:flutter/material.dart';
import 'package:iExchange_it/src/elements/shimmer/featured_product_shimmer.dart';

class ProductShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 301,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            return FeaturedProductShimmer();
          }),
    );
  }
}
