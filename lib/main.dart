import 'package:flutter/material.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/providers/color_provider.dart';
import 'package:menu_app/providers/language_provider.dart';
import 'package:menu_app/widget/item_detail.dart';
import 'package:menu_app/widget/main_home.dart';
import 'package:menu_app/widget/rating_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Languages/Localizations.dart';
import 'Languages/language_constant.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ColorSelector>(
              create: (context) => ColorSelector()),
          ChangeNotifierProvider<OtherNotesProvderClass>(
              create: (context) => OtherNotesProvderClass()),
          ChangeNotifierProvider<ChangeHomeLanguage>(
              create: (context) => ChangeHomeLanguage()),
        ],
        child: this._locale == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue[800]!)),
                ),
              )
            : MaterialApp(
                builder: (context, widget) => ResponsiveWrapper.builder(
                    BouncingScrollWrapper.builder(context, widget!),
                    maxWidth: 1600,
                    minWidth: 1550,
                    defaultScale: true,
                    breakpoints: [
                      ResponsiveBreakpoint.resize(450, name: MOBILE),
                      ResponsiveBreakpoint.autoScale(800, name: TABLET),
                      ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                    ],
                    background: Container(color: Color(0xFF080606))),
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                locale: _locale,
                supportedLocales: [
                  Locale("en", "US"),
                  Locale("ar", "SA"),
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale!.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                routes: {
                  '/home': (context) => HomeMainController(),
                  // '/cDetails': (context) => CategoryListDetail(),
                  '/itemdetail': (context) => ItemsDetailWidget(),
                  '/rating': (context) => RatingControllerWidget()
                },
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: "DINArabic",
                  textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.black,
                      displayColor: Colors.black,
                      fontFamily: "DINArabic"),
                  scaffoldBackgroundColor: HexColor('#B08C42'),
                  appBarTheme: AppBarTheme(
                    titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: "DINArabic",
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    backgroundColor: HexColor('#B08C42'),
                    iconTheme: IconThemeData(color: Colors.black),
                  ),
                  canvasColor: HexColor('#B08C42'),
                  primaryColor: HexColor('#B08C42'),
                ),
                initialRoute: '/home',
              ));
  }
}




      // '/home': (context) => HomeMainController(),
      //         // '/cDetails': (context) => CategoryListDetail(),
      //         '/itemdetail': (context) => ItemsDetailWidget(),
      //         '/rating': (context) => RatingControllerWidget()                fontFamily: 'DINArabic',
