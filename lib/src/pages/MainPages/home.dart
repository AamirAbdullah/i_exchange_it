import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/home_controller.dart';

import 'package:iExchange_it/src/elements/appbar_gradient.dart';
import 'package:iExchange_it/src/elements/categories_list_grid.dart';
import 'package:iExchange_it/src/elements/featured_list_carousel_slider.dart';
import 'package:iExchange_it/src/elements/home_image_slider.dart';
import 'package:iExchange_it/src/elements/home_section_header.dart';
import 'package:iExchange_it/src/elements/product/FollowedProductsCaroselSlider.dart';
import 'package:iExchange_it/src/elements/recent_items_grid.dart';

import 'package:iExchange_it/src/elements/shimmer/product_shimmer_list.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/config/app_config.dart' as config;

class Home extends StatefulWidget {

  Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends StateMVC<Home>
    with AutomaticKeepAliveClientMixin   {

  HomeController? _con;
  ScrollController? scrollController;

  HomeState() : super(HomeController()) {
    _con = controller as HomeController?;
  }

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
    _con!.getFeaturedProducts();
    _con!.getPopularProducts();
    _con!.getRecentProducts();
    _con!.getFollowedUsersProducts();
    _con!.getCategories();
    _con!.getBanners();
  }

  scrollToTop() {
    scrollController!.animateTo(
        scrollController!.position.minScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease);
  }


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    

    return Scaffold(
      key: _con!.scaffoldKey,
      body: RefreshIndicator(
        onRefresh: _con!.onRefresh,
        key: _con!.refreshIndicatorKey,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: this.scrollController,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.padding.top + 58.5)),
                  /// Call var imageSlider
                  _con!.myBanners.isNotEmpty
                      ? HomeImageSlider(con: _con,)
                      : SizedBox(height: 0),

                  CategoriesListGrid(con: _con,),
                  SizedBox(height: 20,),

                  _con!.featuredProducts.isEmpty
                      ? SizedBox(height: 0,)
                      : HomeSectionHeader(icon: Icons.stars,text: "Featured", color: config.Colors().featuredColor(1),
                    textColor: Colors.black, onSeeAll: (){
                      Navigator.of(context).pushNamed("/ShowProductsList", arguments: RouteArgument(showRecent: false, showFeatured: true));
                      },),

                  _con!.isLoadingFeatured
                      ? ProductShimmerList()
                      : _con!.featuredProducts.isEmpty
                      ? SizedBox(height: 0,)
                      : FeaturedListCarouselSlider(con: _con,),

                  _con!.popularProducts.isEmpty
                      ? SizedBox(height: 0,)
                      : HomeSectionHeader(icon: Icons.stars,text: "Popular", color: config.Colors().topColor(1),
                    textColor: Colors.black, onSeeAll: (){
                      Navigator.of(context).pushNamed("/ShowProductsList", arguments: RouteArgument(showRecent: false, showPopular: true));
                    },),

                  _con!.isLoadingPopular
                      ? ProductShimmerList()
                      : _con!.popularProducts.isEmpty
                      ? SizedBox(height: 0,)
                      : FeaturedListCarouselSlider(con: _con,),

                  _con!.followingsProducts.isEmpty
                      ? SizedBox(height: 0,)
                      : HomeSectionHeader(icon: Icons.watch_later, text: "Products you follow", color: config.Colors().recentColor(1),
                    textColor: Colors.black, onSeeAll: (){
                      Navigator.of(context).pushNamed("/ShowProductsList", arguments: RouteArgument(showProductsByFollow: true, showRecent: false));
                    },),
                  _con!.followingsProducts.isEmpty
                      ? SizedBox(height: 0,)
                      : FollowedProductsCarouselSlider(con: _con,),

                  _con!.recentProducts.isEmpty
                      ? SizedBox(height: 0,)
                      : HomeSectionHeader(icon: Icons.watch_later, text: "Recent", color: config.Colors().recentColor(1),
                    textColor: Colors.black, onSeeAll: (){
                        Navigator.of(context).pushNamed("/ShowProductsList", arguments: RouteArgument(showRecent: true));
                    },),
                  _con!.recentProducts.isEmpty
                      ? SizedBox(height: 0,)
                      : RecentItemsGrid(con: _con,),


                ],
              ),
            ),

            /// Get a class AppbarGradient
            /// This is a Appbar in home activity
            AppbarGradient(onTap: (){ Navigator.of(context).pushNamed("/SearchPage"); },),
          ],
        ),
      ),
    );
  }
}