
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/category2.dart';


class SearchDesign extends StatefulWidget {
  final CategorySearch? categorySearch;
  const SearchDesign({Key? key,this.categorySearch}) : super(key: key);
  @override
  State<SearchDesign> createState() => _SearchDesignState();
}
class _SearchDesignState extends State<SearchDesign> {
  List<String> image=[];
  @override
  void initState() {
    // images();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    
    
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         //  CarouselSlider.builder(
         // options: CarouselOptions(height: 250,),
         //    itemCount: image.length,
         //    itemBuilder: (context,index,realIndex){
         //   final urlImage=image[index];
         //   return buildImage(urlImage,index);
         //    },
         //  ),
          SizedBox(height: 10,),
          Text(
            'Pkr ' + widget.categorySearch!.price.toString(),
            style: textTheme.caption!.merge(
              TextStyle(color: theme.colorScheme.secondary, fontSize: 18),
            ),
          ),

          Text(
            widget.categorySearch!.name.toString(),
            style: textTheme.caption!.merge(
              TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
            ),
          ),
          Text('description',
            style: textTheme.caption!.merge(
              TextStyle(color: Colors.white, fontSize: 16),
            ),),

          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on),
              Text(widget.categorySearch!.country.toString()+' >'+'city')
            ],
          )

        ],
      ),
    );
  }
  // void images(){
  //   for(var i=0;i<=widget.categorySearch!.images!.length;i++)
  //   {
  //     image=widget.categorySearch!.images![i].path;
  //     print(image);
  //   }
  // }
  Widget buildImage(String urlImage,index)=>Container(
    margin: EdgeInsets.symmetric(horizontal: 12),
    color: Colors.grey,
    child: Image.network(urlImage,fit: BoxFit.cover,),
  );
}