// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iExchange_it/src/controller/QnAController.dart';
import 'package:iExchange_it/src/elements/CircularLoadingWidget.dart';
import 'package:iExchange_it/src/models/answer.dart';
import 'package:iExchange_it/src/models/question.dart';
import 'package:iExchange_it/src/models/route_argument.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class QnAListWidget extends StatefulWidget {
 final RouteArgument? argument;

  QnAListWidget({this.argument});

  @override
  _QnAListWidgetState createState() => _QnAListWidgetState();
}

class _QnAListWidgetState extends StateMVC<QnAListWidget> {

  QnAController? _con;

  _QnAListWidgetState() : super(QnAController()) {
    _con = controller as QnAController?;
  }

  @override
  void initState() {
    _con!.currentUser = widget.argument!.currentUser;
    super.initState();
    _con!.getAllQuestions();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;


    var format = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSZ');

    return Scaffold(
      key: _con!.scaffoldKey,
      appBar: AppBar(
        title: Text("Q & A Forum", style: textTheme.headline6, ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          _con!.getAllQuestions();
        },
        child: Stack(
          children: [

            Container(
              height: size.height,
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.only(bottom: 58),
              child: SingleChildScrollView(
                child: Column(
                  children: [


                    _con!.isLoading
                        ? CircularLoadingWidget(
                      height: 100,
                    )
                        : _con!.questions.isEmpty
                        ? Container(
                      height: size.height,
                      width: size.width,
                      child: Center(
                        child: Text(
                          "Noting Found",
                          style: textTheme.caption,
                        ),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con!.questions.length,
                      itemBuilder: (context, i) {

                        Question q = _con!.questions[i];
                        var QDateTime = format.parse(q.createdAt!);
                        var qDay = DateFormat('EEEE').format(QDateTime);
                        var qTime = DateFormat('hh:mm aa').format(QDateTime);

                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: theme.highlightColor,
                              width: 0.4
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text("Question:", style: textTheme.headline6,),
                              SizedBox(height: 5,),
                              Text(q.question!, style: textTheme.subtitle1!.merge(TextStyle(
                                color: Colors.white
                              )),),
                              Text("Asked $qDay at $qTime", style: textTheme.caption,),

                              SizedBox(height: 5,),

                              q.answers!.isNotEmpty
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  Text("Answers: ", style: textTheme.headline6,),
                                  Divider(),
                                ],
                              )
                              : Text("Not answered yet.", style: textTheme.bodyText2,),

                              q.answers!.isNotEmpty
                              ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: q.answers!.length,
                                      itemBuilder: (context, j) {

                                        Answer ans = q.answers![j];
                                        var aDateTime = format.parse(ans.createdAt);
                                        var aDay = DateFormat('EEEE').format(aDateTime);
                                        var aTime = DateFormat('hh:mm aa').format(aDateTime);

                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          margin: EdgeInsets.symmetric(vertical: 5),
                                          decoration: BoxDecoration(
                                            border: Border(bottom: BorderSide(color: theme.highlightColor, width: 0.4))
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(1000),
                                                child: CachedNetworkImage(
                                                  imageUrl: ans.user!.image,
                                                  width: 25,
                                                  height: 25,
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, value) {
                                                    return Image.asset("assets/placeholders/profile.png",
                                                      width: 25,
                                                      height: 25,
                                                      fit: BoxFit.cover,);
                                                  },
                                                ),
                                              ) ,

                                              SizedBox(width: 10,),

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(ans.user!.name, style: textTheme.bodyText1!.merge(TextStyle(
                                                      color: theme.colorScheme.secondary
                                                    )),),
                                                    Text("Answered $aDay at $aTime", style: textTheme.caption,),
                                                    SizedBox(height: 5,),
                                                    Text(ans.answer, style: textTheme.bodyText1,)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )

                                  ],
                                ),
                              )
                              : SizedBox(height: 0),


                            ],
                          ),
                        );
                      },
                    ),


                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pushNamed("/CreateQuestion");
                  },
                  child: Container(
                    height: 40,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(3)
                    ),
                    child: Center(
                      child: Text(
                        "Ask a Question",
                        style: textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
