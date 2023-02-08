import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/Languages/Localizations.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/extensions/key.dart';
import 'package:menu_app/network_modular/api_response.dart';
import 'package:menu_app/providers/home_provider.dart';
import 'package:menu_app/widget/LoginviewController.dart';
import 'package:menu_app/widget/VersionViewController.dart';
import 'package:menu_app/widget/categories_list.dart';
import 'package:menu_app/widget/rating_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../Languages/Language_class.dart';
import '../Languages/language_constant.dart';
import '../main.dart';
import '../providers/language_provider.dart';

class HomeMainController extends StatefulWidget {
  const HomeMainController({Key? key}) : super(key: key);

  @override
  _HomeMainControllerState createState() => _HomeMainControllerState();
}

class _HomeMainControllerState extends State<HomeMainController> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String token = "";
  var languageCode = "";
  Future getToken() {
    return ApplicationKeys.instance.getStringValue("token").then((value) => {
          setState(() {
            token = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    getToken();
    ApplicationKeys.instance.getStringValue("languageCode").then((code) => {
          if ((code) != '')
            {
              setState(() {
                languageCode = code;
              })
            },
        });
  }

  void _changeLanguage(String language) async {
    Locale _locale = await setLocale(language);
    MyApp.setLocale(context, _locale);
  }

  @override
  Widget build(BuildContext context) {
    final providerMe = Provider.of<ChangeHomeLanguage>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#DDAF55"),
          title: Text(
            "بيت حلب",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: HexColor("#eae6d9"),
                fontSize: 25),
          ),
        ),
        drawer: Drawer(
          child: SizedBox(
              width: MediaQuery.of(context).size.width /
                  2, // 75% of screen will be occupied
              child: Container(
                color: HexColor('#B08C42'),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          DrawerHeader(
                            decoration:
                                BoxDecoration(color: HexColor("#eae6d9")),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 100,
                              child: Image.asset(
                                "assets/mainlogo2.png",
                              ),
                            ),
                          ),
                          ListTile(
                            focusColor: Colors.white12,
                            trailing: Icon(Icons.arrow_forward_ios_outlined),
                            subtitle: Text("Give rating".getlocal(context),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#eae6d9"),
                                    fontSize: 15)),
                            title: Text(
                              "Rate".getlocal(context),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.pop(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RatingControllerWidget()),
                              );
                            },
                          ),
                          ListTile(
                            focusColor: Colors.white12,
                            trailing: Icon(Icons.arrow_forward_ios_outlined),
                            subtitle: Text("User Login".getlocal(context),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15)),
                            title: Text(
                              "Login".getlocal(context),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              await getToken();
                              if (token.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginViewController(
                                            isToken: false,
                                          )),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginViewController(
                                            isToken: true,
                                          )),
                                );
                              }
                            },
                          ),
                          ListTile(
                            focusColor: Colors.white12,
                            trailing: Icon(Icons.arrow_forward_ios_outlined),
                            subtitle: Text("App Version".getlocal(context),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#eae6d9"),
                                    fontSize: 15)),
                            title: Text(
                              "Update Version".getlocal(context),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.pop(context);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CheckVersionViewController()),
                              );
                            },
                          ),
                          ListTile(
                            focusColor: Colors.white12,
                            trailing: Icon(Icons.arrow_forward_ios_outlined),
                            subtitle: Text("Language".getlocal(context),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#eae6d9"),
                                    fontSize: 15)),
                            title: Text(
                              "Change Language".getlocal(context),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.pop(context);

                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    List<Widget> langs = [];
                                    Language.languageList().forEach((element) {
                                      langs.add(Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ListTile(
                                            title: Text(element.name),
                                            leading:
                                                Icon(Icons.language_outlined),
                                            onTap: () {
                                              providerMe.getLocalTranslation();
                                              Navigator.pop(context);
                                              _changeLanguage(
                                                  element.languageCode);
                                            },
                                          )));
                                    });
                                    return SafeArea(
                                      child: Wrap(
                                        children: langs,
                                      ),
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              "Powered and developed by trend (for marketing and software solutions) LTD"
                                  .getlocal(context),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#eae6d9"),
                                  fontSize: 9)),
                          Text(
                              "All copyrights are Reserved by trend 2023"
                                  .getlocal(context),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#eae6d9"),
                                  fontSize: 9))
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        body: ChangeNotifierProvider(
          create: (context) => HomeProvider(),
          child: Consumer<HomeProvider>(
            builder: (context, home, child) {
              if (home.item?.status == Status.COMPLETED) {
                var storageUrl = home.item?.data?.data?.storageUrl ?? "";
                var category = home.item?.data?.data?.categories ?? [];
                var foods = home.item?.data?.data?.food ?? [];
                var slider = home.item?.data?.data?.sliders ?? [];
                return Material(
                    child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: () {
                    home.fetchMenuDetails();
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 60),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 100,
                                    child: Image.asset(
                                      "assets/mainlogo2.png",
                                    ),
                                  ),
                                ),
                              ]),
                          // width: 80,
                          height: 180,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: MediaQuery.of(context).size.width / 3,
                          child: CarouselSlider.builder(
                            itemCount: slider.length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                    value) =>
                                GestureDetector(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            color: Colors.grey),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 400,
                                        child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                child: Image.network(
                                                  "${storageUrl}${slider[itemIndex].image}",
                                                  fit: BoxFit.cover,
                                                )))),
                                    onTap: () => {}),
                            options: CarouselOptions(
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: SizedBox(
                        height: 30,
                      )),
                      SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            "Menu".getlocal(context),
                            style: TextStyle(
                                color: HexColor("#eae6d9"), fontSize: 30),
                          ),
                        ),
                      ),
                      CategoriesWidgetContainer(
                        foods: foods,
                        category: category,
                        storageUrl: storageUrl,
                      )
                    ],
                  ),
                ));
              } else if (home.item?.status == Status.LOADING) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (home.item?.status == Status.ERROR) {
                return errorWidget(context, home);
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
        ));
  }
}

SizedBox errorWidget(BuildContext context, dynamic home) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Error happened".getlocal(context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextButton(
          onPressed: () {
            home.fetchMenuDetails();
          },
          child: Text(
            "Refresh".getlocal(context),
            style: TextStyle(
                color: Colors.lime, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
