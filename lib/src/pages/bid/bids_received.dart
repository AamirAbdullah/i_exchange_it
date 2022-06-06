import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/bid_controller.dart';
import 'package:iExchange_it/src/elements/CircularLoadingWidget.dart';
import 'package:iExchange_it/src/elements/bid/bid_item.dart';
import 'package:iExchange_it/src/models/bid.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

///Offers Received
class BidsReceivedWidget extends StatefulWidget {
  final RouteArgument? argument;

  BidsReceivedWidget({this.argument});

  @override
  _BidsReceivedWidgetState createState() => _BidsReceivedWidgetState();
}

class _BidsReceivedWidgetState extends StateMVC<BidsReceivedWidget> {
  BidController? _con;

  _BidsReceivedWidgetState() : super(BidController()) {
    _con = controller as BidController?;
  }

  @override
  void initState() {
    _con!.getCurrentUser();
    _con!.getBidsReceived();
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
        title: Text(
          "Offers Received",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _con!.isLoading
                ? CircularLoadingWidget(
                    height: 100,
                  )
                : _con!.bids.isEmpty
                    ? Container(
                        height: size.height,
                        width: size.width,
                        child: Center(
                          child: Text(
                            "Nothing to show",
                            style: textTheme.bodyText2,
                          ),
                        ),
                      )
                    : ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: _con!.bids.length,
                        itemBuilder: (context, index) {
                          Bid bid = _con!.bids[index];

                          return BitItemWidget(
                            text: "Offer:",
                            bid: bid,
                            onProductTap: () {
                              Navigator.of(context).pushNamed("/ItemDetails",
                                  arguments: RouteArgument(
                                      product: bid.product, isMine: true));
                            },
                            onProfileTap: () {
                              if (bid.user != null) {
                                Navigator.of(context).pushNamed("/UserProfile",
                                    arguments: RouteArgument(user: bid.user));
                              }
                            },
                          );
                        },
                      )
          ],
        ),
      ),
    );
  }
}
