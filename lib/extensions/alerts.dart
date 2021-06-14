import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

void showAlertDialog(BuildContext context) {
  CupertinoAlertDialog(
    title: Text("Log out?"),
    content: Text("Are you sure you want to log out?"),
    actions: <Widget>[
      CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel")),
    ],
  );
}

Future<bool?> showAlertDialogChecking({
  required BuildContext context,
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
}) async {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            child: Text(defaultActionText),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  // todo : showDialog for ios
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

void onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
          ],
        ),
      );
    },
  );
  new Future.delayed(new Duration(seconds: 3), () {});
}

Future<String> downloadData() async {
  //   var response =  await http.get('https://getProjectList');
  return Future.value("Data download successfully"); // return your response
}

void showPopupMenu(BuildContext context) async {
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(100, 100, 100, 100),
    items: [
      PopupMenuItem(
        value: 1,
        child: Text("View"),
      ),
      PopupMenuItem(
        value: 2,
        child: Text("Edit"),
      ),
      PopupMenuItem(
        value: 3,
        child: Text("Delete"),
      ),
    ],
    elevation: 8.0,
  ).then((value) {
    if (value != null) print(value);
  });
}

void displayDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => new CupertinoAlertDialog(
      title: new Text("Added"),
      content: new Text("Movies has been added to your watchlist"),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: new Text("Okay"),
          onPressed: () => {Navigator.pop(context)},
        )
      ],
    ),
  );
}
