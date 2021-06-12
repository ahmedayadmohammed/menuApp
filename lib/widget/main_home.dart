import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/network_modular/http_request.dart';
import 'package:menu_app/widget/categories_list.dart';

class HomeMainController extends StatelessWidget {
  const HomeMainController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#586e5c"),
          title: Text("Menu home"),
        ),
        body: FutureBuilder(
          future: HttpClient.instance
              .getAllDataofHome("https://menu.trendad.agency/api/category"),
          builder:
              (BuildContext context, AsyncSnapshot<Foodresponse> snapshot) {
            if (snapshot.hasData) {
              return Material(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 60),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 100,
                                  child: Image.asset(
                                    "assets/mainlogo2.png",
                                  ),
                                ),
                              )
                            ]),
                        // width: 80,
                        height: 180,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery.of(context).size.width / 3,
                        child: CarouselSlider.builder(
                          itemCount: snapshot.data?.data?.sliders?.length ?? 0,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  value) =>
                              GestureDetector(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          color: Colors.grey),
                                      width: MediaQuery.of(context).size.width,
                                      height: 400,
                                      child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              child: Image.network(
                                                "https://menu.trendad.agency/storage/${snapshot.data?.data?.sliders?[itemIndex].image ?? ""}",
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
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
