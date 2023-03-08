import 'package:flutter/material.dart';
import 'package:menu_app/Languages/Localizations.dart';

import 'package:menu_app/extensions/alerts.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/extensions/key.dart';
import 'package:menu_app/network_modular/api_path.dart';
import 'package:menu_app/network_modular/http_request.dart';

class LoginViewController extends StatefulWidget {
  final bool isToken;
  LoginViewController({
    Key? key,
    required this.isToken,
  }) : super(key: key);

  @override
  _LoginViewControllerState createState() => _LoginViewControllerState();
}

class _LoginViewControllerState extends State<LoginViewController> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isSuccesss = false;
  String? token = "";

  Future getToken() {
    return ApplicationKeys.instance.getStringValue("token").then((value) => {
          setState(() {
            token = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: HexColor('#B08C42'),
          title: Text(
            "Device Login".getlocal(context),
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: widget.isToken
            ? SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    inputMethods(
                        username,
                        TextInputType.name,
                        Icons.email_rounded,
                        "Email ,Username ,Phone".getlocal(context),
                        false,
                        context),
                    SizedBox(
                      height: 13,
                    ),
                    inputMethods(password, TextInputType.name, Icons.person,
                        "Password".getlocal(context), false, context),
                    SizedBox(height: 40),
                    Material(
                        child: new InkWell(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                          child: Center(
                            child: isSuccesss
                                ? CircularProgressIndicator()
                                : Text("Login".getlocal(context),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(50))),
                      onTap: () {
                        if (username.text.isNotEmpty &&
                            password.text.isNotEmpty) {
                          setState(() {
                            isSuccesss = true;
                          });
                          print(APIPathHelper.getValue(APIPath.login));
                          HttpClient.instance.login(
                              APIPathHelper.getValue(APIPath.login),
                              context,
                              {
                                "email": username.text,
                                "password": password.text,
                              },
                              (onSuccess, data) => {
                                    print(data?.token),
                                    if (onSuccess)
                                      {
                                        setState(() {
                                          isSuccesss = false;
                                        }),
                                        ApplicationKeys.instance.setStringValue(
                                            "token", data!.token!),
                                        Navigator.pop(context)
                                      }
                                    else
                                      {
                                        setState(() {
                                          isSuccesss = false;
                                        }),
                                        showAlertDialogChecking(
                                            context: context,
                                            title: "Error".getlocal(context),
                                            content:
                                                "Error in Information , please try again"
                                                    .getlocal(context),
                                            defaultActionText:
                                                "Done".getlocal(context)),
                                      }
                                  });
                        } else {
                          showAlertDialogChecking(
                              context: context,
                              title: "Field required".getlocal(context),
                              content:
                                  "Please Fill The Required Fields To Complete Your Login"
                                      .getlocal(context),
                              defaultActionText: "Done".getlocal(context));
                        }
                      },
                    ))
                  ],
                ),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    ),
                    InkWell(
                      onTap: () {
                        ApplicationKeys.instance.removeValue("token");
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Center(
                              child: isSuccesss
                                  ? CircularProgressIndicator()
                                  : Text("Logout".getlocal(context),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                            ),
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    )
                  ],
                ),
              ));
  }

  Widget inputMethods(
      TextEditingController controller,
      TextInputType? inputType,
      IconData icon,
      String hint,
      bool obscureText,
      BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.123,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
            borderRadius: BorderRadius.circular(50)),
        child: Row(
          children: <Widget>[
            Container(
                width: 60,
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black54,
                )),
            Expanded(
              child: TextField(
                obscureText: obscureText,
                keyboardType: inputType,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: hint,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
