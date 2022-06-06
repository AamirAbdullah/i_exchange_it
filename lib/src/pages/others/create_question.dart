import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iExchange_it/src/controller/QnAController.dart';

import 'package:iExchange_it/src/models/route_argument.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:iExchange_it/src/repository/user_repository.dart' as userRepo;

class CreateQuestionWidget extends StatefulWidget {
 final RouteArgument? argument;

  CreateQuestionWidget({this.argument});

  @override
  _CreateQuestionWidgetState createState() => _CreateQuestionWidgetState();
}

class _CreateQuestionWidgetState extends StateMVC<CreateQuestionWidget> {
  QnAController? _con;

  _CreateQuestionWidgetState() : super(QnAController()) {
    _con = controller as QnAController?;
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    userRepo.getCurrentUser().then((value) {
      _con!.currentUser = value;
    });
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
          "Ask Question",
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Form(
                key: _con!.formKey,
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(
                        horizontal: 7,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 0.5, color: theme.focusColor)),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top,
                        minLines: 1,
                        maxLines: null,
                        validator: (value) =>
                            value!.isEmpty || value.length < 20
                                ? "Enter at least 20 characters"
                                : null,
                        style: textTheme.bodyText1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Enter your Questions Details",
                          hintStyle: textTheme.bodyText1!
                              .merge(TextStyle(color: theme.hintColor)),
                        ),
                        onSaved: (value) {
                          _con!.question = value;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        _con!.postQuestion();
                      },
                      child: Container(
                        height: 40,
                        width: size.width,
                        decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(3)),
                        child: Center(
                          child: Text(
                            "Post Question",
                            style: textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
