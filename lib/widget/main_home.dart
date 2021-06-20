import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/extensions/connections.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/network_modular/http_request.dart';
import 'package:menu_app/widget/categories_list.dart';
import 'package:menu_app/widget/rating_widget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeMainController extends StatefulWidget {
  const HomeMainController({Key? key}) : super(key: key);

  @override
  _HomeMainControllerState createState() => _HomeMainControllerState();
}

class _HomeMainControllerState extends State<HomeMainController> {
  bool isConnectected = true;
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted)
      setState(() {
        fetchItems();
      });
    _refreshController.loadComplete();
  }

  fetchItems() {
    HttpClient.instance
        .getAllDataofHome("https://menu.trendad.agency/api/category");
  }

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        setState(() {
          isConnectected = false;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          isConnectected = true;
        });
        break;
      case ConnectivityResult.wifi:
        setState(() {
          isConnectected = true;
        });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#586e5c"),
          title: Text("Menu home"),
        ),
        drawer: Drawer(
          child: SizedBox(
              width: MediaQuery.of(context).size.width /
                  2, // 75% of screen will be occupied
              child: Container(
                color: HexColor("#586e5c"),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        // Important: Remove any padding from the ListView.
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
                            subtitle: Text("اعطاء تقييم للمطعم ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#eae6d9"),
                                    fontSize: 15)),
                            title: Text(
                              "التقييم",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#eae6d9"),
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
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      // height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 50,
                            child: Text(
                                "Powered and developed by trend (for marketing and software solutions) LTD",
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 9)),
                          ),
                          Text("All Copyrights are Reserved by trend 2021",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 9))
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        body: isConnectected
            ? FutureBuilder(
                future: HttpClient.instance.getAllDataofHome(
                    "https://menu.trendad.agency/api/category"),
                builder: (BuildContext context,
                    AsyncSnapshot<Foodresponse> snapshot) {
                  if (snapshot.hasData) {
                    return Material(
                        child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 60),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
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
                                itemCount:
                                    snapshot.data?.data?.sliders?.length ?? 0,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, value) =>
                                    GestureDetector(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                color: Colors.grey),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 400,
                                            child: FittedBox(
                                                fit: BoxFit.fill,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0)),
                                                    child: Image.network(
                                                      "https://menu.trendad.agency/${snapshot.data?.data?.sliders?[itemIndex].image}",
                                                      fit: BoxFit.contain,
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
                                "قائمة الطعام",
                                style: TextStyle(
                                    color: HexColor("#eae6d9"), fontSize: 30),
                              ),
                            ),
                          ),
                          CategoriesWidgetContainer(
                            foods: snapshot.data?.data?.food,
                            category: snapshot.data?.data?.categories,
                          )
                        ],
                      ),
                    ));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            : Center(
                child: Text("No internet Connection"),
              ));
  }
}
