// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/controller.dart';
import 'package:iExchange_it/src/pages/MainPages/account.dart';
import 'package:iExchange_it/src/pages/MainPages/chats.dart';
import 'package:iExchange_it/src/pages/MainPages/home.dart';
import 'package:iExchange_it/src/pages/MainPages/notifications.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class PagesWidget extends StatefulWidget {
  int? currentTab;
  // Widget currentPage = OrdersWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key? key,
    this.currentTab,
  }) {
    currentTab = currentTab != null ? currentTab : 0;
  }

  @override
  _PagesWidgetState createState() => _PagesWidgetState();
}

class _PagesWidgetState extends StateMVC<PagesWidget> {
  PageController? _pageController;
  int currentIndex = 0;
  final List<Widget> _pages = [];
  Controller? _con;

  GlobalKey<HomeState>? homeKey;

  _PagesWidgetState() : super(Controller()) {
    _con = controller as Controller?;
  }

  @override
  initState() {
    homeKey = GlobalKey<HomeState>();
    super.initState();
    userRepo.getCurrentUser().then((user) {
      setState(() {
        _con!.currentUser = user;
        _con!.initFCM();
      });
    });
    _pageController = PageController();
    setState(() {
      _pages.add(Home(
        key: homeKey,
      ));
      _pages.add(MyNotifications());
      _pages.add(MyChats());
      _pages.add(MyAccount());
    });
    Future.delayed(Duration.zero, () {
      _selectPage(widget.currentTab!);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      widget.currentTab = index;
    });
  }

  void _selectPage(int index) {
    setState(() {
      widget.currentTab = index;
    });
    _pageController!.jumpToPage(index);
    if (index == 0) {
      homeKey!.currentState!.scrollToTop();
    }
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).primaryColor,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .merge(TextStyle(color: Theme.of(context).focusColor)))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: (widget.currentTab! > 1)
                ? widget.currentTab! + 1
                : widget.currentTab!,
            fixedColor: Theme.of(context).colorScheme.secondary,
            onTap: (index) {
              if (index != 2) {
                int pgNo = index;
                if (index > 2) {
                  pgNo--;
                }
                _selectPage(pgNo);
              } else {
                Navigator.of(context).pushNamed("/PlaceAd");
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bell),
                label: "Notifications",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.add_circled_solid,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                label: "Place an Ad",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.conversation_bubble),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.person,
                ),
                label: "Account",
              ),
            ],
          )),
    );
  }
}
