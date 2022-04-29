import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/extensions/alerts.dart';
import 'package:provider/provider.dart';

import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/network_modular/http_request.dart';
import 'package:menu_app/providers/color_provider.dart';
import 'package:menu_app/widget/item_detail.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CategoryListDetail extends StatefulWidget {
  String? title;
  final int? catId;
  final List<Category>? cat;
  final int? index;
  final String? storageUrl;
  CategoryListDetail(
      {Key? key, this.title, this.catId, this.cat, this.index, this.storageUrl})
      : super(key: key);

  @override
  _CategoryListDetailState createState() => _CategoryListDetailState();
}

class _CategoryListDetailState extends State<CategoryListDetail> {
  int? catids;
  String? storage;
  @override
  void initState() {
    super.initState();
    catids = widget.catId;
    storage = widget.storageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? "",
            style: TextStyle(
                color: HexColor("#eae6d9"),
                fontSize: 35,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: HexColor("#DDAF55"),
          // title: Text("Menu home"),
        ),
        body: Row(children: [
          Expanded(
            flex: 70,
            child: ItemsList(
              id: catids,
              storageUrl: widget.storageUrl,
            ),
          ),
          CategoryListSide(
              category: widget.cat!,
              index: widget.index,
              storageUrl: widget.storageUrl,
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
class CategoryListSide extends StatefulWidget {
  final List<Category> category;
  final Function(int index)? didSeletRowAt;
  final int? index;
  final String? storageUrl;
  const CategoryListSide(
      {Key? key,
      required this.category,
      this.didSeletRowAt,
      this.index,
      this.storageUrl})
      : super(key: key);

  @override
  _CategoryListSideState createState() => _CategoryListSideState();
}

class _CategoryListSideState extends State<CategoryListSide> {
  late AutoScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);

    setState(() {
      controller.scrollToIndex(widget.index!,
          preferPosition: AutoScrollPosition.begin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Provider.of<ColorSelector>(context, listen: true);

    return Expanded(
        flex: 30,
        child: Container(
          color: HexColor("#DDAF55"),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: controller,
            itemCount: widget.category.length,
            itemBuilder: (BuildContext context, int index) {
              return AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller,
                  index: index,
                  child: GestureDetector(
                      onTap: () {
                        color.changeSelection(index);
                        widget.didSeletRowAt!(index);
                      },
                      child: Container(
                        height: 200,
                        color: color.selectedIndex == index
                            ? HexColor("#eae6d9").withAlpha(70)
                            : Colors.transparent,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                // fit: exp,
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 7,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${widget.storageUrl}${widget.category[index].image}",
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/mainlogo.png'),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )),
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      child: Container(
                                        child: Center(
                                            child: Text(
                                          "${widget.category[index].nameAr}",
                                          style: TextStyle(
                                              color: HexColor("#586e5c"),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        decoration: BoxDecoration(
                                            color: HexColor("#eae6d9"),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0))),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        height: 50,
                                      ))
                                ],
                              )),
                        ),
                      )));
            },
          ),
        ));
  }
}

// Category item list
class ItemsList extends StatefulWidget {
  final int? id;
  final String? storageUrl;
  ItemsList({Key? key, this.id, this.storageUrl}) : super(key: key);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HttpClient.instance
          .getAllDataofHome("http://192.168.1.1:8080/api/category/${widget.id}"),
      builder: (BuildContext context, AsyncSnapshot<Foodresponse> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
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
                                storageUrl: widget.storageUrl,
                                state: snapshot.data?.data?.food?[index].status ??
                                    1,
                                description: snapshot.data?.data?.food?[index]
                                        .descriptionAr ??
                                    "",
                                price: snapshot.data?.data?.food?[index].price ??
                                    "",
                                image: snapshot.data?.data?.food?[index].image ??
                                    "",
                                discount: snapshot.data?.data?.food?[index]
                                        .priceDiscounted ??
                                    "",
                                title:
                                    snapshot.data?.data?.food?[index].nameAr ??
                                        "",
                                nameEn:
                                    snapshot.data?.data?.food?[index].nameEn ?? "",
                                listFood: snapshot.data?.data?.food)),
                      );
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Stack(
                          // fit: exp,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width:MediaQuery.of(context).size.width ,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    "${widget.storageUrl}${snapshot.data?.data?.food?[index].image ?? ""}",
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Container(
                                // width: 120.0,
                                height: MediaQuery.of(context).size.height,
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
                                  height: 90,
                                  child: Center(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          snapshot.data?.data?.food?[index]
                                                  .nameAr ??
                                              "",
                                          style: TextStyle(
                                              color: HexColor("#586e5c"),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          snapshot.data?.data?.food?[index]
                                                      .priceDiscounted ==
                                                  null
                                              ? Text(
                                                  snapshot
                                                          .data
                                                          ?.data
                                                          ?.food?[index]
                                                          .price ??
                                                      "",
                                                  style: TextStyle(
                                                      color:
                                                          HexColor("#586e5c"),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      "${snapshot.data?.data?.food?[index].priceDiscounted ?? ""} IQD",
                                                      style: TextStyle(
                                                          color: HexColor(
                                                              "#586e5c"),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                      child: Text(" - "),
                                                    ),
                                                    Text(
                                                      "${snapshot.data?.data?.food?[index].price ?? ""} IQD",
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          color: Colors.red,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    )
                                                  ],
                                                )
                                        ],
                                      ),
                                    ],
                                  )),
                                  decoration: BoxDecoration(
                                      color: HexColor("#eae6d9"),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0))),
                                )),
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
