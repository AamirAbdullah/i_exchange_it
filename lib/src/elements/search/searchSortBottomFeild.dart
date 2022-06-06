import 'package:flutter/material.dart';

import 'package:iExchange_it/src/controller/search_controller.dart';

class SearchSortBottomSheet extends StatefulWidget {
  final SearchController? con;
  const SearchSortBottomSheet({Key? key, this.con}) : super(key: key);

  @override
  State<SearchSortBottomSheet> createState() => _SearchSortBottomSheetState();
}

class _SearchSortBottomSheetState extends State<SearchSortBottomSheet> {
  SearchController? _con;
  // @override
  // void initState() {
  //   _con!.categories = widget.con!.categories;
  //   _con!.subCats = widget.con!.subCats;
  //   _con!.childCats = widget.con!.childCats;
  //   _con!.selectedCat = widget.con!.selectedCat;
  //   _con!.selectedSubCat = widget.con!.selectedSubCat;
  //   _con!.selectedChildCat = widget.con!.selectedChildCat;
  //   _con!.catDropdownMenuItems = widget.con!.catDropdownMenuItems;
  //   _con!.subCatDropdownMenuItems = widget.con!.subCatDropdownMenuItems;
  //   _con!.childCatDropdownMenuItems = widget.con!.childCatDropdownMenuItems;
  //   _con!.itemTypeDropdownMenuItems = widget.con!.itemTypeDropdownMenuItems;

  //   _con!.loc = widget.con!.loc;
  //   _con!.condition = widget.con!.condition;
  //   _con!.minPriceController = widget.con!.minPriceController;
  //   _con!.maxPriceController = widget.con!.maxPriceController;
  //   _con!.applyFilter = widget.con!.applyFilter;
  //   _con!.selectedItemType = widget.con!.selectedItemType;
  //   _con!.selectedCondition = widget.con!.selectedCondition;
  //   _con!.minPrice = widget.con!.minPrice;
  //   _con!.maxPrice = widget.con!.maxPrice;

  //   _con!.attributes = widget.con!.attributes;
  //   _con!.attrs = widget.con!.attrs;

  //   super.initState();
  // }

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
                        style: textTheme.caption!.merge(
                            TextStyle(color: theme.colorScheme.secondary)),
                      )
                    ],
                  ),
                ),
                Text(
                  "Sort",
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
                        style: textTheme.caption!.merge(
                            TextStyle(color: theme.colorScheme.secondary)),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Default',
                            style: textTheme.headline4!.merge(
                                TextStyle(color: theme.colorScheme.secondary)),
                          ),
                          Icon(Icons.check)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width - 20,
                    height: 0.5,
                    color: theme.focusColor,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Newest to Oldest',
                            style: textTheme.headline4!.merge(
                                TextStyle(color: theme.colorScheme.secondary)),
                          ),
                          Icon(Icons.check)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width - 20,
                    height: 0.5,
                    color: theme.focusColor,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Oldest to Newest',
                            style: textTheme.headline4!.merge(
                                TextStyle(color: theme.colorScheme.secondary)),
                          ),
                          Icon(Icons.check)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width - 20,
                    height: 0.5,
                    color: theme.focusColor,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price Highest to Lowest',
                            style: textTheme.headline4!.merge(
                                TextStyle(color: theme.colorScheme.secondary)),
                          ),
                          Icon(Icons.check)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width - 20,
                    height: 0.5,
                    color: theme.focusColor,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price Lowest to highest',
                            style: textTheme.headline4!.merge(
                                TextStyle(color: theme.colorScheme.secondary)),
                          ),
                          Icon(Icons.check)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width - 20,
                    height: 0.5,
                    color: theme.focusColor,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
