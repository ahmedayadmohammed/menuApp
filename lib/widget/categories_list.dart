import 'package:flutter/material.dart';

import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/models/cat_model.dart';
import 'package:menu_app/providers/color_provider.dart';
import 'package:menu_app/widget/category_detail_list.dart';
import 'package:provider/provider.dart';

class CategoriesWidgetContainer extends StatefulWidget {
  final List<Category>? category;
  final List<Food>? foods;
  CategoriesWidgetContainer({
    Key? key,
    required this.category,
    this.foods,
  }) : super(key: key);

  @override
  _CategoriesWidgetContainerState createState() =>
      _CategoriesWidgetContainerState();
}

class _CategoriesWidgetContainerState extends State<CategoriesWidgetContainer> {
  @override
  Widget build(BuildContext context) {
    final color = Provider.of<ColorSelector>(context, listen: true);

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: GridView.builder(
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: widget.category?.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        color.selectedIndex = index;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryListDetail(
                                    title: widget.category?[index].nameAr,
                                    catId: widget.category?[index].id,
                                    cat: widget.category,
                                  )),
                        );
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Stack(
                            // fit: exp,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height / 4,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/mainlogo.png',
                                        image:
                                            "https://menu.trendad.agency/storage/${widget.category?[index].image ?? ""}",
                                        fit: BoxFit.fill)),
                              ),
                              Container(
                                  // width: 120.0,
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  margin: EdgeInsets.all(0.0),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
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
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      "${widget.category?[index].nameAr ?? "No name"}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: HexColor("#586e5c"),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    decoration: BoxDecoration(
                                        color: HexColor("#eae6d9"),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                            bottomRight:
                                                Radius.circular(20.0))),
                                  ))
                            ],
                          )));
                }),
          ),
        ],
      ),
    );
  }
}
