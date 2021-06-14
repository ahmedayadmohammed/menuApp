import 'dart:convert';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_app/extensions/alerts.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/models/error_response.dart';

import 'package:menu_app/models/question_model.dart';
import 'package:menu_app/network_modular/http_request.dart';
import 'package:menu_app/providers/rating_provider.dart';
import 'package:provider/provider.dart';

class RatingControllerWidget extends StatefulWidget {
  const RatingControllerWidget({Key? key}) : super(key: key);

  @override
  _RatingControllerWidgetState createState() => _RatingControllerWidgetState();
}

class _RatingControllerWidgetState extends State<RatingControllerWidget> {
  GroupController controller = GroupController();
  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNodes2 = new FocusNode();
  FocusNode myFocusNodes3 = new FocusNode();
  FocusNode myFocusNodes4 = new FocusNode();

  PostResponse? responseMe;

  TextEditingController txtController = TextEditingController();
  TextEditingController txtController2 = TextEditingController();
  TextEditingController txtController3 = TextEditingController();
  TextEditingController txtTableController = TextEditingController();

  bool isSent = false;
  String? phoneNumber = "";
  String? customerName = "";
  String? tableNumber = "";
  String? otherNotes = "";
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    txtController.dispose();
    txtController2.dispose();
    txtController3.dispose();
    txtTableController.dispose();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RatingProvider>(
      create: (context) => RatingProvider(),
      child: Material(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: HexColor("#586e5c"),
              title: Text("التقييم"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.red,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(children: [
                          Container(
                            margin: EdgeInsets.all(13),
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.all(9),
                                        width: 300,
                                        child: TextField(
                                          style: TextStyle(
                                              color: HexColor("#eae6d9"),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          controller: txtTableController,
                                          keyboardType: TextInputType.phone,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 4.0,
                                              )),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 4.0,
                                                ),
                                              ),
                                              suffixIcon: Icon(
                                                Icons.table_view,
                                                color: Colors.white,
                                              ),
                                              labelText: "رقم الطاولة",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: myFocusNodes4.hasFocus
                                                      ? Colors.white
                                                      : Colors.white38),
                                              hintText: "رقم الطاولة"),
                                          onChanged: (text) {
                                            tableNumber = text;
                                            print("First text field: $text");
                                          },
                                        ),
                                      )),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.all(9),
                                        width: 300,
                                        child: TextField(
                                          style: TextStyle(
                                              color: HexColor("#eae6d9"),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          controller: txtController,
                                          keyboardType: TextInputType.phone,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 4.0,
                                              )),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 4.0,
                                                ),
                                              ),
                                              suffixIcon: Icon(
                                                Icons.phone,
                                                color: Colors.white,
                                              ),
                                              labelText: "رقم الهاتف",
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: myFocusNode.hasFocus
                                                      ? Colors.white
                                                      : Colors.white38),
                                              hintText: "رقم الهاتف"),
                                          onChanged: (text) {
                                            phoneNumber = text;
                                            print("First text field: $text");
                                          },
                                        ),
                                      )),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.all(9),
                                        width: 300,
                                        child: TextField(
                                          style: TextStyle(
                                              color: HexColor("#eae6d9"),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          controller: txtController2,
                                          textAlign: TextAlign.right,
                                          decoration: InputDecoration(
                                              fillColor: HexColor("#eae6d9"),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 4.0,
                                              )),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: HexColor("#eae6d9"),
                                                  width: 4.0,
                                                ),
                                              ),
                                              suffixIcon: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                              labelText: "أسم الزبون",
                                              labelStyle: TextStyle(
                                                  color: myFocusNodes2.hasFocus
                                                      ? Colors.white
                                                      : Colors.white38),
                                              hintText: "أسم الزبون"),
                                          onChanged: (text) {
                                            customerName = text;
                                            print("First text field: $text");
                                          },
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ]))),
                Expanded(child: QuestionListView(controller: controller)),
                Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    child: Center(
                      child: TextField(
                        maxLines: 3,
                        style: TextStyle(
                            color: HexColor("#eae6d9"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        controller: txtController3,
                        keyboardType: TextInputType.phone,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.white,
                              width: 4.0,
                            )),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 4.0,
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.reviews_outlined,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            hintText: "ملاحظات اخرى"),
                        onChanged: (text) {
                          otherNotes = text;
                          print("First text field: $text");
                        },
                      ),
                    )),
                Container(
                  child: Consumer<RatingProvider>(
                    builder: (context, model, child) {
                      return InkWell(
                        onTap: () {
                          model.ratingMapSequence();

                          if (tableNumber != "" &&
                              phoneNumber != "" &&
                              customerName != "" &&
                              otherNotes != "") {
                            setState(() {
                              isSent = true;
                            });
                            HttpClient.instance.postRating(
                                "https://menu.trendad.agency/api/submit-form",
                                {
                                  "customer_name": customerName,
                                  "customer_phone": phoneNumber,
                                  "table_number": tableNumber,
                                  "suggestion": otherNotes,
                                  "questions": model.jsonObject
                                },
                                (success, data) => {
                                      if (success)
                                        {
                                          setState(() {
                                            isSent = false;
                                          }),
                                          showAlertDialogChecking(
                                              context: context,
                                              title: "",
                                              content: data?.data ?? "",
                                              defaultActionText: "تم")
                                        }
                                      else
                                        {
                                          setState(() {
                                            isSent = false;
                                          }),
                                          showAlertDialogChecking(
                                              context: context,
                                              title: "",
                                              content: data?.data ?? "",
                                              defaultActionText: "تم")
                                        }
                                    });
                          } else {
                            showAlertDialogChecking(
                                context: context,
                                title: "الحقول مطلوبة",
                                content:
                                    "الرجاء ادخال الحقول المطلوبة لأتمام عملية التقييم بنجاح",
                                defaultActionText: "تم");
                          }
                        },
                        child: Container(
                            width: 200,
                            height: 100,
                            child: Center(
                                child: isSent
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "أرسال البيانات",
                                        style: TextStyle(
                                            color: HexColor("#eae6d9"),
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ))),
                      );
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class QuestionListView extends StatefulWidget {
  final GroupController controller;

  QuestionListView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _QuestionListViewState createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RatingProvider>(
      create: (context) => RatingProvider(),
      child: FutureBuilder(
        future: HttpClient.instance
            .getAllQuestions("https://menu.trendad.agency/api/form"),
        builder:
            (BuildContext context, AsyncSnapshot<QuestionsResponse> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.data?.questions?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: HexColor("#eae6d9").withAlpha(70)),
                  child: Consumer<RatingProvider>(
                    builder: (context, model, child) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Text(
                                      snapshot.data?.data?.questions?[index]
                                              .titleAr ??
                                          "",
                                      style: TextStyle(
                                          color: HexColor("#eae6d9"),
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                SimpleGroupedChips<int>(
                                  controller: widget.controller,
                                  values: List.generate(7, (index) => index),
                                  itemTitle: ["ممتاز", "جيد", "متوسط", "سيء"],
                                  backgroundColorItem: Colors.black26,
                                  isScrolling: false,
                                  onItemSelected: (values) {
                                    model.ratingMap[index] = {
                                      'question_id': snapshot.data?.data
                                              ?.questions?[index].id ??
                                          0,
                                      'rating': values
                                    };
                                    print(model.ratingMap);
                                  },
                                )
                              ],
                            ),
                            SizedBox(width: 15),
                            Container(
                              height: 200,
                              width: 100,
                              child: Center(
                                child: Icon(
                                  Icons.rate_review,
                                  size: 50,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0))),
                            ),
                          ]);
                    },
                  ));
            },
          );
        },
      ),
    );
  }
}
