import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/home_controller.dart';

class TopListCarouselSlider extends StatelessWidget {
  final HomeController? con;

  TopListCarouselSlider({this.con});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 301,
      padding: EdgeInsets.symmetric(vertical: 10),
      // child: ListView.builder(
      //     scrollDirection: Axis.horizontal,
      //     itemCount: con.topItems.length,
      //     itemBuilder: (ctx, index) {
      //       Item item = con.topItems[index];
      //       return CarouselWidgetItem(item: item, onTap: (){
      //         Navigator.of(context).pushNamed("/ItemDetails", arguments: RouteArgument(item: item));
      //         }, onFav: (){},);
      //     }
      // ),
    );
  }
}
