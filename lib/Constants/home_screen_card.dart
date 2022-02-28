
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Controller/theme_provider.dart';
import 'package:todo_softui/ThemeSetting/themes.dart';

class HomeScreenCard extends StatefulWidget {
  int iconDetail;
  String displayTxt;
  int numberOfTask;
  Color iconColor;

   HomeScreenCard({Key key,this.iconDetail,this.displayTxt,this.numberOfTask,this.iconColor}) : super(key: key);

  @override
  _HomeScreenCardState createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    // print('Number of task at home screen card is ${widget.numberOfTask}');
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          depth: 15,
          intensity: 0.5,
        ),
        child: Container(
           color: themeNotifier.getTheme() == darkTheme ? Colors.grey[700] : Colors.white,
          height: screenHeight * 0.21,
          width: screenWidth * 0.42,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // FontAwesome
                Icon(IconData(widget.iconDetail,fontFamily: 'MaterialIcons'), color: widget.iconColor??Colors.red, size: 40),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  widget.displayTxt,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text('${widget.numberOfTask} Tasks', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ));
  }
}
