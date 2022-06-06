import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:iExchange_it/src/controller/review_controller.dart';

import 'package:iExchange_it/src/elements/CircularLoadingWidget.dart';
import 'package:iExchange_it/src/elements/product/product_mini_item.dart';
import 'package:iExchange_it/src/elements/product/review_item.dart';
import 'package:iExchange_it/src/models/review.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class ListReviewsWidget extends StatefulWidget {
 final RouteArgument? argument;

  ListReviewsWidget({this.argument});

  @override
  _ListReviewsWidgetState createState() => _ListReviewsWidgetState();
}

class _ListReviewsWidgetState extends StateMVC<ListReviewsWidget> {

  ReviewController? _con;

  _ListReviewsWidgetState() : super(ReviewController()) {
    _con = controller as ReviewController?;
  }

  @override
  void initState() {
    _con!.product = widget.argument!.product;
    _con!.isEditingReview = widget.argument!.isEditingReview;
    _con!.getProductReviews();
    userRepo.getCurrentUser().then((value) {
      _con!.currentUser = value;
      if(value.id.toString() == _con!.product!.userId.toString()) {
        _con!.isMine = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("All Reviews", style: textTheme.headline6, ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: theme.colorScheme.secondary),
          onPressed: (){
            if(!_con!.isLoading) {
              Navigator.of(context).pop();
            }
          },
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  ProductMiniItem(product: _con!.product, onTap: (){},),

                  SizedBox(height: 15),

                  ListTile(
                    leading: Icon(CupertinoIcons.location_solid, color: Colors.white, size: 20,),
                    title: Text("Leave Review", style: textTheme.subtitle1,),
                    subtitle: Text("Leave your feedback about Ad", style: textTheme.caption,),
                    trailing: Icon(_con!.isEditingReview ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
                      size: _con!.isEditingReview ? 22 : 15, color: theme.focusColor,),
                    onTap: (){
                      setState((){
                        _con!.isEditingReview = !_con!.isEditingReview;
                      });
                    },
                    selectedTileColor: theme.focusColor.withOpacity(0.2),
                    selected: _con!.isEditingReview,
                  ),

                  _con!.isEditingReview
                      ? Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Leave your review", style: textTheme.subtitle1!.merge(TextStyle(color: theme.colorScheme.secondary)),),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _con!.reviewTextController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            labelText: "Your Comment or review",
                            labelStyle: TextStyle(color: theme.colorScheme.secondary),
                            contentPadding: EdgeInsets.all(12),
                            prefixIcon: Icon(Icons.feedback, color: Colors.white, size: 20,),
                            prefixIconConstraints: BoxConstraints(maxWidth: 100, minWidth: 50),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                            children: [
                              Spacer(),
                              MaterialButton(
                                onPressed: (){
                                  setState((){
                                    _con!.isEditingReview = false;
                                  });
                                },
                                color: theme.focusColor,
                                child: Text("Cancel", style: textTheme.subtitle2,),
                              ),
                              SizedBox(width: 10,),
                              MaterialButton(
                                onPressed: (){
                                  _con!.postReview();
                                },
                                color: theme.colorScheme.secondary,
                                child: Text("Submit", style: textTheme.subtitle2!.merge(TextStyle(color: Colors.white)),),
                              ),
                            ]
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  )
                      : SizedBox(height: 0),


                  SizedBox(height: 15),


                  _con!.reviews.isEmpty
                      ? CircularLoadingWidget(height: 100)
                      : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con!.reviews.length,
                    itemBuilder: (context, index) {

                      Review review = _con!.reviews[index];

                      bool isVisible = review.status == "1" || review.status == 1 || review.status == true;

                      return isVisible || _con!.isMine
                          ? ReviewItemWidget(
                        review: review,
                        onStatusChange: (){
                          _con!.changeReviewStatus(review);
                        },
                        showAction: _con!.isMine,
                      )
                          : SizedBox(height: 0, width: 0);

                      // return ReviewItemWidget(review: review,);

                    },
                  ),

                ],
              ),
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
              : Positioned(bottom: 0, child: SizedBox(height: 0)),
        ],
      ),
    );
  }
}
