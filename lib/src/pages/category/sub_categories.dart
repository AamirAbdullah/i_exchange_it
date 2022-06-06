import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/categories_controller.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../elements/CircularLoadingWidget.dart';

class SubcategoriesWidget extends StatefulWidget {

 final RouteArgument? argument;

  SubcategoriesWidget({this.argument});

  @override
  _SubcategoriesWidgetState createState() => _SubcategoriesWidgetState();
}

class _SubcategoriesWidgetState extends StateMVC<SubcategoriesWidget> {

  CategoriesController? _con;

  _SubcategoriesWidgetState() : super(CategoriesController()) {
    _con = controller as CategoriesController?;
  }

  @override
  void initState() {
    _con!.category = widget.argument!.category;
    _con!.categories = widget.argument!.categories;
    _con!.title = widget.argument!.category!.name.toString().toUpperCase();
    _con!.getSubCategories();
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
        title: Text(_con!.category!.name ?? "", style: textTheme.headline4,),
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

            _con!.subCats!.isEmpty
            ? CircularLoadingWidget(height: 100,)
                : ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: _con!.subCats!.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed("/ShowChildcategories",
                        arguments: RouteArgument(subCategory: _con!.subCats![i],
                          categories: _con!.categories,
                          category: _con!.category
                        ));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: theme.highlightColor, width: 0.5))
                      ),
                      child: Text(_con!.subCats![i].name, style: textTheme.bodyText1,),
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
