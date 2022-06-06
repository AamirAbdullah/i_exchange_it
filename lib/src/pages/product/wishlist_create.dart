// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iExchange_it/config/condition_enum.dart';
import 'package:iExchange_it/config/strings.dart';
import 'package:iExchange_it/src/controller/wishlist_controller.dart';
import 'package:iExchange_it/src/models/attribute.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/choose_location_model.dart';
import 'package:iExchange_it/src/models/option.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:iExchange_it/src/models/sub_category.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class WishListItemCreateWidget extends StatefulWidget {
 final RouteArgument? argument;

  WishListItemCreateWidget({this.argument});

  @override
  _WishListItemCreateWidgetState createState() => _WishListItemCreateWidgetState();
}

class _WishListItemCreateWidgetState extends StateMVC<WishListItemCreateWidget> {

  WishlistController? _con;

  _WishListItemCreateWidgetState() : super(WishlistController()) {
    _con = controller as WishlistController?;
  }

  @override
  void initState() {
    _con!.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Create Wishlist Item", style: textTheme.headline6, ),
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          // setState((){_con.isLoading = false;});
          Navigator.of(context).pop();
          },
          icon: Icon(CupertinoIcons.back),),
        elevation: 0,
      ),
      body: Stack(
        children: [

          SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text("Create a wishlist item and get notified when a similar item is available.",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyText2,),
                ),

                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _con!.formKey,
                    child: Column(
                      children: [

                        ///Details About Item
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 0.5, color: theme.highlightColor)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text("Item details", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
                              SizedBox(height: 10,),


                              ///Name or Keyword
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(horizontal: 7,),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(width: 0.5, color: theme.focusColor)
                                ),
                                child: TextFormField(
                                  // focusNode: FocusNode(canRequestFocus: false),
                                  keyboardType: TextInputType.text,
                                  validator: (value) => value!.isEmpty ? "Keyword can't be empty" : null,
                                  style: textTheme.bodyText1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Item Keyword",
                                    hintStyle: textTheme.bodyText1!
                                        .merge(TextStyle(color: theme.hintColor)),
                                  ),
                                  onSaved: (value) {
                                    _con!.item.keyword = value;
                                  },
                                ),
                              ),


                              ///Item Type
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).focusColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        value: _con!.item.type,
                                        style: textTheme.bodyText1,
                                        hint: Text("Item Type", style: TextStyle(color: Theme.of(context).focusColor),),
                                        items: _con!.itemTypeDropdownMenuItems,
                                        onTap: (){
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                        },
                                        onChanged: (value) {
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          FocusScope.of(context).unfocus();
                                          setState((){
                                            _con!.item.type = value;
                                          });
                                        }
                                    ),
                                  )
                              ),

                              ///Price
                              _con!.item.type == SALE || _con!.item.type == EXCHANGE
                                  ? Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(horizontal: 7,),
                                decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 0.5, color: theme.focusColor)
                                ),
                                child: TextFormField(
                                  // focusNode: FocusNode(canRequestFocus: false),
                                        keyboardType: TextInputType.number,
                                        validator: (value) => ((_con!.item.type == SALE || _con!.item.type == EXCHANGE)&& value!.isEmpty) ? "Min Price can't be empty" : null,
                                        style: textTheme.bodyText1,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: "Min. Price",
                                          hintStyle: textTheme.bodyText1!
                                              .merge(TextStyle(color: theme.hintColor)),
                                        ),
                                        onSaved: (value) {
                                          _con!.item.minPrice = value;
                                        },
                                ),
                              ),
                                      ),

                                      SizedBox(width: 5),

                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.symmetric(horizontal: 7,),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(width: 0.5, color: theme.focusColor)
                                          ),
                                          child: TextFormField(
                                            // focusNode: FocusNode(canRequestFocus: false),
                                            keyboardType: TextInputType.number,
                                            validator: (value) => (_con!.item.type == SALE && value!.isEmpty) ? "Max Price can't be empty" : null,
                                            style: textTheme.bodyText1,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: "Max. Price",
                                              hintStyle: textTheme.bodyText1!
                                                  .merge(TextStyle(color: theme.hintColor)),
                                            ),
                                            onSaved: (value) {
                                              _con!.item.maxPrice = value;
                                            },
                                          ),
                                        ),
                                      ),

                                    ],
                                  )
                                  : SizedBox(height: 0),

                              ///Condition
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Condition", style: textTheme.bodyText1!.merge(TextStyle(color: theme.focusColor))),
                                    SizedBox(height: 7),
                                    Row(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 20,
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: ConditionEnum.newCondition,
                                                activeColor: Theme.of(context).colorScheme.secondary,
                                                groupValue: _con!.condition,
                                                onChanged: (ConditionEnum? value) {
                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                  setState(() {
                                                    _con!.condition = value;
                                                    _con!.item.condition = "new";
                                                  });
                                                },
                                              ),
                                              SizedBox(width: 10),
                                              Text("New", style: Theme.of(context).textTheme.bodyText1,)
                                            ],
                                          ),
                                        ),
                                        Container(
                                            width: 120,
                                            height: 20,
                                            child:Row(
                                              children: [
                                                Radio(
                                                  value: ConditionEnum.used,
                                                  activeColor: Theme.of(context).colorScheme.secondary,
                                                  groupValue: _con!.condition,
                                                  onChanged: (ConditionEnum? value) {
                                                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                    FocusScope.of(context).requestFocus(new FocusNode());
                                                    setState(() {
                                                      _con!.condition = value;
                                                      _con!.item.condition = "used";
                                                    });
                                                  },
                                                ),
                                                SizedBox(width: 10),
                                                Text("Used", style: Theme.of(context).textTheme.bodyText1,),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 10),
                        ///Category Selection
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 0.5, color: theme.highlightColor)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text("Which category should that item belongs to?", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
                              SizedBox(height: 10,),

                              ///Category DropDown
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).focusColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<Category>(
                                        value: _con!.selectedCat,
                                        style: textTheme.bodyText1,
                                        hint: Text("Item Category", style: TextStyle(color: Theme.of(context).focusColor),),
                                        items: _con!.catDropdownMenuItems,
                                        onTap: (){
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          },
                                        onChanged: (value) {
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          _con!.onCategorySelected(value);
                                        }
                                    ),
                                  )
                              ),

                              SizedBox(height: _con!.subCats.length > 0 ? 10 : 0),

                              ///SubCategory DropDown
                              _con!.subCats.length > 0 && (_con!.subCats[_con!.subCats.length-1].name.toString().toLowerCase() != "all")
                                  ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).focusColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<SubCategory>(
                                        value: _con!.selectedSubCat,
                                        style: textTheme.bodyText1,
                                        hint: Text("SubCategory", style: TextStyle(color: Theme.of(context).focusColor),),
                                        items: _con!.subCatDropdownMenuItems,
                                        onTap: (){
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                        },
                                        onChanged: (value) {
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          _con!.onSubCategorySelected(value);
                                        }
                                    ),
                                  )
                              )
                                  : SizedBox(height: 0),

                              SizedBox(height: _con!.childCats.length > 0 ? 10 : 0),
                              ///ChildCategory DropDown
                              _con!.childCats.length > 0 && (_con!.childCats[_con!.childCats.length-1].name.toString().toLowerCase() != "all")
                                  ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).focusColor, width: 0.5),
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<ChildCategory>(
                                        value: _con!.selectedChildCat,
                                        style: textTheme.bodyText1,
                                        hint: Text("Select Category", style: TextStyle(color: Theme.of(context).focusColor),),
                                        items: _con!.childCatDropdownMenuItems,
                                        onTap: (){
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                        },
                                        onChanged: (value) {
                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                          FocusScope.of(context).requestFocus(new FocusNode());
                                          _con!.onChildCategorySelected(value);
                                        }
                                    ),
                                  )
                              )
                                  : SizedBox(height: 0),


                              SizedBox(height: _con!.attributes.length > 0 ? 10 : 0),
                              _con!.attributes.length > 0
                                  ? Container(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: _con!.attributes.length,
                                            itemBuilder: (context, index) {
                                              Attribute _attr = _con!.attributes[index];

                                              return _attr.type == 'select'
                                                  ? Container(
                                                      width: size.width,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                              height: _attr.options != null && _attr.options!.length > 0 ? 5 : 0),
                                                          _attr.options != null && _attr.options!.length > 0
                                                              ? Text(_attr.handler, style: textTheme.subtitle2)
                                                              : SizedBox(height: 0),
                                                          SizedBox(
                                                              height: _attr.options != null && _attr.options!.length > 0
                                                                  ? 3
                                                                  : 0),
                                                          _attr.options != null && _attr.options!.length > 0
                                                              ? Container(
                                                                  height: 55,
                                                                  width: size.width,
                                                                  child: ListView.builder(
                                                                    shrinkWrap: true,
                                                                    primary: false,
                                                                    scrollDirection: Axis.horizontal,
                                                                    itemCount: _attr.options!.length,
                                                                    itemBuilder: (context, index) {
                                                                      Option opt = _attr.options![index];

                                                                      bool isSelected = _attr.valueToSend == opt.option;

                                                                      return InkWell(
                                                                        onTap: () {
                                                                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                                          FocusScope.of(context).requestFocus(new FocusNode());
                                                                          _con!.onAttributeOptionSelect(_attr, opt);
                                                                        },
                                                                        child: Container(
                                                                          margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                                                          decoration: BoxDecoration(
                                                                              color: isSelected ? theme.colorScheme.secondary : theme.scaffoldBackgroundColor,
                                                                              border: Border.all(width: 0.4, color: isSelected ? theme.colorScheme.secondary : theme.focusColor),
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child: Center(child: Text(opt.option!.toUpperCase(), style: isSelected ? textTheme.bodyText1 : textTheme.bodyText2)),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                )
                                                              : SizedBox(height: 0),
                                                          SizedBox(height: _attr.options != null && _attr.options!.length > 0
                                                                  ? 5
                                                                  : 0),
                                                        ],
                                                      ),
                                                    )
                                                  : _attr.type == 'input'
                                                  ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${_attr.handler} Range',
                                                          style: textTheme.subtitle2,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                                padding: EdgeInsets.symmetric(horizontal: 7,),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(width: 0.5, color: theme.focusColor)),
                                                                child: TextFormField(
                                                                  // focusNode: FocusNode(canRequestFocus: false),
                                                                  keyboardType: TextInputType.text,
                                                                  validator: (value) => value!.isEmpty ? "${_attr.handler} can't be empty" : null,
                                                                  style: textTheme.bodyText1,
                                                                  decoration: InputDecoration(
                                                                    border: InputBorder.none,
                                                                    labelText: "From",
                                                                    hintStyle: textTheme.bodyText1!.merge(TextStyle(color: theme.hintColor)),
                                                                  ),
                                                                  onSaved: (value) {
                                                                   
                                                                    if (_con!.item.attrs == null) {
                                                                      _con!.item.attrs = <Attribute>[];
                                                                    }
                                                                    _attr.valueToSend = value;
                                                                    _con!.item.attrs.add(_attr);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 7),
                                                            Flexible(
                                                              child: Container(
                                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                                padding: EdgeInsets.symmetric(horizontal: 7,),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    border: Border.all(width: 0.5, color: theme.focusColor)),
                                                                child: TextFormField(
                                                                  // focusNode: FocusNode(canRequestFocus: false),
                                                                  keyboardType: TextInputType.text,
                                                                  validator: (value) => value!.isEmpty ? "${_attr.handler} can't be empty" : null,
                                                                  style: textTheme.bodyText1,
                                                                  decoration: InputDecoration(
                                                                    border: InputBorder.none,
                                                                    labelText: "To",
                                                                    hintStyle: textTheme.bodyText1!.merge(TextStyle(color: theme.hintColor)),
                                                                  ),
                                                                  onSaved: (value) {
                                                                    if (_con!.item.attrs == null) {
                                                                      _con!.item.attrs = <Attribute>[];
                                                                    }
                                                                    _attr.valueToSend2 = value;
                                                                    _con!.item.attrs.add(_attr);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                              : Container(
                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                padding: EdgeInsets.symmetric(horizontal: 7,),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 0.5, color: theme.focusColor)),
                                                child: TextFormField(
                                                  // focusNode: FocusNode(canRequestFocus: false),
                                                  keyboardType: TextInputType.text,
                                                  validator: (value) => value!.isEmpty ? "${_attr.handler} can't be empty" : null,
                                                  style: textTheme.bodyText1,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    labelText: "${_attr.handler}",
                                                    hintStyle: textTheme.bodyText1!.merge(TextStyle(color: theme.hintColor)),
                                                  ),
                                                  onSaved: (value) {
                                                    if (_con!.item.attrs == null) {
                                                      _con!.item.attrs = <Attribute>[];
                                                    }
                                                    _attr.valueToSend = value;
                                                    _con!.item.attrs.add(_attr);
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                ),
                              )
                                  : SizedBox(height: 0,),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),
                        ///Address
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 0.5, color: theme.highlightColor)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Location information", style: textTheme.subtitle2!.merge(TextStyle(color: theme.colorScheme.secondary)),),
                              SizedBox(height: 10,),

                              ///Country
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(width: 80, child: Text("City: ", style: textTheme.subtitle2,)),
                                  SizedBox(width: 7),

                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                                        FocusScope.of(context).requestFocus(new FocusNode());

                                        Navigator.of(context).pushNamed("/ChooseLocation").then((value) {
                                          if(value != null) {
                                            var loc = value as ChooseLocationModel;
                                            setState((){
                                              _con!.item.location = loc.city;
                                              _con!.item.latitude = loc.lat;
                                              _con!.item.longitude = loc.long;
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(width: 0.2, color: theme.focusColor)
                                        ),
                                        child: Text(
                                          _con!.item.location ?? "Select desired City",
                                          style: textTheme.bodyText1,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),

                              ///Range
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(width: 80, child: Text("Distance Range around the location: (KMs)", style: textTheme.subtitle2,)),
                                  SizedBox(width: 7),

                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.symmetric(horizontal: 10,),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 0.2, color: theme.focusColor)
                                      ),
                                      child: TextFormField(
                                        // focusNode: FocusNode(canRequestFocus: false),
                                        keyboardType: TextInputType.number,
                                        validator: (value) => value!.isEmpty ? "Distance Range can't be empty" : null,
                                        style: textTheme.bodyText1,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Distance Range (in KMs)",
                                          hintStyle: textTheme.bodyText1!
                                              .merge(TextStyle(color: theme.hintColor)),
                                        ),
                                        onSaved: (value) {
                                          _con!.item.range = value;
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),


                              ///Postal Code
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(width: 80, child: Text("Postal Code: ", style: textTheme.subtitle2,)),
                                  SizedBox(width: 7),

                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.symmetric(horizontal: 10,),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 0.2, color: theme.focusColor)
                                      ),
                                      child: TextFormField(
                                        // focusNode: FocusNode(canRequestFocus: false),
                                        keyboardType: TextInputType.number,
                                        validator: (value) => value!.isEmpty ? "Postal Code can't be empty" : null,
                                        style: textTheme.bodyText1,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Postal Code",
                                          hintStyle: textTheme.bodyText1!
                                              .merge(TextStyle(color: theme.hintColor)),
                                        ),
                                        onSaved: (value) {
                                          _con!.item.postCode = value;
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),

                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: MaterialButton(
                    onPressed: (){
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      FocusScope.of(context).requestFocus(new FocusNode());

                      _con!.createWishList();
                    },
                    color: theme.colorScheme.secondary,
                    splashColor: theme.focusColor.withOpacity(0.1),
                    child: Container(
                        height: 50,
                        width: size.width,
                        child: Center(
                          child: Text("ADD TO WISHLIST", style: textTheme.subtitle1,),
                        )
                    ),
                  ),
                )

              ],
            ),
          ),

          ///Loader
          _con!.isLoading
              ? Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Please wait...",
                        style: Theme.of(context).textTheme.bodyText2)
                  ],
                ),
              ),
            ),
          )
              : Positioned(bottom: 10, child: SizedBox(height: 0)),

        ],
      ),
    );
  }
}
