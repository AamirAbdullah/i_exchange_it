// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportWidget extends StatefulWidget {
  @override
  _HelpAndSupportWidgetState createState() => _HelpAndSupportWidgetState();
}

class _HelpAndSupportWidgetState extends State<HelpAndSupportWidget> {
  String supportEmail = "support@iexchangeit.com";

  TextEditingController? subjectController;
  TextEditingController? detailsController;

  GlobalKey<FormState>? formKey;

  @override
  void initState() {
    this.formKey = GlobalKey<FormState>();
    subjectController = TextEditingController();
    detailsController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var size = MediaQuery.of(context).size;

    return Scaffold(
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
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Form(
            key: this.formKey,
            child: Column(
              children: [
                Container(
                  // constraints: BoxConstraints(
                  //   minHeight: 100,
                  // ),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(
                    horizontal: 7,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 0.5, color: theme.focusColor)),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textAlignVertical: TextAlignVertical.top,
                    controller: this.subjectController,
                    validator: (value) =>
                        value!.isEmpty ? "Subject can't be empty" : null,
                    style: textTheme.bodyText1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Enter Subject",
                      hintStyle: textTheme.bodyText1!
                          .merge(TextStyle(color: theme.hintColor)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                      border: Border.all(width: 0.5, color: theme.focusColor)),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 3,
                    maxLines: null,
                    controller: this.detailsController,
                    validator: (value) =>
                        value!.isEmpty ? "Message can't be empty" : null,
                    style: textTheme.bodyText1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Your message",
                      hintStyle: textTheme.bodyText1!
                          .merge(TextStyle(color: theme.hintColor)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    if (this.formKey!.currentState!.validate()) {
                      String mailTo = 'mailto:${this.supportEmail}?subject='
                          '${this.subjectController!.text}'
                          '&body=${this.detailsController!.text}';
                      launch(mailTo);
                    }
                  },
                  child: Container(
                    height: 40,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: theme.accentColor,
                        borderRadius: BorderRadius.circular(3)),
                    child: Center(
                      child: Text(
                        "Send",
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
    );
  }
}
