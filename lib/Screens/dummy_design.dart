// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({Key key}) : super(key: key);

  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {

  List<String> services = ['ball','joystick','bat'];
  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: <Widget>[
          Container(
            height: ScreenHeight * 0.05,
            width: ScreenWidth * 0.18,
            child: ListView.builder(
                itemCount: services.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(

                    child: Text(services[index]),
                  );
                }),
          )
        ],
      ),
    );
  }
}
