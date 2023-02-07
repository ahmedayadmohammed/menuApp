import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_app/Languages/Localizations.dart';
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
  String _selectedItem = 'Daily';
  bool? showKeyBoard = false;
  List _options = [
    "It's my first time ",
    "Daily",
    "Weekly",
    "Monthly",
    "Irregular"
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
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Text("Customer Info".getlocal(context),
                                  style: TextStyle(
                                      color: HexColor("#eae6d9"),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Row(
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
                                            labelText: "Table Number"
                                                .getlocal(context),
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: myFocusNodes4.hasFocus
                                                    ? Colors.white
                                                    : Colors.white38),
                                            hintText: "Table Number"
                                                .getlocal(context)),
                                        onChanged: (text) {
                                          tableNumber = text;
                                        },
                                      ),
                                    )),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  height: 350,
                                  child: Column(children: [
                                    Container(
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
                                              labelText: "Customer Name"
                                                  .getlocal(context),
                                              labelStyle: TextStyle(
                                                  color: myFocusNodes2.hasFocus
                                                      ? Colors.white
                                                      : Colors.white38),
                                              hintText: "Customer Name"
                                                  .getlocal(context)),
                                          onChanged: (text) {
                                            customerName = text;
                                            print("First text field: $text");
                                          },
                                        )),
                                    Container(
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
                                              labelText: "Phone Number"
                                                  .getlocal(context),
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: myFocusNode.hasFocus
                                                      ? Colors.white
                                                      : Colors.white38),
                                              hintText: "Phone Number"
                                                  .getlocal(context)),
                                          onChanged: (text) {
                                            phoneNumber = text;
                                          },
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
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                                "How many times you visit the resturant"
                                    .getlocal(context),
                                style: TextStyle(
                                    color: HexColor("#eae6d9"),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                                padding: const EdgeInsets.all(8),
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
                                    setState(() {
                                      _selectedItem =
                                          value.toString().getlocal(context);
                                    });
                                  },
                                )),
                          ],
                        ),
                      ]))),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Give us your feedback".getlocal(context),
                        style: TextStyle(
                            color: HexColor("#eae6d9"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Expanded(
                  child: ListView(children: [
                QuestionListView(
                  controller: controller,
                  rating: (object) {
                    object.forEach((key, value) {
                      hitMeRating.addAll({key: value});
                    });
                    // print(hitMeRating);
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
                      questions.clear();
                      hitMeRating.forEach((key, value) {
                        questions.add({
                          "question_id": key,
                          "rating": value["values"],
                          "note": value["note"]
                        });
                      });

                      print(questions);
                      HttpClient.instance.postRating(
                          "https://menu.baythalab.com/api/submit-form",
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
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text("Other Notes".getlocal(context),
                style: TextStyle(
                    color: HexColor("#eae6d9"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
        ],
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
                  hintText: "Other Notes".getlocal(context)),
              onChanged: (text) {
                otherNotes(text);
              },
            ),
          )),
    ]);
  }
}

class QuestionListView extends StatefulWidget {
  final GroupController controller;

  final Function(Map<int, Map<dynamic, dynamic>>) rating;
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

  Map<int, Map<dynamic, dynamic>> listOfMap = {};
  List<TextEditingController> textList = [];
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
                for (int i = 0; i < data!.length; i++) {
                  textList.add(TextEditingController());
                }

                return Container(
                    margin: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: HexColor("#eae6d9").withAlpha(70)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        SizedBox(width: 15),
                        Icon(
                          Icons.rate_review,
                          color: HexColor("#eae6d9"),
                          size: 50,
                        ),
                        SizedBox(width: 50),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data[index].titleAr ?? "",
                                style: TextStyle(
                                    color: HexColor("#eae6d9"), fontSize: 20),
                              ),
                            ),
                            SimpleGroupedChips<int>(
                                controller: widget.controller,
                                values: List.generate(7, (index) => index),
                                itemTitle: [
                                  "Bad".getlocal(context),
                                  "Mediocre".getlocal(context),
                                  "Medium".getlocal(context),
                                  "Good".getlocal(context),
                                  "Very Good".getlocal(context)
                                ],
                                backgroundColorItem: Colors.black26,
                                textColor: HexColor("#eae6d9"),
                                isScrolling: false,
                                onItemSelected: (values) {
                                  var value = {
                                    "values": values + 1,
                                    "id": data[index].id,
                                    "note": ""
                                  };
                                  listOfMap[data[index].id!] = value;

                                  widget.rating(listOfMap);
                                  setState(() {});
                                }),
                            listOfMap.containsKey(data[index].id!) &&
                                    listOfMap[data[index].id!]?["values"] <= 3
                                ? Builder(builder: (context) {
                                    return SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: inputMethods(
                                          textList[index],
                                          TextInputType.text,
                                          Icons.lock,
                                          "Reason".getlocal(context),
                                          false,
                                          context, onChanged: (text) {
                                        listOfMap[data[index].id!]?["note"] =
                                            text;
                                        widget.rating(listOfMap);
                                        setState(() {});
                                      }),
                                    );
                                  })
                                : Builder(builder: (context) {
                                    return SizedBox();
                                  })
                          ],
                        ),
                      ]),
                    ));
              },
            );
          } else {
            return model.item!.indicator ?? Container();
          }
        }));
  }
}

Widget inputMethods(TextEditingController controller, TextInputType? inputType,
    IconData icon, String hint, bool obscureText, BuildContext context,
    {bool? enabel, Function(String title)? onChanged, Color? backgroundColor}) {
  return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  if (onChanged != null) {
                    onChanged(value);
                  }
                },
                obscureText: obscureText,
                keyboardType: inputType,
                controller: controller,
                enabled: enabel,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.7),
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey[300], fontSize: 16),
                    labelStyle: const TextStyle(fontSize: 14)),
              ),
            )
          ],
        ),
      ),
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withOpacity(0.15),
          // border: Border.all(
          //   color: HexColor("#A3C7D6"),
          //   width: 1,
          // ),
          borderRadius: const BorderRadius.all(Radius.circular(50.0))));
}
