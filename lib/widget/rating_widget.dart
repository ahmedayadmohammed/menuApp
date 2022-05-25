import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:menu_app/extensions/alerts.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/extensions/connections.dart';
import 'package:menu_app/models/error_response.dart';
import 'package:menu_app/models/question_model.dart';
import 'package:menu_app/network_modular/api_response.dart';
import 'package:menu_app/network_modular/http_request.dart';
import 'package:menu_app/providers/rating_provider.dart';

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
  bool isConnectected = true;

  //TODO
  Map<dynamic, dynamic> hitMeRating = new Map();

  String? phoneNumber = "";
  String? customerName = "";
  String? tableNumber = "";
  String? otherNotes = "";
  String _selectedItem = 'يوميا';
  bool? showKeyBoard = false;
  List _options = [
    "أول زيارة لي",
    'يوميا',
    'أسبوعيا',
    'شهريا',
    'بشكل غير منتظم'
  ];

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

  void listener() {
    if (myFocusNodes3.hasFocus) {
      setState(() {
        showKeyBoard = true;
      });
    } else {
      showKeyBoard = false;
    }
  }

  @override
  void initState() {
    super.initState();
    myFocusNodes3 = FocusNode()..addListener(listener);
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
    List<Map<String, dynamic>> questions = [];

    String otherNotesString = "";

    return Material(
      child: Scaffold(
          resizeToAvoidBottomInset: showKeyBoard,
          appBar: AppBar(
            backgroundColor: HexColor("#DDAF55"),
            title: Text("التقييم"),
          ),
          body: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Text("معلومات الزبون ",
                                style: TextStyle(
                                    color: HexColor("#eae6d9"),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                    alignment: Alignment.topRight,
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
                                Container(
                                  height: 350,
                                  child: Column(children: [
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
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                    color:
                                                        myFocusNodes2.hasFocus
                                                            ? Colors.white
                                                            : Colors.white38),
                                                hintText: "أسم الزبون"),
                                            onChanged: (text) {
                                              customerName = text;
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
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: PopupMenuButton(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: HexColor("#eae6d9"))),
                                      width: 200,
                                      height: 70,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              _selectedItem,
                                              style: TextStyle(
                                                  color: HexColor("#eae6d9"),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              size: 30,
                                              color: HexColor("#eae6d9"),
                                            ),
                                          ],
                                        ),
                                      )),
                                  itemBuilder: (BuildContext bc) {
                                    return _options
                                        .map((day) => PopupMenuItem(
                                              child: Text(
                                                day,
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              value: day,
                                            ))
                                        .toList();
                                  },
                                  onSelected: (value) {
                                    print(value);
                                    setState(() {
                                      _selectedItem = value.toString();
                                    });
                                  },
                                )),
                            Text("كم مرة تقوم بزيارة المطعم ؟",
                                style: TextStyle(
                                    color: HexColor("#eae6d9"),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ]))),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text("أعطنا رأيك ؟",
                      style: TextStyle(
                          color: HexColor("#eae6d9"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                  child: ListView(children: [
                QuestionListView(
                  controller: controller,
                  rating: (int id, int value) {
                    if (!hitMeRating.containsKey(id)) {
                      hitMeRating.addAll({id: value});
                      print(hitMeRating);
                    } else {
                      hitMeRating.update(id, (old_value) => value);
                    }
                  },
                ),
                QuestionText(
                  myFocusNodes3: myFocusNodes3,
                  txtController3: txtController3,
                  otherNotes: (otherss) {
                    otherNotesString = otherss;
                  },
                )
              ])),
              Container(
                child: InkWell(
                  onTap: () {
                    if (tableNumber != "" &&
                        phoneNumber != "" &&
                        customerName != "") {
                      setState(() {
                        isSent = true;
                      });
                      print(hitMeRating);
                      hitMeRating.forEach((key, value) {
                        questions.add({"question_id": key, "rating": value});
                      });

                      print('here');
                      print(otherNotesString);
                      HttpClient.instance.postRating(
                          "http://192.168.123.1:9000/api/submit-form",
                          {
                            "customer_name": customerName,
                            "customer_phone": phoneNumber,
                            "table_number": tableNumber,
                            "suggestion": otherNotesString,
                            "questions": questions,
                            "visit": _selectedItem,
                          },
                          (success, data) => {
                                if (success)
                                  {
                                    Navigator.of(context).pop(true),
                                    setState(() {
                                      isSent = false;
                                    }),
                                    showAlertDialogChecking(
                                        context: context,
                                        title: "",
                                        content: data?.data ?? "",
                                        defaultActionText: "تم"),
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
                                        defaultActionText: "تم"),
                                  }
                              });
                    } else {
                      setState(() {
                        isSent = false;
                      });
                      showAlertDialogChecking(
                          context: context,
                          title: "",
                          content: "بعض الحقول مطلوبة ",
                          defaultActionText: "تم");
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: HexColor("#eae6d9"),
                      height: 50,
                      child: Center(
                          child: isSent
                              ? CircularProgressIndicator()
                              : Text(
                                  "أرسال البيانات",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ))),
                ),
              )
            ],
          ))),
    );
  }
}

class QuestionText extends StatelessWidget {
  final Function(String otherNotes) otherNotes;
  final FocusNode myFocusNodes3;
  final TextEditingController txtController3;
  const QuestionText({
    Key? key,
    required this.otherNotes,
    required this.myFocusNodes3,
    required this.txtController3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text("الملاحظات الاخرى",
              style: TextStyle(
                  color: HexColor("#eae6d9"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Align(
            alignment: Alignment.topRight,
            child: TextField(
              focusNode: myFocusNodes3,
              maxLines: 4,
              style: TextStyle(
                  color: HexColor("#eae6d9"),
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
              keyboardType: TextInputType.text,
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
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  hintText: "ملاحظات اخرى"),
              onChanged: (text) {
                otherNotes(text);
                print("First text field: $text");
              },
            ),
          )),
    ]);
  }
}

class QuestionListView extends StatefulWidget {
  final GroupController controller;

  final Function(int id, int value) rating;
  QuestionListView({
    Key? key,
    required this.controller,
    required this.rating,
  }) : super(key: key);

  @override
  _QuestionListViewState createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  List<QuestionsResponse> questions = [];
  @override
  void initState() {
    HttpClient.instance
        .getAllQuestions("http://192.168.123.1:9000/api/form")
        .then((value) => questions.add(value));
    print(questions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BillProvider(),
        child: Consumer<BillProvider>(builder: (context, model, child) {
          if (model.item?.status == Status.COMPLETED) {
            var data = model.item?.data?.data?.questions;
            return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: data?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: HexColor("#eae6d9").withAlpha(70)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    data?[index].titleAr ?? "",
                                    style: TextStyle(
                                        color: HexColor("#eae6d9"),
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              SimpleGroupedChips<int>(
                                controller: widget.controller,
                                values: List.generate(7, (index) => index),
                                itemTitle: ["جيد", "متوسط", "دون الوسط"],
                                backgroundColorItem: Colors.black26,
                                textColor: HexColor("#eae6d9"),
                                isScrolling: false,
                                onItemSelected: (values) {
                                  widget.rating(
                                      data?[index].id ?? 0, values + 1);
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
                                color: HexColor("#eae6d9"),
                                size: 50,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0))),
                          ),
                        ]));
              },
            );
          } else {
            return model.item!.indicator ?? Container();
          }
        }));
  }
}
