import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/categories_controller.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../elements/CircularLoadingWidget.dart';

class ChildCategoriesWidget extends StatefulWidget {

 final RouteArgument? argument;

  ChildCategoriesWidget({this.argument});

  @override
  _ChildCategoriesWidgetState createState() => _ChildCategoriesWidgetState();
}

class _ChildCategoriesWidgetState extends StateMVC<ChildCategoriesWidget> {

  CategoriesController? _con;

  _ChildCategoriesWidgetState() : super(CategoriesController()) {
    _con = controller as CategoriesController?;
  }

  @override
  void initState() {
    _con!.category = widget.argument!.category;
    _con!.categories = widget.argument!.categories;
    _con!.selectedSubCat = widget.argument!.subCategory;
    _con!.title = widget.argument!.subCategory!.name.toString().toUpperCase();
    _con!.getChildCategories();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;


    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_con!.selectedSubCat!.name ?? "", style: textTheme.headline4,),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _con!.childCats!.isEmpty
                ? CircularLoadingWidget(height: 100,)
                : ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: _con!.childCats!.length,
              itemBuilder: (context, i) {
                return InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed("/ShowChildCategoryProducts",
                          arguments: RouteArgument(
                            categories: _con!.categories,
                              category: _con!.category,
                              subCats: _con!.subCats,
                              subCategory: _con!.selectedSubCat,
                              childCats: _con!.childCats,
                              childCategory: _con!.childCats![i])
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: theme.highlightColor, width: 0.5))
                      ),
                      child: Text(_con!.childCats![i].name, style: textTheme.bodyText1,),
                    )
                );
              },
            )

          ],
        ),
      ),
    );
  }
}
