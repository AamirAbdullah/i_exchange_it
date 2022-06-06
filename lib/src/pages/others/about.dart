import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:iExchange_it/config/strings.dart';
import 'package:iExchange_it/config/app_config.dart' as config;

class AboutWidget extends StatefulWidget {
  @override
  _AboutWidgetState createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {

  Map<String, HighlightedWord> words = {
    "iexchangeit.com": HighlightedWord(
      onTap: () {
        print("Flutter");
      },
      textStyle: TextStyle(fontSize: 14.0, color: config.Colors().mainDarkColor(1)),
    ),
    "IEXCHANGEIT.COM": HighlightedWord(
      onTap: () {
        print("open-source");
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
        title: Text("About", style: textTheme.headline6, ),
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
                text: about, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
              ),

            ],
          ),
        ),
      ),
    );
  }
}
