import 'package:flutter/material.dart';
import 'package:menu_app/widget/item_detail.dart';
import 'package:provider/provider.dart';

import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/network_modular/http_request.dart';
import 'package:menu_app/providers/color_provider.dart';

class CategoryListDetail extends StatefulWidget {
  String? title;
  final int? catId;
  final List<Category>? cat;
  CategoryListDetail({
    Key? key,
    this.title,
    this.catId,
    this.cat,
  }) : super(key: key);

  @override
  _CategoryListDetailState createState() => _CategoryListDetailState();
}

class _CategoryListDetailState extends State<CategoryListDetail> {
  int? catids;
  @override
  void initState() {
    super.initState();
    catids = widget.catId;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? "",
            style: TextStyle(
                color: HexColor("#9c9a71"),
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: HexColor("#586e5c"),
          // title: Text("Menu home"),
        ),
        body: Row(children: [
          Expanded(
            flex: 70,
            child: ItemsList(
              id: catids,
            ),
          ),
          CategoryListSide(
              category: widget.cat!,
              didSeletRowAt: (index) => {
                    setState(() {
                      catids = widget.cat?[index].id;
                      widget.title = widget.cat?[index].nameAr;
                    }),
                  })
        ]),
      ),
    );
  }
}

// categories
class CategoryListSide extends StatelessWidget {
  final List<Category> category;
  final Function(int index)? didSeletRowAt;
  const CategoryListSide({
    Key? key,
    required this.category,
    this.didSeletRowAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Provider.of<ColorSelector>(context, listen: true);

    return Expanded(
        flex: 30,
        child: Container(
          color: HexColor("#9c9a71"),
          child: ListView.builder(
            itemCount: category.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    color.changeSelection(index);
                    didSeletRowAt!(index);
                  },
                  child: Container(
                    color: color.selectedIndex == index
                        ? HexColor("#586e5c")
                        : Colors.transparent,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            // fit: exp,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 7,
                                width: MediaQuery.of(context).size.width / 5,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      "https://menu.trendad.agency/storage/${category[index].image}",
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Positioned(
                                  bottom: 0,
                                  child: Container(
                                    child: Center(
                                        child: Text(
                                      "${category[index].nameAr}",
                                      style: TextStyle(
                                          color: HexColor("#586e5c"),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    decoration: BoxDecoration(
                                        color: HexColor("#eae6d9"),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0))),
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    height: 50,
                                  ))
                            ],
                          )),
                    ),
                  ));
            },
          ),
        ));
  }
}

// Category item list
class ItemsList extends StatefulWidget {
  final int? id;
  ItemsList({Key? key, this.id}) : super(key: key);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HttpClient.instance.getAllDataofHome(
          "https://menu.trendad.agency/api/category/${widget.id}"),
      builder: (BuildContext context, AsyncSnapshot<Foodresponse> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
              shrinkWrap: false,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data?.data?.food?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      print("item list");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ItemsDetailWidget(
                                  state: snapshot
                                          .data?.data?.food?[index].status ??
                                      1,
                                  description: snapshot.data?.data?.food?[index]
                                          .descriptionAr ??
                                      "",
                                  price:
                                      snapshot.data?.data?.food?[index].price ??
                                          "",
                                  image:
                                      snapshot.data?.data?.food?[index].image ??
                                          "",
                                  discount: snapshot.data?.data?.food?[index]
                                          .priceDiscounted ??
                                      "",
                                  title: snapshot
                                          .data?.data?.food?[index].nameAr ??
                                      "",
                                  nameEn: snapshot
                                          .data?.data?.food?[index].nameEn ??
                                      "",
                                      listFood: snapshot.data?.data?.food
                                )),
                      );
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Stack(
                          // fit: exp,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 3.5,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    "https://menu.trendad.agency/storage/${snapshot.data?.data?.food?[index].image ?? ""}",
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Container(
                                // width: 120.0,
                                height:
                                    MediaQuery.of(context).size.height / 3.5,
                                margin: EdgeInsets.all(0.0),
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Colors.black.withAlpha(5),
                                      Colors.black12,
                                      Colors.black45,
                                      Colors.black54
                                    ],
                                  ),
                                )),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 70,
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        snapshot.data?.data?.food?[index]
                                                .price ??
                                            "",
                                        style: TextStyle(
                                            color: HexColor("#586e5c"),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        snapshot.data?.data?.food?[index]
                                                .nameAr ??
                                            "",
                                        style: TextStyle(
                                            color: HexColor("#586e5c"),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  )),
                                  decoration: BoxDecoration(
                                      color: HexColor("#eae6d9"),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0))),
                                ))
                          ],
                        )));
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
