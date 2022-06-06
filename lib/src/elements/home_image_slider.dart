
import 'package:flutter/material.dart';
import 'package:iExchange_it/library/carousel/carousel_pro.dart';
import 'package:iExchange_it/src/controller/home_controller.dart';


class HomeImageSlider extends StatelessWidget {
 final HomeController? con;

  HomeImageSlider({this.con});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 00.5625,
      child:  Carousel(
        boxFit: BoxFit.fill,
        dotColor: Theme.of(context).colorScheme.secondary,
        dotSize: 5.5,
        dotSpacing: 16.0,
        dotBgColor: Colors.transparent,
        showIndicator: true,
        overlayShadow: true,
        overlayShadowColors: Theme.of(context).scaffoldBackgroundColor,
        overlayShadowSize: 0.9,
        banners: con!.myBanners,
      ),
    );
  }
}
