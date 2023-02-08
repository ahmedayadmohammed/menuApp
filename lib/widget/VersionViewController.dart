import 'package:flutter/material.dart';
import 'package:menu_app/Languages/Localizations.dart';
import 'package:menu_app/extensions/alerts.dart';
import 'package:menu_app/extensions/color.dart';
import 'package:menu_app/extensions/key.dart';
import 'package:menu_app/network_modular/api_response.dart';
import 'package:menu_app/providers/Version_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckVersionViewController extends StatefulWidget {
  CheckVersionViewController({Key? key}) : super(key: key);

  @override
  _CheckVersionViewControllerState createState() =>
      _CheckVersionViewControllerState();
}

class _CheckVersionViewControllerState
    extends State<CheckVersionViewController> {
  Future<void>? _launched;

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    ApplicationKeys.instance
        .getStringValue("version")
        .then((value) => appVersionKey = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: HexColor('#B08C42'),
          title: Text(
            "Login".getlocal(context),
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context) => VersionProvider(),
          child: Consumer<VersionProvider>(
            builder: (context, version, child) {
              if (version.version?.status == Status.COMPLETED) {
                var v = version.version?.data?.data;
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 100,
                            child: Image.asset(
                              "assets/mainlogo2.png",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        appVersionKey != v!.appVersion
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    _launched = _openUrl(v.apkUrl ?? "");
                                  });
                                },
                                child: Container(
                                    child: Center(
                                      child: Text("New Version Avialable Press To Download".getlocal(context),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18)),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        borderRadius:
                                            BorderRadius.circular(50))),
                              )
                            : Text("No Update Found In This Time".getlocal(context),
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 24))
                      ],
                    ),
                  ),
                );
              } else if (version.version?.status == Status.LOADING) {
                return version.version!.indicator!;
              } else if (version.version?.status == Status.ERROR) {
                return version.version!.indicator!;
              } else {
                return version.version!.indicator!;
              }
            },
          ),
        ));
  }
}
