import 'package:flutter/material.dart';
import 'package:iExchange_it/src/models/product.dart';
import 'package:iExchange_it/src/models/review.dart';
import 'package:iExchange_it/src/models/user.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/review_repository.dart' as repo;

class ReviewController extends ControllerMVC {

  Product? product;
  User? currentUser;
  GlobalKey<ScaffoldState>? scaffoldKey;
  List<Review> reviews = <Review>[];
  Review? review;
  bool isMine = false;

  bool isEditingReview = false;
  TextEditingController? reviewTextController;

  bool isLoading = false;

  ReviewController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    reviewTextController = TextEditingController();
  }

  getProductReviews() async {
    Stream<Review> stream = await repo.getReviewsOfProduct(product!.id.toString());
    stream.listen((_review) {
      setState((){
        this.reviews.add(_review);
      });
    },
        onError: (e){
          print(e);
        },
        onDone: (){
        });
  }

  postReview() async {
    if(reviewTextController!.text.length > 1) {
      setState((){
        this.isLoading = true;
      });
      Review _review = Review();
      _review.comment = reviewTextController!.text.toString();
      _review.productId = this.product!.id.toString();
      repo.createReview(_review).then((value) {
        if(value != null) {
          setState(() {
            reviewTextController!.text = "";
            isEditingReview = false;
            this.reviews.add(value);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showToast("Error posting review");
        }
      },
          onError: (e){
        print(e);
        setState((){
          this.isLoading = false;
        });
        // ignore: deprecated_member_use
        // scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Verify your internet connection")));
      });
    }
    else {
      showToast("Review comment can't be empty");
    }
  }


  changeReviewStatus(Review _review) async {
    setState((){this.isLoading = true;});
    repo.changeReviewStatus(_review).then((value) {
      setState((){this.isLoading = false;});
      if (value != null) {
        for(int i = 0; i<this.reviews.length; i++) {
          if(this.reviews[i].id.toString() == value.id.toString()) {
            setState((){
              this.reviews[i] = value;
            });
          }
        }
      } else {
        // ignore: deprecated_member_use
        // scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Some Error Occurred, Try later please")));
      }
    }, onError: (e) {
      setState((){this.isLoading = false;});
      print(e);
      // ignore: deprecated_member_use
      // scaffoldKey!.currentState!.showSnackBar(SnackBar(content: Text("Verify your internet connection")));
    });
  }

}
