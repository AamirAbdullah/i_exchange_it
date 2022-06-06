// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iExchange_it/config/condition_enum.dart';
import 'package:iExchange_it/src/controller/add_product_controller.dart';

import 'package:iExchange_it/src/models/attribute.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/choose_location_model.dart';
import 'package:iExchange_it/src/models/option.dart';
import 'package:iExchange_it/src/models/sub_category.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/config/strings.dart';

class PlaceAnAd extends StatefulWidget {
  @override
  _PlaceAnAdState createState() => _PlaceAnAdState();
}

class _PlaceAnAdState extends StateMVC<PlaceAnAd> {
  AddProductController? _con;

  _PlaceAnAdState() : super(AddProductController()) {
    _con = controller as AddProductController?;
  }

  @override
  void initState() {
    _con!.getCurrentUser();
    _con!.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return !_con!.isLoading;
      },
      child: Scaffold(
        key: _con!.scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Place an Ad",
            style: textTheme.headline6,
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: theme.colorScheme.secondary),
            onPressed: () {
              if (!_con!.isLoading) {
                Navigator.of(context).pop();
              }
            },
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _con!.newProd.mediaList != null &&
                          _con!.newProd.mediaList!.length > 0
                      ? Container(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Images",
                                      style: textTheme.subtitle1!.merge(
                                          TextStyle(
                                              color:
                                                  theme.colorScheme.secondary)),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            _con!.newProd.mediaList!.clear();
                                            _con!.images!.clear();
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("clear",
                                              style: textTheme.subtitle2),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount:
                                      _con!.newProd.mediaList!.length + 1,
                                  itemBuilder: (context, indx) {
                                    return indx !=
                                            _con!.newProd.mediaList!.length
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 1),
                                            width: 150,
                                            child: Image.file(
                                              File(_con!.newProd
                                                  .mediaList![indx].identifier),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              _con!.getGalleryImages();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 1),
                                              width: 150,
                                              color: theme.focusColor
                                                  .withOpacity(0.5),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  size: 32,
                                                  color: theme.focusColor,
                                                ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _con!.getCameraImage();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(0.2),
                                  height: 150,
                                  color: theme.focusColor.withOpacity(0.3),
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.camera_fill,
                                      color: theme.focusColor,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _con!.getGalleryImages();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(0.2),
                                  height: 150,
                                  color: theme.focusColor.withOpacity(0.3),
                                  child: Center(
                                    child: Icon(
                                      Icons.photo,
                                      color: theme.focusColor,
                                      size: 34,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 10),
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
                                border: Border.all(
                                    width: 0.5, color: theme.highlightColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Item details",
                                  style: textTheme.subtitle2!.merge(TextStyle(
                                      color: theme.colorScheme.secondary)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                ///Name or Title
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(
                                          width: 0.5, color: theme.focusColor)),
                                  child: TextFormField(
                                    // focusNode: FocusNode(canRequestFocus: false),
                                    keyboardType: TextInputType.text,
                                    validator: (value) => value!.isEmpty
                                        ? "Name can't be empty"
                                        : null,
                                    style: textTheme.bodyText1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Name or Ad Title",
                                      hintStyle: textTheme.bodyText1!.merge(
                                          TextStyle(color: theme.hintColor)),
                                    ),
                                    onSaved: (value) {
                                      _con!.newProd.name = value;
                                    },
                                  ),
                                ),

                                ///Description
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight: 100,
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 0.5, color: theme.focusColor)),
                                  child: TextFormField(
                                    // focusNode: FocusNode(canRequestFocus: false),
                                    keyboardType: TextInputType.multiline,
                                    textAlignVertical: TextAlignVertical.top,
                                    minLines: 1,
                                    maxLines: null,
                                    validator: (value) => value!.isEmpty
                                        ? "Details can't be empty"
                                        : null,
                                    style: textTheme.bodyText1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText:
                                          "Details about what you are uploading",
                                      hintStyle: textTheme.bodyText1!.merge(
                                          TextStyle(color: theme.hintColor)),
                                    ),
                                    onSaved: (value) {
                                      _con!.newProd.description = value;
                                    },
                                  ),
                                ),

                                ///Phone
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 0.5, color: theme.focusColor)),
                                  child: TextFormField(
                                    // focusNode: FocusNode(canRequestFocus: false),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty
                                        ? "Phone can't be empty"
                                        : null,
                                    style: textTheme.bodyText1,
                                    initialValue: _con!.currentUser.phone,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Phone number",
                                      hintStyle: textTheme.bodyText1!.merge(
                                          TextStyle(color: theme.hintColor)),
                                    ),
                                    onSaved: (value) {
                                      _con!.newProd.phone = value;
                                    },
                                  ),
                                ),

                                ///Item Type
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context).focusColor,
                                            width: 0.5),
                                        borderRadius: BorderRadius.circular(5)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                          value: _con!.newProd.type,
                                          style: textTheme.bodyText1,
                                          hint: Text(
                                            "Item Type",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .focusColor),
                                          ),
                                          items:
                                              _con!.itemTypeDropdownMenuItems,
                                          onTap: () {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                          },
                                          onChanged: (value) {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
                                            setState(() {
                                              _con!.newProd.type = value;
                                            });
                                          }),
                                    )),

                                ///Price
                                _con!.newProd.type == SALE ||
                                        _con!.newProd.type == EXCHANGE
                                    ? Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 7,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 0.5,
                                                color: theme.focusColor)),
                                        child: TextFormField(
                                          // focusNode: FocusNode(canRequestFocus: false),
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          validator: (value) =>
                                              ((_con!.newProd.type == SALE ||
                                                          _con!.newProd.type ==
                                                              EXCHANGE) &&
                                                      value!.isEmpty)
                                                  ? "Price can't be empty"
                                                  : null,
                                          style: textTheme.bodyText1,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Price",
                                            hintStyle: textTheme.bodyText1!
                                                .merge(TextStyle(
                                                    color: theme.hintColor)),
                                          ),
                                          onSaved: (value) {
                                            _con!.newProd.price = value;
                                          },
                                        ),
                                      )
                                    : SizedBox(height: 0),

                                ///Condition
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Condition",
                                          style: textTheme.bodyText1!.merge(
                                              TextStyle(
                                                  color: theme.focusColor))),
                                      SizedBox(height: 7),
                                      Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: ConditionEnum
                                                      .newCondition,
                                                  activeColor: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  groupValue: _con!.condition,
                                                  onChanged:
                                                      (ConditionEnum? value) {
                                                    SystemChannels.textInput
                                                        .invokeMethod(
                                                            'TextInput.hide');
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            new FocusNode());
                                                    setState(() {
                                                      _con!.condition = value;
                                                      _con!.newProd.condition =
                                                          "new";
                                                    });
                                                  },
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "New",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                              width: 120,
                                              height: 20,
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: ConditionEnum.used,
                                                    activeColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    groupValue: _con!.condition,
                                                    onChanged:
                                                        (ConditionEnum? value) {
                                                      SystemChannels.textInput
                                                          .invokeMethod(
                                                              'TextInput.hide');
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              new FocusNode());
                                                      setState(() {
                                                        _con!.condition = value;
                                                        _con!.newProd
                                                            .condition = "used";
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Used",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1,
                                                  ),
                                                ],
                                              )),
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
                                border: Border.all(
                                    width: 0.5, color: theme.highlightColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Which category this item belongs to?",
                                  style: textTheme.subtitle2!.merge(TextStyle(
                                      color: theme.colorScheme.secondary)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                ///Category DropDown
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context).focusColor,
                                            width: 0.5),
                                        borderRadius: BorderRadius.circular(5)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<Category>(
                                          value: _con!.selectedCat,
                                          style: textTheme.bodyText1,
                                          hint: Text(
                                            "Item Category",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .focusColor),
                                          ),
                                          items: _con!.catDropdownMenuItems,
                                          onTap: () {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                          },
                                          onChanged: (value) {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
                                            _con!.onCategorySelected(value);
                                          }),
                                    )),

                                SizedBox(
                                    height: _con!.subCats.length > 0 ? 10 : 0),

                                ///SubCategory DropDown
                                _con!.subCats.length > 0 &&
                                        (_con!.subCats[_con!.subCats.length - 1]
                                                .name
                                                .toString()
                                                .toLowerCase() !=
                                            "all")
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .focusColor,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<SubCategory>(
                                              value: _con!.selectedSubCat,
                                              style: textTheme.bodyText1,
                                              hint: Text(
                                                "SubCategory",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .focusColor),
                                              ),
                                              items:
                                                  _con!.subCatDropdownMenuItems,
                                              onTap: () {
                                                SystemChannels.textInput
                                                    .invokeMethod(
                                                        'TextInput.hide');
                                              },
                                              onChanged: (value) {
                                                SystemChannels.textInput
                                                    .invokeMethod(
                                                        'TextInput.hide');
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                _con!.onSubCategorySelected(
                                                    value);
                                              }),
                                        ))
                                    : SizedBox(height: 0),

                                SizedBox(
                                    height:
                                        _con!.childCats.length > 0 ? 10 : 0),

                                ///ChildCategory DropDown
                                _con!.childCats.length > 0 &&
                                        (_con!
                                                .childCats[
                                                    _con!.childCats.length - 1]
                                                .name
                                                .toString()
                                                .toLowerCase() !=
                                            "all")
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .focusColor,
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<ChildCategory>(
                                              value: _con!.selectedChildCat,
                                              style: textTheme.bodyText1,
                                              hint: Text(
                                                "Select Category",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .focusColor),
                                              ),
                                              items: _con!
                                                  .childCatDropdownMenuItems,
                                              onTap: () {
                                                SystemChannels.textInput
                                                    .invokeMethod(
                                                        'TextInput.hide');
                                              },
                                              onChanged: (value) {
                                                SystemChannels.textInput
                                                    .invokeMethod(
                                                        'TextInput.hide');
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                _con!.onChildCategorySelected(
                                                    value);
                                              }),
                                        ))
                                    : SizedBox(height: 0),

                                SizedBox(
                                    height:
                                        _con!.attributes.length > 0 ? 10 : 0),
                                _con!.attributes.length > 0
                                    ? Container(
                                        child: Column(
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount:
                                                  _con!.attributes.length,
                                              itemBuilder: (context, index) {
                                                Attribute _attr =
                                                    _con!.attributes[index];

                                                return _attr.type == 'select'
                                                    ? Container(
                                                        width: size.width,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                height: _attr.options !=
                                                                            null &&
                                                                        _attr.options!.length >
                                                                            0
                                                                    ? 5
                                                                    : 0),
                                                            _attr.options !=
                                                                        null &&
                                                                    _attr.options!
                                                                            .length >
                                                                        0
                                                                ? Text(
                                                                    _attr
                                                                        .handler,
                                                                    style: textTheme
                                                                        .subtitle2)
                                                                : SizedBox(
                                                                    height: 0),
                                                            SizedBox(
                                                                height: _attr.options !=
                                                                            null &&
                                                                        _attr.options!.length >
                                                                            0
                                                                    ? 3
                                                                    : 0),
                                                            _attr.options !=
                                                                        null &&
                                                                    _attr.options!
                                                                            .length >
                                                                        0
                                                                ? Container(
                                                                    height: 55,
                                                                    width: size
                                                                        .width,
                                                                    child: ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      primary:
                                                                          false,
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      itemCount: _attr
                                                                          .options!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        Option
                                                                            opt =
                                                                            _attr.options![index];

                                                                        bool
                                                                            isSelected =
                                                                            _attr.valueToSend ==
                                                                                opt.option;

                                                                        return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                                            _con!.onAttributeOptionSelect(_attr,
                                                                                opt);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 15),
                                                                            decoration: BoxDecoration(
                                                                                color: isSelected ? theme.colorScheme.secondary : theme.scaffoldBackgroundColor,
                                                                                border: Border.all(width: 0.4, color: isSelected ? theme.colorScheme.secondary : theme.focusColor),
                                                                                borderRadius: BorderRadius.circular(5)),
                                                                            child:
                                                                                Center(child: Text(opt.option!.toUpperCase(), style: isSelected ? textTheme.bodyText1 : textTheme.bodyText2)),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                : SizedBox(
                                                                    height: 0),
                                                            SizedBox(
                                                                height: _attr.options !=
                                                                            null &&
                                                                        _attr.options!.length >
                                                                            0
                                                                    ? 5
                                                                    : 0),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 7,
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                width: 0.5,
                                                                color: theme
                                                                    .focusColor)),
                                                        child: TextFormField(
                                                          // focusNode: FocusNode(canRequestFocus: false),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          validator: (value) =>
                                                              value!.isEmpty
                                                                  ? "${_attr.handler} can't be empty"
                                                                  : null,
                                                          style: textTheme
                                                              .bodyText1,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            labelText:
                                                                "${_attr.handler}",
                                                            hintStyle: textTheme
                                                                .bodyText1!
                                                                .merge(TextStyle(
                                                                    color: theme
                                                                        .hintColor)),
                                                          ),
                                                          onSaved: (value) {
                                                            if (_con!.newProd
                                                                    .attrs ==
                                                                null) {
                                                              _con!.newProd
                                                                      .attrs =
                                                                  <Attribute>[];
                                                            }
                                                            _attr.valueToSend =
                                                                value;
                                                            _con!.newProd.attrs
                                                                .add(_attr);
                                                          },
                                                        ),
                                                      );
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),

                          ///Video
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 0.5, color: theme.focusColor)),
                            child: TextFormField(
                              // focusNode: FocusNode(canRequestFocus: false),
                              keyboardType: TextInputType.text,
                              style: textTheme.bodyText1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Video Link",
                                hintText: "Link to video (if any)",
                                hintStyle: textTheme.bodyText1!
                                    .merge(TextStyle(color: theme.hintColor)),
                              ),
                              onSaved: (value) {
                                _con!.newProd.video = value;
                              },
                            ),
                          ),

                          SizedBox(height: 10),

                          ///Wish Item's Attributes
                          _con!.newProd.type == EXCHANGE
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all(8.0),
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          width: 0.5,
                                          color: theme.highlightColor)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Wish to Change with Item",
                                        style: textTheme.subtitle2!.merge(
                                            TextStyle(
                                                color: theme.colorScheme.secondary)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 7,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 0.5,
                                                color: theme.focusColor)),
                                        child: TextFormField(
                                          // focusNode: FocusNode(canRequestFocus: false),
                                          keyboardType: TextInputType.text,
                                          validator: (value) =>
                                              _con!.newProd.type == EXCHANGE &&
                                                      value!.isEmpty
                                                  ? "Keyword can't be empty"
                                                  : null,
                                          style: textTheme.bodyText1,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: "Keyword",
                                            hintText: "Item with keyword..",
                                            hintStyle: textTheme.bodyText1!
                                                .merge(TextStyle(
                                                    color: theme.hintColor)),
                                          ),
                                          onSaved: (value) {
                                            _con!.newProd.keyword = value;
                                          },
                                        ),
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      ///Condition
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Condition",
                                                style: textTheme.bodyText1!
                                                    .merge(TextStyle(
                                                        color:
                                                            theme.focusColor))),
                                            SizedBox(height: 7),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 120,
                                                  height: 20,
                                                  child: Row(
                                                    children: [
                                                      Radio(
                                                        value: ConditionEnum
                                                            .newCondition,
                                                        activeColor:
                                                            Theme.of(context)
                                                                .colorScheme.secondary,
                                                        groupValue:
                                                            _con!.wishCondition,
                                                        onChanged:
                                                            (ConditionEnum?
                                                                value) {
                                                          SystemChannels
                                                              .textInput
                                                              .invokeMethod(
                                                                  'TextInput.hide');
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  new FocusNode());
                                                          setState(() {
                                                            _con!.wishCondition =
                                                                value;
                                                            _con!.newProd
                                                                    .wishCondition =
                                                                "new";
                                                          });
                                                        },
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "New",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    width: 120,
                                                    height: 20,
                                                    child: Row(
                                                      children: [
                                                        Radio(
                                                          value: ConditionEnum
                                                              .used,
                                                          activeColor:
                                                              Theme.of(context)
                                                                  .colorScheme.secondary,
                                                          groupValue: _con!
                                                              .wishCondition,
                                                          onChanged:
                                                              (ConditionEnum?
                                                                  value) {
                                                            SystemChannels
                                                                .textInput
                                                                .invokeMethod(
                                                                    'TextInput.hide');
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    new FocusNode());
                                                            setState(() {
                                                              _con!.wishCondition =
                                                                  value;
                                                              _con!.newProd
                                                                      .wishCondition =
                                                                  "used";
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "Used",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 10),

                                      ///Category Selection

                                      Text(
                                        "Which category should the wish item belongs to?",
                                        style: textTheme.subtitle2!.merge(
                                            TextStyle(
                                                color: theme.colorScheme.secondary)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      ///Category DropDown
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .focusColor,
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<Category>(
                                                value: _con!.wishSelectedCat,
                                                style: textTheme.bodyText1,
                                                hint: Text(
                                                  "Item Category",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .focusColor),
                                                ),
                                                items: _con!
                                                    .wishCatDropdownMenuItems,
                                                onTap: () {
                                                  SystemChannels.textInput
                                                      .invokeMethod(
                                                          'TextInput.hide');
                                                },
                                                onChanged: (value) {
                                                  SystemChannels.textInput
                                                      .invokeMethod(
                                                          'TextInput.hide');
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                  _con!.onWishCategorySelected(
                                                      value);
                                                }),
                                          )),

                                      SizedBox(
                                          height: _con!.wishSubCats.length > 0
                                              ? 10
                                              : 0),

                                      ///SubCategory DropDown
                                      _con!.wishSubCats.length > 0 &&
                                              (_con!
                                                      .wishSubCats[_con!
                                                              .wishSubCats
                                                              .length -
                                                          1]
                                                      .name
                                                      .toString()
                                                      .toLowerCase() !=
                                                  "all")
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .focusColor,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<
                                                        SubCategory>(
                                                    value: _con!
                                                        .wishSelectedSubCat,
                                                    style: textTheme.bodyText1,
                                                    hint: Text(
                                                      "SubCategory",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .focusColor),
                                                    ),
                                                    items: _con!
                                                        .wishSubCatDropdownMenuItems,
                                                    onTap: () {
                                                      SystemChannels.textInput
                                                          .invokeMethod(
                                                              'TextInput.hide');
                                                    },
                                                    onChanged: (value) {
                                                      SystemChannels.textInput
                                                          .invokeMethod(
                                                              'TextInput.hide');
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              new FocusNode());
                                                      _con!
                                                          .onWishSubCategorySelected(
                                                              value);
                                                    }),
                                              ))
                                          : SizedBox(height: 0),

                                      SizedBox(
                                          height: _con!.wishChildCats.length > 0
                                              ? 10
                                              : 0),

                                      ///ChildCategory DropDown
                                      _con!.wishChildCats.length > 0 &&
                                              (_con!
                                                      .wishChildCats[_con!
                                                              .wishChildCats
                                                              .length -
                                                          1]
                                                      .name
                                                      .toString()
                                                      .toLowerCase() !=
                                                  "all")
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .focusColor,
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<
                                                        ChildCategory>(
                                                    value: _con!
                                                        .wishSelectedChildCat,
                                                    style: textTheme.bodyText1,
                                                    hint: Text(
                                                      "Select Category",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .focusColor),
                                                    ),
                                                    items: _con!
                                                        .wishChildCatDropdownMenuItems,
                                                    onTap: () {
                                                      SystemChannels.textInput
                                                          .invokeMethod(
                                                              'TextInput.hide');
                                                    },
                                                    onChanged: (value) {
                                                      SystemChannels.textInput
                                                          .invokeMethod(
                                                              'TextInput.hide');
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              new FocusNode());
                                                      _con!
                                                          .onWishChildCategorySelected(
                                                              value);
                                                    }),
                                              ))
                                          : SizedBox(height: 0),

                                      SizedBox(
                                          height:
                                              _con!.wishAttributes.length > 0
                                                  ? 10
                                                  : 0),
                                      _con!.wishAttributes.length > 0
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: _con!
                                                        .wishAttributes.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Attribute _attr =
                                                          _con!.wishAttributes[
                                                              index];

                                                      return _attr.type ==
                                                              'select'
                                                          ? Container(
                                                              width: size.width,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                      height: _attr.options != null &&
                                                                              _attr.options!.length > 0
                                                                          ? 5
                                                                          : 0),
                                                                  _attr.options !=
                                                                              null &&
                                                                          _attr.options!.length >
                                                                              0
                                                                      ? Text(
                                                                          _attr
                                                                              .handler,
                                                                          style: textTheme
                                                                              .subtitle2)
                                                                      : SizedBox(
                                                                          height:
                                                                              0),
                                                                  SizedBox(
                                                                      height: _attr.options != null &&
                                                                              _attr.options!.length > 0
                                                                          ? 3
                                                                          : 0),
                                                                  _attr.options !=
                                                                              null &&
                                                                          _attr.options!.length >
                                                                              0
                                                                      ? Container(
                                                                          height:
                                                                              55,
                                                                          width:
                                                                              size.width,
                                                                          child:
                                                                              ListView.builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            primary:
                                                                                false,
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            itemCount:
                                                                                _attr.options!.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              Option opt = _attr.options![index];

                                                                              bool isSelected = _attr.valueToSend == opt.option;

                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                                  _con!.onWishAttributeOptionSelect(_attr, opt);
                                                                                },
                                                                                child: Container(
                                                                                  margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                                                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                                                                  decoration: BoxDecoration(color: isSelected ? theme.colorScheme.secondary : theme.scaffoldBackgroundColor, border: Border.all(width: 0.4, color: isSelected ? theme.colorScheme.secondary : theme.focusColor), borderRadius: BorderRadius.circular(5)),
                                                                                  child: Center(child: Text(opt.option!.toUpperCase(), style: isSelected ? textTheme.bodyText1 : textTheme.bodyText2)),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        )
                                                                      : SizedBox(
                                                                          height:
                                                                              0),
                                                                  SizedBox(
                                                                      height: _attr.options != null &&
                                                                              _attr.options!.length > 0
                                                                          ? 5
                                                                          : 0),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 7,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  border: Border.all(
                                                                      width:
                                                                          0.5,
                                                                      color: theme
                                                                          .focusColor)),
                                                              child:
                                                                  TextFormField(
                                                                // focusNode: FocusNode(canRequestFocus: false),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                validator: (value) => _con!.newProd.type ==
                                                                            EXCHANGE &&
                                                                        value!
                                                                            .isEmpty
                                                                    ? "${_attr.handler} can't be empty"
                                                                    : null,
                                                                style: textTheme
                                                                    .bodyText1,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  labelText:
                                                                      "${_attr.handler}",
                                                                  hintStyle: textTheme
                                                                      .bodyText1!
                                                                      .merge(TextStyle(
                                                                          color:
                                                                              theme.hintColor)),
                                                                ),
                                                                onSaved:
                                                                    (value) {
                                                                  if (_con!
                                                                          .newProd
                                                                          .attrs ==
                                                                      null) {
                                                                    _con!.newProd
                                                                            .wishAttrs =
                                                                        <Attribute>[];
                                                                  }
                                                                  _attr.valueToSend =
                                                                      value;
                                                                  _con!.newProd
                                                                      .wishAttrs
                                                                      .add(
                                                                          _attr);
                                                                },
                                                              ),
                                                            );
                                                    },
                                                  )
                                                ],
                                              ),
                                            )
                                          : SizedBox(
                                              height: 0,
                                            ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Text(
                                        "Wish Item Location",
                                        style: textTheme.subtitle2!.merge(
                                            TextStyle(
                                                color: theme.colorScheme.secondary)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      ///Country
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 80,
                                              child: Text(
                                                "City: ",
                                                style: textTheme.subtitle2,
                                              )),
                                          SizedBox(width: 7),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                SystemChannels.textInput
                                                    .invokeMethod(
                                                        'TextInput.hide');
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                Navigator.of(context)
                                                    .pushNamed(
                                                        "/ChooseLocation")
                                                    .then((value) {
                                                  if (value != null) {
                                                    var loc = value
                                                        as ChooseLocationModel;
                                                    setState(() {
                                                      _con!.newProd
                                                              .wishLocation =
                                                          loc.city;
                                                    });
                                                  }
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 12),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color:
                                                            theme.focusColor)),
                                                child: Text(
                                                  _con!.newProd.wishLocation ??
                                                      "Select desired City",
                                                  style: textTheme.bodyText1,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 80,
                                              child: Text(
                                                "Distance Range around the location: (KMs)",
                                                style: textTheme.subtitle2!
                                                    .merge(TextStyle(
                                                        fontSize: 12)),
                                              )),
                                          SizedBox(width: 7),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: theme.focusColor)),
                                              child: TextFormField(
                                                // focusNode: FocusNode(canRequestFocus: false),
                                                keyboardType:
                                                    TextInputType.number,
                                                style: textTheme.bodyText1,
                                                validator: (value) => _con!
                                                                .newProd.type ==
                                                            EXCHANGE &&
                                                        value!.isEmpty
                                                    ? "Distance Range can't be empty"
                                                    : null,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText:
                                                      "Distance Range (in KMs)",
                                                  hintText:
                                                      "Distance Range (in KMs)",
                                                  hintStyle: textTheme
                                                      .bodyText1!
                                                      .merge(TextStyle(
                                                          color:
                                                              theme.hintColor)),
                                                ),
                                                onSaved: (value) {
                                                  _con!.newProd.range = value;
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 7,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: theme.focusColor)),
                                              child: TextFormField(
                                                // focusNode: FocusNode(canRequestFocus: false),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) => _con!
                                                                .newProd.type ==
                                                            EXCHANGE &&
                                                        value!.isEmpty
                                                    ? "Min Price can't be empty"
                                                    : null,
                                                style: textTheme.bodyText1,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Min. Price",
                                                  hintStyle: textTheme
                                                      .bodyText1!
                                                      .merge(TextStyle(
                                                          color:
                                                              theme.hintColor)),
                                                ),
                                                onSaved: (value) {
                                                  _con!.newProd.minPrice =
                                                      value;
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 7,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: theme.focusColor)),
                                              child: TextFormField(
                                                // focusNode: FocusNode(canRequestFocus: false),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) => _con!
                                                                .newProd.type ==
                                                            EXCHANGE &&
                                                        value!.isEmpty
                                                    ? "Max Price can't be empty"
                                                    : null,
                                                style: textTheme.bodyText1,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText: "Max. Price",
                                                  hintStyle: textTheme
                                                      .bodyText1!
                                                      .merge(TextStyle(
                                                          color:
                                                              theme.hintColor)),
                                                ),
                                                onSaved: (value) {
                                                  _con!.newProd.maxPrice =
                                                      value;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ))
                              : SizedBox(height: 0, width: 0),

                          ///Address
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 7, vertical: 10),
                            width: size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 0.5, color: theme.highlightColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Address information",
                                  style: textTheme.subtitle2!.merge(
                                      TextStyle(color: theme.colorScheme.secondary)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                ///Country
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 80,
                                        child: Text(
                                          "Country: ",
                                          style: textTheme.subtitle2,
                                        )),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());

                                          Navigator.of(context)
                                              .pushNamed("/ChooseLocation")
                                              .then((value) {
                                            if (value != null) {
                                              var loc =
                                                  value as ChooseLocationModel;
                                              setState(() {
                                                _con!.newProd.country =
                                                    loc.country;
                                                _con!.newProd.city = loc.city;
                                                _con!.newProd.location =
                                                    '${loc.lat}, ${loc.long}';
                                                _con!.newProd.lat = loc.lat;
                                                _con!.newProd.long = loc.long;
                                                _con!.addressController!.text =
                                                    loc.address;
                                              });
                                            }
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 12),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: theme.focusColor)),
                                          child: Text(
                                            _con!.newProd.country ??
                                                "Select your country",
                                            style: textTheme.bodyText1,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                ///City
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 80,
                                        child: Text(
                                          "City: ",
                                          style: textTheme.subtitle2,
                                        )),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());

                                          Navigator.of(context)
                                              .pushNamed("/ChooseLocation")
                                              .then((value) {
                                            if (value != null) {
                                              var loc =
                                                  value as ChooseLocationModel;
                                              setState(() {
                                                _con!.newProd.country =
                                                    loc.country;
                                                _con!.newProd.city = loc.city;
                                                _con!.newProd.location =
                                                    '${loc.lat}, ${loc.long}';
                                                _con!.newProd.lat = loc.lat;
                                                _con!.newProd.long = loc.long;
                                                _con!.addressController!.text =
                                                    loc.address;
                                              });
                                            }
                                          });
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 12),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: theme.focusColor)),
                                          child: Text(
                                            _con!.newProd.city ?? "Select city",
                                            style: textTheme.bodyText1,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                ///Address
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 80,
                                        child: Text(
                                          "Address: ",
                                          style: textTheme.subtitle2,
                                        )),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Container(
                                        constraints:
                                            BoxConstraints(minHeight: 100),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 0.2,
                                                color: theme.focusColor)),
                                        child: TextFormField(
                                          // focusNode: FocusNode(canRequestFocus: false),
                                          controller: _con!.addressController,
                                          keyboardType: TextInputType.multiline,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          minLines: 1,
                                          maxLines: null,
                                          validator: (value) => value!.isEmpty
                                              ? "Address can't be empty"
                                              : null,
                                          style: textTheme.bodyText1,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Your Address",
                                            hintStyle: textTheme.bodyText1!
                                                .merge(TextStyle(
                                                    color: theme.hintColor)),
                                          ),
                                          onSaved: (value) {
                                            _con!.newProd.address = value;
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                ///Postal Code
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 80,
                                        child: Text(
                                          "Postal Code: ",
                                          style: textTheme.subtitle2,
                                        )),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 0.2,
                                                color: theme.focusColor)),
                                        child: TextFormField(
                                          // focusNode: FocusNode(canRequestFocus: false),
                                          keyboardType: TextInputType.number,
                                          validator: (value) => value!.isEmpty
                                              ? "Postal Code can't be empty"
                                              : null,
                                          style: textTheme.bodyText1,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Postal Code",
                                            hintStyle: textTheme.bodyText1!
                                                .merge(TextStyle(
                                                    color: theme.hintColor)),
                                          ),
                                          onSaved: (value) {
                                            _con!.newProd.postalCode = value;
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),

                          ///Bidding
                          ListTile(
                            onTap: () {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              setState(() {
                                _con!.isBidding = !_con!.isBidding!;
                              });
                            },
                            leading: Checkbox(
                              value: _con!.isBidding,
                              activeColor: theme.colorScheme.secondary,
                              onChanged: (isTrue) {
                                setState(() {
                                  _con!.isBidding = isTrue;
                                  _con!.newProd.bidding = isTrue! ? 1 : 0;
                                });
                              },
                            ),
                            title: Text(
                              "Open for bidding",
                              style: textTheme.subtitle2,
                            ),
                          ),

                          _con!.isBidding!
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 100,
                                        child: Text(
                                          "Bidding should ends on: ",
                                          style: textTheme.subtitle2,
                                        )),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());

                                          final DateTime? picked =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: (_con!.newProd
                                                                  .biddingEnd !=
                                                              null &&
                                                          _con!
                                                                  .newProd
                                                                  .biddingEnd
                                                                  .length >
                                                              0)
                                                      ? DateFormat("dd-MM-yyyy")
                                                          .parse(_con!.newProd
                                                              .biddingEnd)
                                                      : DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2101));

                                          if (picked != null &&
                                              picked !=
                                                  _con!.newProd.biddingEnd) {
                                            final f =
                                                new DateFormat('dd-MM-yyyy');
                                            setState(() {
                                              _con!.newProd.biddingEnd =
                                                  f.format(picked).toString();
                                            });
                                          }
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 14),
                                          width: size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: theme.focusColor)),
                                          child: Text(
                                            _con!.newProd.biddingEnd ??
                                                "Select Date",
                                            style: textTheme.bodyText1,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox(height: 0, width: 0),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                   
                    child: MaterialButton(
                      onPressed: () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        FocusScope.of(context).requestFocus(new FocusNode());

                        _con!.uploadProduct();
                      },
                      color: theme.colorScheme.secondary,
                      splashColor: theme.focusColor.withOpacity(0.1),
                      child: Container(
                          height: 50,
                          width: size.width,
                          child: Center(
                            child: Text(
                              "SUBMIT",
                              style: textTheme.subtitle1,
                            ),
                          )),
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
      ),
    );
  }
}
