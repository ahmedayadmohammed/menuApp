import 'package:flutter/cupertino.dart';

import '../extensions/key.dart';

class ChangeHomeLanguage with ChangeNotifier {
  var languageCode = "";
  getLocalTranslation() async {
    languageCode =
        await ApplicationKeys.instance.getStringValue("languageCode");
    notifyListeners();
  }
}
