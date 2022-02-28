

import 'package:flutter/material.dart';

final darkTheme = ThemeData(

  scaffoldBackgroundColor: Colors.grey.shade900,
  primaryColor: Colors.black,
   colorScheme: ColorScheme.dark(),
  iconTheme: IconThemeData(color: Colors.blue, opacity: 0.8),
  // inputDecorationTheme:

   primarySwatch: Colors.grey,
  //  scaffoldBackgroundColor: Colors.grey[900],
  // // colorScheme: ColorScheme.dark(),
  // // primaryColor: Colors.black,
  // brightness: Brightness.dark,
  // backgroundColor:  Colors.grey[900],
  // iconTheme: IconThemeData(color: Colors.yellow),
  // dividerColor: Colors.yellow,
);

final lightTheme = ThemeData(

  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.white,
  // colorScheme: ColorScheme.light(),
  iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),

   primarySwatch: Colors.blue,
  // // scaffoldBackgroundColor: Colors.white,
  // // colorScheme: ColorScheme.light(),
  // // primaryColor: Colors.white,
  // brightness: Brightness.light,
  // backgroundColor: Colors.white70,
  // // iconTheme: IconThemeData(color: Colors.black),
  // // dividerColor: Colors.black,
);