import 'package:flutter/material.dart';
import 'package:menu_app/extensions/color.dart';

class ItemsDetailWidget extends StatelessWidget {
  final String? title;
  final String? image;
  final String? description;
  final int? state;
  final String? discount;
  final String? price;
  final String? nameAr;
  final String? nameEn;
  const ItemsDetailWidget({
    Key? key,
    this.title,
    this.image,
    this.description,
    this.state,
    this.discount,
    this.price,
    this.nameAr,
    this.nameEn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 450,
          stretch: true,
          stretchTriggerOffset: 300,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
              StretchMode.blurBackground,
            ],
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  "https://menu.trendad.agency/storage/${image ?? ""}",
                  fit: BoxFit.cover,
                ),
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
                      nameEn ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: HexColor("#eae6d9"),
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      title ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: HexColor("#eae6d9"),
                        fontSize: 40,
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
                        description ?? "",
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
                          "د.ع ${price ?? ""}",
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
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 90,
                          width: 90,
                          color: Colors.red,
                        ),
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
  }
}
