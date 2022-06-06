import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:iExchange_it/config/app_config.dart' as config;
import 'package:iExchange_it/config/strings.dart';

class SafetyRulesWidget extends StatefulWidget {
  const SafetyRulesWidget({Key? key}) : super(key: key);

  @override
  _SafetyRulesWidgetState createState() => _SafetyRulesWidgetState();
}

class _SafetyRulesWidgetState extends State<SafetyRulesWidget> {

  Map<String, HighlightedWord> words = {
    "Services": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "Platform": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "2. What data do we collect about you?": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "Registration and other account information": HighlightedWord(
      onTap: () {
        print("open-source");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "iexchangeit.com": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "privacy@iexchangeit.com": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "Communication through the chat feature on our Platform": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "2.2 Data we collect automatically when you use of our Services": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "Device Information": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "Location information": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "Client and Log data": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "Clickstream data": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "Cookies and Similar Technologies": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "3. Do we collect data from children?": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "4. Why do we process your personal information?": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "5. How will we inform you about changes in our privacy statement?": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "6. Your rights": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "7. Communication and marketing": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "8. Who do we share your data with?": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "9. International transfers": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "10. Where do we store your data and for how long?": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "11. Technical and organisational measures and processing security": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "12. Links to third-party websites": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "13. Contact": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "14. Changes to this Policy": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
  };

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy", style: textTheme.headline6, ),
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icon(CupertinoIcons.back),),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextHighlight(
                text: privacyPolicy, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}

