// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, unused_import, unused_field, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:todo_softui/Constants/specif_task_card.dart';
import 'package:todo_softui/Controller/task_provider.dart';
import 'package:todo_softui/Controller/theme_provider.dart';
import 'package:todo_softui/Model/category_model.dart';
import 'package:todo_softui/Model/todo_model.dart';
import 'package:todo_softui/ThemeSetting/themes.dart';

import 'add_new_task.dart';

class SpecificCategoryTask extends StatefulWidget {
  int headerIcon;
  String taskCategory;
  int taskNumber;

  SpecificCategoryTask({Key key, this.headerIcon, this.taskNumber, this.taskCategory}) : super(key: key);

  @override
  _SpecificCategoryTaskState createState() => _SpecificCategoryTaskState();
}

class _SpecificCategoryTaskState extends State<SpecificCategoryTask> {
  bool _checkbox = false;
  bool _pianoCheckBox = false;
  Future<List<Todo>> specificTaskDetail;
  bool _learnSpanish = false;

  @override
  void initState() {
    print('Specific screen initState');
    getSpecifCategoryTasksFromProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final themeNotifier = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeNotifier.getTheme() == darkTheme ? Colors.grey[800] : Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 11.0, top: 10),
              child: Icon(
                Icons.share,
                size: 20,
              ),
            )
          ],
        ),
        body: FutureBuilder<List<Todo>>(
          future: specificTaskDetail,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // print('Snapshot size is ${snapshot.data.length}');
              return Center(child: Text('No task added Yet'));
            } else {
              return Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.bottomCenter,
                        color: Colors.blue,
                        child: Container(
                          height: screenHeight * 0.6,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              color: themeNotifier.getTheme() == darkTheme ? Colors.grey[700] : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(30.0),
                                topRight: const Radius.circular(30.0),
                              )),
                          child: Padding(
                              padding: EdgeInsets.only(left: 22, top: 10),
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return
                                      AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: const Duration(milliseconds: 1900),
                                        child: SlideAnimation(
                                           verticalOffset: 70.0,
                                          horizontalOffset: 120.0,
                                          child: FadeInAnimation(
                                            child: SpecificTaskCard(
                                              todoItem: snapshot.data[index]
                                              ),
                                          ),
                                        ),
                                      );
                                  },
                                ),
                              )),
                        )
                    ),
                    Positioned(
                        top: screenHeight * 0.02,
                        left: screenWidth * 0.07,
                        child: CircleAvatar(
                          radius: screenHeight * 0.05,
                          backgroundColor:  themeNotifier.getTheme() == darkTheme ? Colors.black : Colors.white,
                          child: Icon(IconData(widget.headerIcon,fontFamily: 'MaterialIcons'), size: 30),
                        )),
                    Positioned(
                        top: screenHeight * 0.13,
                        left: screenWidth * 0.07,
                        child: Text(widget.taskCategory,
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: themeNotifier.getTheme() == darkTheme ? Colors.black : Colors.white))),
                    Positioned(
                        top: screenHeight * 0.19,
                        left: screenWidth * 0.07,
                        child: Text('${widget.taskNumber} Tasks'.toString(),
                            style: TextStyle(fontSize: 20, color: themeNotifier.getTheme() == darkTheme ? Colors.black : Colors.white))),
                  ],
                ),
              );
            }
          },
        ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.deepPurpleAccent,
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        elevation: 12.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.add_task_outlined),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Add New Task',
            labelStyle: TextStyle(fontSize: 10.0),
            onTap: () => {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddNewTask()))},
          ),
        ],
      ),
    );
  }

  void getSpecifCategoryTasksFromProvider() async {
    // Provider.of<TaskProvider>(context, listen: false).getAllTasksForSpecificCategory(widget.taskCategory);
    TaskProvider taskprovider = TaskProvider();
    specificTaskDetail = taskprovider.getAllTasksForSpecificCategory(widget.taskCategory);
  }
}
