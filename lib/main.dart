import 'package:flutter/material.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/providers/color_provider.dart';
import 'package:menu_app/providers/food_provider.dart';
import 'package:menu_app/widget/category_detail_list.dart';
import 'package:menu_app/widget/item_detail.dart';
import 'package:menu_app/widget/main_home.dart';
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
          ChangeNotifierProvider<FoodResponseProvider>(
              create: (context) => FoodResponseProvider()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // initialRoute: '/home',
            routes: {
              '/home': (context) => HomeMainController(),
              // '/cDetails': (context) => CategoryListDetail(),
              '/itemdetail': (context) => ItemsDetailWidget()
            },
            theme: ThemeData(
                fontFamily: 'DINArabic',
                backgroundColor: HexColor("#586e5c"),
                brightness: Brightness.light,
                canvasColor: HexColor("#586e5c")),
            home: HomeMainController()));
  }
}
