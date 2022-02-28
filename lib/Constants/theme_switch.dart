import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Controller/theme_provider.dart';
import 'package:todo_softui/ThemeSetting/themes.dart';

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key key}) : super(key: key);

  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  var _darkTheme = true;

  void onThemeChanged(bool value, ThemeProvider themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Switch(
      activeColor: Theme.of(context).colorScheme.secondary,
      onChanged: (value) {
        setState(() {
          _darkTheme = value;
        });
        onThemeChanged(value, themeNotifier);
      },
      value: _darkTheme,
    );
  }
}