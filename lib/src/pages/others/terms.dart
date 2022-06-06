import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:iExchange_it/config/app_config.dart' as config;
import 'package:iExchange_it/config/strings.dart';

class TermsOfUserWidget extends StatefulWidget {
  @override
  _TermsOfUserWidgetState createState() => _TermsOfUserWidgetState();
}

class _TermsOfUserWidgetState extends State<TermsOfUserWidget> {

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
        title: Text("Terms of Use", style: textTheme.headline6, ),
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
                text: TOU1, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU2, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU3, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU4, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: acceptance, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU5, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: description, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU6, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: featuredAds, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU7, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: conduct, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU8, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: paidPosting, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU9, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: postingAgents, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU10, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: accessService, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU11, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: notificationClaims, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU12, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),


              TextHighlight(
                text: intellectualProp, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU13, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: userSubmissions, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU14, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: indeminity, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU15, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: noSpam, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU16, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: orgIndvDeals, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU17, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: Limitations, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU18, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: assignment, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU19, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: acceptTerms, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU20, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: generalInfo, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU21, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: termsVoilation, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU22, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: warranties, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU23, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: abilityLimitations, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU24, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: propertySale, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU25, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: motors, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU26, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: automatedData, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU27, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: callRecord, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU28, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: cvSearch, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),

              SizedBox(height: 10,),

              TextHighlight(
                text: TOU29, // You need to pass the string you want the highlights
                words: words, // Your dictionary words
                textStyle: textTheme.bodyText1!, // You can use any attribute of the RichText widget
                matchCase: true,
              ),



            ],
          ),
        ),
      ),
    );
  }
}
