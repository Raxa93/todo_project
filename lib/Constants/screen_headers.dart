
// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

buildHeader(String message) {
  final Color color1 = Color(0xff1e6faa);
  final Color color2 = Color(0xff65fae4);
  final Color color3 = Color(0xff14277d);
  return Container(
    height: 250,
    width: double.infinity,
    child: Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          left: -50,
          // right: -150,
          top: -190,
          child: Container(
            width: 450,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [color1, color2]
                ),
                boxShadow: [
                  BoxShadow(
                      color: color2,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 10.0
                  )
                ]
            ),
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [color3, color2]
              ),
              boxShadow: [
                BoxShadow(
                    color: color3,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 4.0
                )
              ]
          ),
        ),
        Positioned(
          top: 160,
          right: 60,
          child: Container(
            width: 60,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [color3, color2]
                ),
                boxShadow: [
                  BoxShadow(
                      color: color3,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 4.0
                  )
                ]
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
              top: 110,
              left: 30
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Welcome !", style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.w700
              ),),
              SizedBox(height: 10.0),
              Text(message,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                ),)
            ],
          ),
        )
      ],
    ),
  );
}