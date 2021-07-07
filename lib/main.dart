import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/providers/color_provider.dart';
import 'package:menu_app/widget/item_detail.dart';
import 'package:menu_app/widget/main_home.dart';
import 'package:menu_app/widget/rating_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ColorSelector>(
              create: (context) => ColorSelector()),
          ChangeNotifierProvider<OtherNotesProvderClass>(
              create: (context) => OtherNotesProvderClass()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // initialRoute: '/home',
            routes: {
              '/home': (context) => HomeMainController(),
              // '/cDetails': (context) => CategoryListDetail(),
              '/itemdetail': (context) => ItemsDetailWidget(),
              '/rating': (context) => RatingControllerWidget()
            },
            theme: ThemeData(
                fontFamily: 'DINArabic',
                backgroundColor: HexColor("#229fb5"),
                brightness: Brightness.light,
                canvasColor: HexColor("#229fb5")),
            home: HomeMainController()));
  }
}
