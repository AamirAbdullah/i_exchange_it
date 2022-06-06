import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/item_controller.dart';

class ItemDetailsImageSlider extends StatelessWidget {

 final ItemController? con;
 final Function(int index)? onTap;
  ItemDetailsImageSlider({this.con, this.onTap});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width,
          child: PageView.builder(
              controller: con!.controller,
              physics: PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              // itemCount: [con.item.image, con.item.image, con.item.image,].length,
              itemCount: (con!.product!.images != null && con!.product!.images!.length > 0) 
                  ? con!.product!.images!.length : 1,
              itemBuilder: (context, index) {
                return (con!.product!.images != null && con!.product!.images!.length > 0) 
                    ? InkWell(
                  onTap: (){
                    this.onTap!(index);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CachedNetworkImage(
                      imageUrl: con!.product!.images![index].path,
                      fit: BoxFit.cover,
                    ),
                  ),
                ) 
                    : Image.asset("assets/placeholders/image.jpg", fit: BoxFit.cover,)
                ;
              }
          ),
        ),
        Positioned(
          bottom: 0,
          right: 1,
          left: 1,
          child: IgnorePointer(
            child: Container(
                height: 50,
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      (con!.product!.images != null && con!.product!.images!.length > 0)
                          ? con!.product!.images!.length : 1,
                          (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          width: con!.index == index ? 9 : 7,
                          height: con!.index == index ? 9 : 7,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: con!.index == index ? theme.colorScheme.secondary : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: theme.focusColor,
                                    blurRadius: 2,
                                    offset: Offset(1,1)
                                )
                              ]
                          ),
                        );
                      }),
                )
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: IgnorePointer(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        theme.scaffoldBackgroundColor.withOpacity(0.8),
                        theme.scaffoldBackgroundColor.withOpacity(0),
                      ],
                      stops: [0.4, 1,],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        theme.scaffoldBackgroundColor.withOpacity(0),
                        theme.scaffoldBackgroundColor.withOpacity(1),
                      ],
                      stops: [0.3, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
            ),
          ),
        ),
      ],
    );
  }
}
