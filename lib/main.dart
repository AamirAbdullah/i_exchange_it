import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:iExchange_it/config/app_config.dart' as config;
import 'package:iExchange_it/generated/i18n.dart';
import 'package:iExchange_it/route_generator.dart';
import 'package:iExchange_it/src/controller/controller.dart';
import 'package:iExchange_it/src/controller/user_controller.dart';
import 'package:iExchange_it/src/models/setting.dart';
import 'package:iExchange_it/src/repository/settings_repository.dart'
    as settingsRepo;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(Controller.myBackgroundMessageHandler);
  await GlobalConfiguration().loadFromAsset("configurations");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ValueListenableBuilder(
      valueListenable: settingsRepo.setting,
      builder: (context, Settings _settings, _) {
        print("Language is: " + _settings.language.value.languageCode);
        var lang = _settings.language.value;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => GoogleSignInController()),
          ],
          child: MaterialApp(
            title: "iExchangeIt",
            initialRoute: "/Splash",
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,
            locale: lang,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            // localeListResolutionCallback: S.delegate.listResolution(fallback: const Locale('en', '')),
            theme: ThemeData(
              fontFamily: 'Quicksand',
              primaryColor: config.Colors().scaffoldDarkColor(1),
              brightness: Brightness.dark,
              focusColor: config.Colors().accentDarkColor(1),
              hintColor: config.Colors().secondDarkColor(1),
              textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
                headline3: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondDarkColor(1)),
                headline4: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().secondDarkColor(1)),
                headline5: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainDarkColor(1)),
                headline2: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondDarkColor(1)),
                subtitle1: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: config.Colors().secondDarkColor(1)),
                subtitle2: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: config.Colors().mainDarkColor(1)),
                bodyText1: TextStyle(
                    fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
                bodyText2: TextStyle(
                    fontSize: 14.0, color: config.Colors().secondDarkColor(1)),
                caption: TextStyle(
                    fontSize: 10.0, color: config.Colors().accentDarkColor(1)),
              ),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: config.Colors().mainDarkColor(1)),
            ),
          ),
        );
      },
    );
  }
}
