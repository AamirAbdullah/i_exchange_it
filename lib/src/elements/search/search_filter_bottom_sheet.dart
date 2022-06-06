// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iExchange_it/config/condition_enum.dart';
import 'package:iExchange_it/src/controller/search_controller.dart';
import 'package:iExchange_it/src/models/category.dart';
import 'package:iExchange_it/src/models/child_category.dart';
import 'package:iExchange_it/src/models/choose_location_model.dart';
import 'package:iExchange_it/src/models/sub_category.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../models/attribute.dart';
import '../../models/option.dart';

class SearchFilterBottomSheetWidget extends StatefulWidget {
  final SearchController? con;

  SearchFilterBottomSheetWidget({this.con});

  @override
  _SearchFilterBottomSheetWidgetState createState() =>
      _SearchFilterBottomSheetWidgetState();
}

class _SearchFilterBottomSheetWidgetState
    extends StateMVC<SearchFilterBottomSheetWidget> {
  SearchController? _con;

  _SearchFilterBottomSheetWidgetState() : super(SearchController()) {
    _con = controller as SearchController?;
  }

  @override
  void initState() {
    _con!.categories = widget.con!.categories;
    _con!.subCats = widget.con!.subCats;
    _con!.childCats = widget.con!.childCats;
    _con!.selectedCat = widget.con!.selectedCat;
    _con!.selectedSubCat = widget.con!.selectedSubCat;
    _con!.selectedChildCat = widget.con!.selectedChildCat;
    _con!.catDropdownMenuItems = widget.con!.catDropdownMenuItems;
    _con!.subCatDropdownMenuItems = widget.con!.subCatDropdownMenuItems;
    _con!.childCatDropdownMenuItems = widget.con!.childCatDropdownMenuItems;
    _con!.itemTypeDropdownMenuItems = widget.con!.itemTypeDropdownMenuItems;

    _con!.loc = widget.con!.loc;
    _con!.condition = widget.con!.condition;
    _con!.minPriceController = widget.con!.minPriceController;
    _con!.maxPriceController = widget.con!.maxPriceController;
    _con!.applyFilter = widget.con!.applyFilter;
    _con!.selectedItemType = widget.con!.selectedItemType;
    _con!.selectedCondition = widget.con!.selectedCondition;
    _con!.minPrice = widget.con!.minPrice;
    _con!.maxPrice = widget.con!.maxPrice;

    _con!.attributes = widget.con!.attributes;
    _con!.attrs = widget.con!.attrs;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight + 30),
      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _con!.applyFilter = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.close,
                        size: 22,
                        color: theme.colorScheme.secondary,
                      ),
                      Text(
                        "CLOSE",
                        style: textTheme.caption!
                            .merge(TextStyle(color: theme.colorScheme.secondary)),
                      )
                    ],
                  ),
                ),
                Text(
                  "Filters",
                  style: textTheme.headline4,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _con!.applyFilter = true;
                    });
                    Navigator.of(context).pop(_con);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.check,
                        size: 22,
                        color: theme.colorScheme.secondary,
                      ),
                      Text(
                        "APPLY",
                        style: textTheme.caption!
                            .merge(TextStyle(color: theme.colorScheme.secondary)),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              width: size.width - 20,
              height: 0.5,
              color: theme.focusColor,
              margin: EdgeInsets.symmetric(vertical: 10),
            ),
            Container(
              height: (size.height - statusBarHeight - 30 - 20 - 10 - 27),
              child: SingleChildScrollView(
                  child: Column(
                children: [
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
                            Navigator.of(context)
                                .pushNamed("/ChooseLocation")
                                .then((value) {
                              if (value != null) {
                                var loc = value as ChooseLocationModel;
                                setState(() {
                                  _con!.loc = loc;
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 0.2, color: theme.focusColor)),
                            child: Text(
                              _con!.loc.city ?? "Select city",
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

                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 0.5, color: theme.highlightColor)),
                    child: Column(
                      children: [
                        ///Item Type
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Item Type",
                                style: textTheme.subtitle2!.merge(
                                    TextStyle(color: theme.colorScheme.secondary))),
                            SizedBox(height: 7),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).focusColor,
                                        width: 0.5),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      value: _con!.selectedItemType,
                                      style: textTheme.bodyText1,
                                      hint: Text(
                                        "Item Type",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).focusColor),
                                      ),
                                      items: _con!.itemTypeDropdownMenuItems,
                                      onChanged: (value) {
                                        setState(() {
                                          _con!.selectedItemType = value;
                                        });
                                      }),
                                )),
                          ],
                        ),

                        SizedBox(height: 10),

                        ///Condition
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Condition",
                                  style: textTheme.bodyText1!.merge(
                                      TextStyle(color: theme.focusColor))),
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
                                          activeColor:
                                              Theme.of(context).colorScheme.secondary,
                                          groupValue: _con!.condition,
                                          onChanged: (ConditionEnum? value) {
                                            setState(() {
                                              _con!.condition = value;
                                              _con!.selectedCondition = "new";
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
                                                Theme.of(context).colorScheme.secondary,
                                            groupValue: _con!.condition,
                                            onChanged: (ConditionEnum? value) {
                                              setState(() {
                                                _con!.condition = value;
                                                _con!.selectedCondition =
                                                    "used";
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
                          "Which category you're looking for?",
                          style: textTheme.subtitle2!
                              .merge(TextStyle(color: theme.colorScheme.secondary)),
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
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Category>(
                                  value: _con!.selectedCat,
                                  style: textTheme.bodyText1,
                                  hint: Text(
                                    "Item Category",
                                    style: TextStyle(
                                        color: Theme.of(context).focusColor),
                                  ),
                                  items: _con!.catDropdownMenuItems,
                                  onChanged: (value) {
                                    _con!.onCategorySelected(value);
                                  }),
                            )),

                        SizedBox(height: _con!.subCats.length > 0 ? 10 : 0),

                        ///SubCategory DropDown
                        _con!.subCats.length > 0 &&
                                (_con!.subCats[_con!.subCats.length - 1].name
                                        .toString()
                                        .toLowerCase() !=
                                    "all")
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).focusColor,
                                        width: 0.5),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<SubCategory>(
                                      value: _con!.selectedSubCat,
                                      style: textTheme.bodyText1,
                                      hint: Text(
                                        "SubCategory",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).focusColor),
                                      ),
                                      items: _con!.subCatDropdownMenuItems,
                                      onChanged: (value) {
                                        _con!.onSubCategorySelected(value);
                                      }),
                                ))
                            : SizedBox(height: 0),

                        SizedBox(height: _con!.childCats.length > 0 ? 10 : 0),

                        ///ChildCategory DropDown
                        _con!.childCats.length > 0 &&
                                (_con!.childCats[_con!.childCats.length - 1]
                                        .name
                                        .toString()
                                        .toLowerCase() !=
                                    "all")
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).focusColor,
                                        width: 0.5),
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ChildCategory>(
                                      value: _con!.selectedChildCat,
                                      style: textTheme.bodyText1,
                                      hint: Text(
                                        "Select Category",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).focusColor),
                                      ),
                                      items: _con!.childCatDropdownMenuItems,
                                      onChanged: (value) {
                                        _con!.onChildCategorySelected(value);
                                      }),
                                ))
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
                                        Attribute _attr =
                                            _con!.attributes[index];

                                        return _attr.type == 'select'
                                            ? Container(
                                                width: size.width,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        height: _attr.options !=
                                                                    null &&
                                                                _attr.options!
                                                                        .length >
                                                                    0
                                                            ? 5
                                                            : 0),
                                                    _attr.options != null &&
                                                            _attr.options!
                                                                    .length >
                                                                0
                                                        ? Text(_attr.handler,
                                                            style: textTheme
                                                                .subtitle2)
                                                        : SizedBox(height: 0),
                                                    SizedBox(
                                                        height: _attr.options !=
                                                                    null &&
                                                                _attr.options!
                                                                        .length >
                                                                    0
                                                            ? 3
                                                            : 0),
                                                    _attr.options != null &&
                                                            _attr.options!
                                                                    .length >
                                                                0
                                                        ? Container(
                                                            height: 55,
                                                            width: size.width,
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              primary: false,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount: _attr
                                                                  .options!
                                                                  .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                Option opt =
                                                                    _attr.options![
                                                                        index];

                                                                bool
                                                                    isSelected =
                                                                    _attr.valueToSend ==
                                                                        opt.option;

                                                                return InkWell(
                                                                  onTap: () {
                                                                    SystemChannels
                                                                        .textInput
                                                                        .invokeMethod(
                                                                            'TextInput.hide');
                                                                    _con!.onAttributeOptionSelect(
                                                                        _attr,
                                                                        opt);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            7,
                                                                        vertical:
                                                                            5),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            15),
                                                                    decoration: BoxDecoration(
                                                                        color: isSelected
                                                                            ? theme
                                                                                .colorScheme.secondary
                                                                            : theme
                                                                                .scaffoldBackgroundColor,
                                                                        border: Border.all(
                                                                            width:
                                                                                0.4,
                                                                            color: isSelected
                                                                                ? theme.colorScheme.secondary
                                                                                : theme.focusColor),
                                                                        borderRadius: BorderRadius.circular(5)),
                                                                    child: Center(
                                                                        child: Text(
                                                                            opt.option!
                                                                                .toUpperCase(),
                                                                            style: isSelected
                                                                                ? textTheme.bodyText1
                                                                                : textTheme.bodyText2)),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        : SizedBox(height: 0),
                                                    SizedBox(
                                                        height: _attr.options !=
                                                                    null &&
                                                                _attr.options!
                                                                        .length >
                                                                    0
                                                            ? 5
                                                            : 0),
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 7,
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color:
                                                            theme.focusColor)),
                                                child: TextFormField(
                                                  // focusNode: FocusNode(canRequestFocus: false),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "${_attr.handler} can't be empty"
                                                      : null,
                                                  style: textTheme.bodyText1,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    labelText:
                                                        "${_attr.handler}",
                                                    hintStyle: textTheme
                                                        .bodyText1!
                                                        .merge(TextStyle(
                                                            color: theme
                                                                .hintColor)),
                                                  ),
                                                  onSaved: (value) {
                                                    if (_con!.attrs == null) {
                                                      _con!.attrs =
                                                          <Attribute>[];
                                                    }
                                                    _attr.valueToSend = value;
                                                    _con!.attrs.add(_attr);
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
                          "Price range",
                          style: textTheme.subtitle2!
                              .merge(TextStyle(color: theme.colorScheme.secondary)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                            controller: _con!.minPriceController,
                            keyboardType: TextInputType.number,
                            style: textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Minimum Price",
                              hintStyle: textTheme.bodyText1!
                                  .merge(TextStyle(color: theme.hintColor)),
                            ),
                            onSaved: (value) {
                              _con!.minPrice = value;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
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
                            controller: _con!.maxPriceController,
                            keyboardType: TextInputType.number,
                            style: textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Maximum Price",
                              hintStyle: textTheme.bodyText1!
                                  .merge(TextStyle(color: theme.hintColor)),
                            ),
                            onSaved: (value) {
                              _con!.maxPrice = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10)
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
