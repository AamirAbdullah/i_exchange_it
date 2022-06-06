
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/bid_controller.dart';
import 'package:iExchange_it/src/elements/product/product_mini_item.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class PlaceBidWidget extends StatefulWidget {
 final RouteArgument? argument;

  PlaceBidWidget({this.argument});

  @override
  _PlaceBidWidgetState createState() => _PlaceBidWidgetState();
}

class _PlaceBidWidgetState extends StateMVC<PlaceBidWidget> {

  BidController? _con;

  _PlaceBidWidgetState() : super(BidController()) {
    _con = controller as BidController?;
  }

  @override
  void initState() {
    _con!.product = widget.argument!.product;
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
        title: Text("Place Bid", style: textTheme.headline6, ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ProductMiniItem(product: _con!.product, onTap: (){},),

                  SizedBox(
                    height: 10,
                  ),
                  Text("Place your Bid", style: textTheme.subtitle1,),

                  SizedBox(
                    height: 10,
                  ),

                  Form(
                    key: _con!.formKey,
                    child: Column(
                      children: [

                        ///Bid PRice
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 7,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 0.5, color: theme.focusColor)
                          ),
                          child: TextFormField(
                            validator: (val) => val!.isEmpty ? "Price can't be empty" : null,
                            keyboardType: TextInputType.number,
                            style: textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Bid Price",
                              hintStyle: textTheme.bodyText1!
                                  .merge(TextStyle(color: theme.hintColor)),
                            ),
                            onSaved: (value) {
                              _con!.bid.price = value;
                            },
                          ),
                        ),

                        ///Bid Comment
                        Container(
                          constraints: BoxConstraints(
                            minHeight: 100,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 7,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 0.5, color: theme.focusColor)
                          ),
                          child: TextFormField(
                            validator: (val) => val!.isEmpty ? "Comment can't be empty" : null,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.top,
                            minLines: 1,
                            maxLines: null,
                            style: textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Your comment or message",
                              hintStyle: textTheme.bodyText1!
                                  .merge(TextStyle(color: theme.hintColor)),
                            ),
                            onSaved: (value) {
                              _con!.bid.message = value;
                            },
                          ),
                        ),

                      ],
                    ),
                  ),

                  MaterialButton(
                    onPressed: (){
                      _con!.placeBid();
                    },
                    color: theme.colorScheme.secondary,
                    child: Container(
                      width: size.width,
                      child: Center(
                        child: Text("Place bid", style: textTheme.subtitle1,),
                      ),
                    ),
                  )
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
              : Positioned(bottom: 10, child: SizedBox(height: 0)),

        ],
      ),
    );
  }
}
