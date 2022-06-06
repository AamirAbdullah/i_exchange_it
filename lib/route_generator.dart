import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:iExchange_it/src/pages/Login/choose_login_or_signup.dart';
import 'package:iExchange_it/src/pages/Login/login.dart';
import 'package:iExchange_it/src/pages/Login/signup.dart';
import 'package:iExchange_it/src/pages/Login/splash_screen.dart';
import 'package:iExchange_it/src/pages/MainPages/place_ad.dart';
import 'package:iExchange_it/src/pages/bid/bids_received.dart';
import 'package:iExchange_it/src/pages/bid/my_bids.dart';
import 'package:iExchange_it/src/pages/bid/place_bid.dart';
import 'package:iExchange_it/src/pages/category/child_categories.dart';
import 'package:iExchange_it/src/pages/category/items_by_child_category.dart';
import 'package:iExchange_it/src/pages/category/sub_categories.dart';
import 'package:iExchange_it/src/pages/location/choose_location.dart';
import 'package:iExchange_it/src/pages/others/about.dart';
import 'package:iExchange_it/src/pages/others/create_question.dart';
import 'package:iExchange_it/src/pages/others/help_and_support.dart';
import 'package:iExchange_it/src/pages/others/qna_list.dart';
import 'package:iExchange_it/src/pages/others/safety_rules.dart';
import 'package:iExchange_it/src/pages/others/terms.dart';
import 'package:iExchange_it/src/pages/pages.dart';
import 'package:iExchange_it/src/pages/product/create_review.dart';
import 'package:iExchange_it/src/pages/product/edit_product.dart';
import 'package:iExchange_it/src/pages/product/my_proucts.dart';
import 'package:iExchange_it/src/pages/product/my_wishlist.dart';
import 'package:iExchange_it/src/pages/product/reviews_list.dart';
import 'package:iExchange_it/src/pages/product/view_favorites.dart';
import 'package:iExchange_it/src/pages/product/view_item_widget.dart';
import 'package:iExchange_it/src/pages/chat/user_chat.dart';
import 'package:iExchange_it/src/pages/product/view_products_list.dart';
import 'package:iExchange_it/src/pages/product/wishlist_create.dart';
import 'package:iExchange_it/src/pages/products_list.dart';
import 'package:iExchange_it/src/pages/profile/user_profile.dart';
import 'package:iExchange_it/src/pages/profile/view_profile.dart';
import 'package:iExchange_it/src/pages/search/search.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch(settings.name)
    {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/ChooseLogin':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ChooseLoginOrSignup(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });
      case '/Login':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });
      case "/Signup":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => Signup(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });
      case "/Pages":
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args as int?));
      case "/ItemDetails":
        return MaterialPageRoute(builder: (_) => ViewItemDetails(args: args as RouteArgument?));
      case "/UserChat":
        return MaterialPageRoute(builder: (_) => UserChatWidget(argument: args as RouteArgument?));
      case "/PlaceAd":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => PlaceAnAd(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });
      case "/ViewProfile":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ViewProfile(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/ProductListByCategory":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ProductListWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/ChooseLocation":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ChooseLocationWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/SearchPage":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => SearchWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/MyProducts":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => MyProductsWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/EditProduct":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => EditProductWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/CreateWishlist":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => WishListItemCreateWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/Favorites":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => FavoritesListWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/PlaceBid":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => PlaceBidWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/OffersSubmitted":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => MyBidsWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/OffersReceived":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => BidsReceivedWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/MyWishlist":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => MyWishlistWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/SeeReviews":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ListReviewsWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/CreateReview":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => CreateReviewWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/UserProfile":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => UserProfileWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/TermsOfUse":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => TermsOfUserWidget(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/About":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => AboutWidget(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });


      case "/ShowProductsList":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ViewProductsListWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/QnAList":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => QnAListWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/CreateQuestion":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => CreateQuestionWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/ShowSubcategories":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => SubcategoriesWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });


      case "/ShowChildcategories":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ChildCategoriesWidget(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/ShowChildCategoryProducts":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ItemsByChildCategory(argument: args as RouteArgument?),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/HelpAndSupport":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => HelpAndSupportWidget(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

      case "/PrivacyPolicy":
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => SafetyRulesWidget(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            });

    }
    return null;
  }
}