// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, missing_return

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Constants/text_styles.dart';
import 'package:todo_softui/Controller/task_provider.dart';
import 'package:todo_softui/Controller/theme_provider.dart';
import 'package:todo_softui/Model/user_model.dart';
import 'package:todo_softui/Screens/user_profile.dart';
import 'package:todo_softui/ThemeSetting/themes.dart';

class DrawerData extends StatefulWidget {
  const DrawerData({Key key}) : super(key: key);

  @override
  _DrawerDataState createState() => _DrawerDataState();
}

class _DrawerDataState extends State<DrawerData> {
  var _darkTheme = true;
  void onThemeChanged(bool value, ThemeProvider themeNotifier) async {
    value ? themeNotifier.setTheme(darkTheme) : themeNotifier.setTheme(lightTheme);
  }
  @override
  void initState() {
    print('drawer screen initState');
    super.initState();
    getAllUserDataFromProvider();
  }

  final Color color1 = Color(0xff1e6faa);
  final Color color2 = Color(0xff65faf4);
  final Color color3 = Color(0xff14277d);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    String dummyUser = 'Sample User';
    String dummyEmail = 'Sample Email';

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  color1,
                  color2,
                ],
              ),
              boxShadow: [BoxShadow(color: color3, offset: Offset(2.0, 2.0), blurRadius: 5.0)]),
          child: FutureBuilder<List<Users>>(
            future: Provider.of<TaskProvider>(context, listen: false).getAllUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null || snapshot.data.isEmpty) {
                print('No data data');
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 42,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserProfile(dummyUser: dummyUser, dummyEmail: dummyEmail, isInsert: true)));
                            },
                            child: CircleAvatar(backgroundColor: Colors.white, radius: 40),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: SizedBox(
                            child: Column(
                              children: <Widget>[
                                Text(dummyUser, style: drawerHeaderStyle.copyWith(fontSize: 16)),
                                SizedBox(height: screenHeight * 0.015),
                                Text(dummyEmail, style: drawerHeaderStyle.copyWith(fontSize: 16)),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              } else {
                print('Snapshot has data');
                String _imgString = snapshot.data[0].userImage;
                final _bytesImage = Base64Decoder().convert(_imgString);
                Widget image = Image.memory(_bytesImage);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 42,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                          dummyUser: snapshot.data[0].userName,
                                          dummyEmail: snapshot.data[0].userEmail,
                                          isInsert: false,
                                          imageFromDb: MemoryImage(_bytesImage))));
                            },
                            child: CircleAvatar(
                                backgroundImage: MemoryImage(_bytesImage), backgroundColor: Colors.white, radius: 40),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: SizedBox(
                            child: Column(
                              children: <Widget>[
                                Text(snapshot.data[0].userName, style: drawerHeaderStyle.copyWith(fontSize: 16)),
                                SizedBox(height: screenHeight * 0.015),
                                Text(snapshot.data[0].userEmail, style: drawerHeaderStyle.copyWith(fontSize: 16)),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }
            },
          ),
        ),
        ListTile(
          trailing: Switch(
            activeColor: Colors.black,
            onChanged: (value) {
              print('This is value $value');
              setState(() {
                _darkTheme = value;
              });
              onThemeChanged(value, themeNotifier);
            },
            value: _darkTheme,
          ),
          title: Text('Dark Mode', style: kTitleStyle.copyWith(color: themeNotifier.getTheme() == darkTheme ? Colors.white : Colors.black)),
        ),
        ListTile(
          title: const Text('Item 2'),
          onTap: () {
            // Update the state of the app.
            // ...
          },
        ),
      ],
    );
  }

  void getAllUserDataFromProvider() async {
    await Provider.of<TaskProvider>(context, listen: false).getAllUserData();
  }
}
