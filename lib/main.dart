import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Controller/task_provider.dart';
import 'package:todo_softui/Screens/dummy_design.dart';
import 'package:todo_softui/Screens/home_screen.dart';
import 'Controller/theme_provider.dart';
import 'Services/notification_services.dart';
import 'ThemeSetting/themes.dart';

void main() {
  NotificationService().initAwesomeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(
          create: (BuildContext context) {
            return TaskProvider();
          },
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (BuildContext context) {
            return ThemeProvider(lightTheme);
          },
        )
      ],
      builder: (context , child){
        final themeNotifier = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          theme: themeNotifier.getTheme(),
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },

    );

    // return ChangeNotifierProvider(
    //   create: (context) => TaskProvider(),
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     builder: EasyLoading.init(),
    //     home: HomeScreen(),
    //     ),
    // );
  }
}
