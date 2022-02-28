import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData themesData;

  ThemeProvider(this.themesData);

  getTheme() => themesData;

//  getTheme() {
//    return _themeData;
//  }

  setTheme(ThemeData themeData) async {
    print('Inside set theme');

    themesData = themeData;
    notifyListeners();
  }
}