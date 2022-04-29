import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:menu_app/extensions/alerts.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/providers/color_provider.dart';
import 'package:provider/provider.dart';

class ItemsDetailWidget extends StatelessWidget {
  final String? title;
  final String? image;
  final String? description;
  final int? state;
  final String? discount;
  final String? price;
  final String? nameAr;
  final String? nameEn;
  final List<Food>? listFood;
  final String? storageUrl;
  const ItemsDetailWidget(
      {Key? key,
      this.title,
      this.image,
      this.description,
      this.state,
      this.discount,
      this.price,
      this.nameAr,
      this.nameEn,
      this.listFood,
      this.storageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Provider.of<ColorSelector>(context, listen: true);

    return ChangeNotifierProvider<ChangeInformations>(
        //                                <--- Provider
        create: (context) => ChangeInformations(),
        child: Consumer<ChangeInformations>(
          builder: (context, change, child) {
            return Material(
                child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 750,
                  stretch: true,
                  foregroundColor: HexColor("#DDAF55"),
                  stretchTriggerOffset: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.fadeTitle,
                    ],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                            change.isSelectionStarted
                                ? "$storageUrl${change.image ?? ""}"
                                : "$storageUrl${image ?? ""}",
                            fit: BoxFit.cover),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.0, 0.5),
                              end: Alignment(0.0, 0.0),
                              colors: <Color>[
                                Color(0x60000000),
                                Color(0x00000000),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              change.isSelectionStarted
                                  ? change.englishName ?? ""
                                  : nameEn ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: HexColor("#eae6d9"),
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              change.isSelectionStarted
                                  ? change.arabicName ?? ""
                                  : title ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: HexColor("#eae6d9"),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                change.isSelectionStarted
                                    ? change.description ?? ""
                                    : description ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#eae6d9"),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 240,
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: HexColor("#eae6d9")),
                              child: Center(
                                child: Text(
                                  change.isSelectionStarted
                                      ? "د.ع ${change.price}"
                                      : "د.ع ${price ?? ""}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor("#586e5c"),
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listFood?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 125,
                                width: 250,
                                child: InkWell(
                                    onTap: () {
                                      color.selectedIndex = index;
                                      change.isSelectionStarted = true;
                                      change.fillOutInofrmation(
                                          listFood?[index].nameEn ?? "",
                                          listFood?[index].nameAr ?? "",
                                          listFood?[index].descriptionAr ?? "",
                                          listFood?[index].price ?? "",
                                          listFood?[index].image ?? "");
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Stack(
                                          // fit: exp,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "$storageUrl${listFood?[index].image ?? ""}",
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        Image.asset(
                                                            'assets/mainlogo.png'),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  )),
                                            ),
                                            Container(
                                                // width: 120.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                margin: EdgeInsets.all(0.0),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
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
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  height: 90,
                                                  child: Center(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          listFood?[index]
                                                                  .nameAr ??
                                                              "",
                                                          style: TextStyle(
                                                              color: HexColor(
                                                                  "#586e5c"),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          listFood?[index]
                                                                      .priceDiscounted ==
                                                                  null
                                                              ? Text(
                                                                  listFood?[index]
                                                                          .price ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      color: HexColor(
                                                                          "#586e5c"),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900),
                                                                )
                                                              : Row(
                                                                  children: [
                                                                    Text(
                                                                      "${listFood?[index].priceDiscounted == null ? "" : listFood?[index].priceDiscounted} IQD",
                                                                      style: TextStyle(
                                                                          color: HexColor(
                                                                              "#586e5c"),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w900),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                      child: Text(
                                                                          " - "),
                                                                    ),
                                                                    Text(
                                                                      "${listFood?[index].price ?? ""} IQD",
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              15,
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
                                                      color:
                                                          HexColor("#eae6d9"),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      8.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      8.0))),
                                                ))
                                          ],
                                        ))),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ));
          },
        ));
  }
}
